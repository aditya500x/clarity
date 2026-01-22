from sqlalchemy import (
    create_engine,
    Column,
    Integer,
    String,
    Text,
    Boolean,
    DateTime,
    ForeignKey
)
from sqlalchemy.orm import declarative_base, relationship, sessionmaker
from datetime import datetime

# Database configuration
DATABASE_URL = "sqlite:///./app.db"

engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False}  # required for SQLite + FastAPI
)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()

# Tables
class Task(Base):
    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True, autoincrement=True)
    session_id = Column(String, nullable=False)

    input_method = Column(String, nullable=False)      # paragraph | audio | photo
    input_data = Column(Text, nullable=False)          # final processed text

    task_title = Column(String)
    status = Column(String, nullable=False, default="active")  # active | completed

    created_at = Column(DateTime, default=datetime.utcnow)
    completed_at = Column(DateTime, nullable=True)

    # relationship
    steps = relationship(
        "TaskStep",
        back_populates="task",
        cascade="all, delete-orphan"
    )


class TaskStep(Base):
    __tablename__ = "task_steps"

    id = Column(Integer, primary_key=True, autoincrement=True)
    task_id = Column(Integer, ForeignKey("tasks.id"), nullable=False)

    step_index = Column(Integer, nullable=False)
    step_text = Column(Text, nullable=False)

    is_completed = Column(Boolean, nullable=False, default=False)
    status = Column(String, nullable=False, default="active")  # active | inactive

    created_at = Column(DateTime, default=datetime.utcnow)
    completed_at = Column(DateTime, nullable=True)

    # relationship
    task = relationship("Task", back_populates="steps")


# Dependency (FastAPI)
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Create tables
def init_db():
    Base.metadata.create_all(bind=engine)
