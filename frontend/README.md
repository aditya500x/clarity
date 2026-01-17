# Clarity Flutter UI - Complete Documentation

## 📚 Project Overview

**Clarity** is an accessibility-first Flutter mobile application designed for neurodivergent students (ADHD, dyslexia, anxiety). The UI follows Material 3 principles with a focus on minimal cognitive load, large tap targets, and a calming pastel aesthetic.

---

## 🎨 Design System

### Color Palette

| Color | Hex | Purpose |
|-------|-----|---------|
| Mint Green | `#A8D5BA` | Primary actions, emphasis |
| Muted Blue | `#B8C9E8` | Secondary actions |
| Soft Lavender | `#E6D5F5` | Accent, panic button |
| Warm Cream | `#FBF7F0` | Background |
| Light Cream | `#F5F0E8` | Surface/cards |
| Soft Black | `#3D3D3D` | Primary text |
| Medium Gray | `#6B6B6B` | Secondary text |

**Design Rationale**: Soft pastels create a calming environment while maintaining WCAG AA contrast ratios (4.5:1 for body text, 3:1 for large text).

### Typography

```dart
Display Large: 32px, Weight 600, Letter spacing 0.5px
Display Medium: 28px, Weight 600, Letter spacing 0.5px
Headline: 24px, Weight 500
Title: 20px, Weight 500
Body Large: 18px, Weight 400, Line height 1.6
Body: 16px, Weight 400, Line height 1.6
Label: 14px, Weight 500
Caption: 12px, Weight 400
```

**Accessibility Features**:
- Large base font sizes (16-18px minimum)
- Increased line height (1.6) reduces visual crowding
- Letter spacing aids dyslexic readers
- OpenDyslexic font support (placeholder)

### Spacing

Based on 8px grid system:
- **XS**: 4px
- **S**: 8px
- **M**: 16px
- **L**: 24px
- **XL**: 32px
- **XXL**: 48px
- **Min Tap Target**: 48dp (Material guideline)
- **Recommended Tap Target**: 56dp (Clarity standard)

### Border Radius
- **Small**: 8px
- **Medium**: 16px
- **Large**: 24px
- **XLarge**: 32px

---

## 🧩 Component Library

### 1. AppCard
**Purpose**: Large, tappable navigation cards for home screen options

**Props**:
- `icon`: IconData - Main icon
- `title`: String - Card title
- `description`: String - Helper text
- `onTap`: VoidCallback - Tap handler
- `backgroundColor`: Color? - Optional custom background
- `iconColor`: Color? - Optional custom icon color

**Features**:
- 64x64 icon container with rounded background
- Clear visual hierarchy with title and description
- Arrow indicator for tap affordance
- InkWell ripple effect

**Usage**:
```dart
AppCard(
  icon: Icons.checklist_rounded,
  title: 'Break Down a Task',
  description: 'Turn big assignments into small steps',
  iconColor: AppColors.primary,
  onTap: () => Navigator.push(...),
)
```

---

### 2. AppButton
**Purpose**: Accessible button with large tap targets

**Props**:
- `text`: String - Button label
- `onPressed`: VoidCallback? - Tap handler
- `variant`: AppButtonVariant - primary, secondary, or text
- `icon`: IconData? - Optional leading icon
- `isFullWidth`: bool - Stretch to full width (default: true)

**Variants**:
- **Primary**: Solid background, high emphasis
- **Secondary**: Outlined style, medium emphasis
- **Text**: Minimal style, low emphasis

**Features**:
- 56dp minimum height for easy tapping
- Clear disabled state (when onPressed is null)
- Icon + text support

**Usage**:
```dart
AppButton(
  text: 'Break This Into Steps',
  onPressed: () => handleBreakdown(),
  icon: Icons.auto_fix_high_rounded,
  variant: AppButtonVariant.primary,
)
```

---

### 3. AppTextField
**Purpose**: Accessible text input with clear labels and hints

**Props**:
- `label`: String? - Field label (above input)
- `hint`: String? - Placeholder text
- `controller`: TextEditingController?
- `maxLines`: int - Number of lines (default: 1)
- `minLines`: int? - Minimum lines for multiline
- `keyboardType`: TextInputType?
- `enabled`: bool - Enable/disable input
- `validator`: String? Function(String?)?
- `onChanged`: void Function(String)?

**Features**:
- Large 18px font size
- Prominent focus border (2px primary color)
- Rounded corners for softer appearance
- Support for multiline input

**Usage**:
```dart
AppTextField(
  label: 'Your Task',
  hint: 'Type your assignment here...',
  controller: taskController,
  maxLines: 8,
  minLines: 8,
)
```

---

### 4. StepChecklistCard
**Purpose**: Gamified task step with checkbox and visual emphasis

**Props**:
- `title`: String - Step description
- `timeEstimate`: String - Duration estimate (e.g., "5 minutes")
- `isCompleted`: bool - Completion state
- `isCurrent`: bool - Whether this is the active step
- `onCheckChanged`: Function(bool) - Checkbox handler

**Features**:
- Large 1.3x scaled checkbox for easy tapping
- Visual emphasis for current step (border, background color)
- Time estimate with clock icon
- "Current" badge for active step
- Smooth scale animation on check/uncheck
- Strikethrough text when completed

**Usage**:
```dart
StepChecklistCard(
  title: 'Research the topic',
  timeEstimate: '15 minutes',
  isCompleted: false,
  isCurrent: true,
  onCheckChanged: (value) => handleStepChange(index, value),
)
```

---

### 5. PanicButton
**Purpose**: Large floating button for quick access to calming mode

**Props**:
- `onPressed`: VoidCallback - Tap handler
- `label`: String - Button text (default: "I'm Feeling Overwhelmed")

**Features**:
- Soft lavender color (calming)
- Heart icon (symbolizes care)
- Full-width layout at bottom of screen
- Gradient overlay for depth
- 4px elevation with soft shadow
- 56dp height for easy thumb access

**Usage**:
```dart
PanicButton(
  onPressed: () => Navigator.push(context, PanicModeScreen()),
)
```

---

## 📱 Screens

### 1. Home Screen

**Path**: `lib/screens/home_screen.dart`

**Layout**:
```
├─ SafeArea
   ├─ Header: "What do you want help with today?"
   ├─ Scrollable ListView
   │  ├─ AppCard: Break Down a Task
   │  ├─ AppCard: Read Safely
   │  └─ AppCard: Ask a Tutor
   └─ PanicButton (fixed at bottom)
```

**Features**:
- Three large navigation options
- Calming header text
- Panic button always accessible
- "Coming soon" dialogs for unimplemented features

---

### 2. Task Input Screen

**Path**: `lib/screens/task_input_screen.dart`

**Layout**:
```
├─ AppBar with back button
├─ SafeArea
   ├─ Instruction text
   ├─ Large multiline text field
   ├─ Photo upload hint (coming soon)
   └─ CTA: "Break This Into Steps"
```

**Features**:
- Center-aligned layout
- Large 8-line text field
- Helpful placeholder text
- Validation (shows error if empty)
- Clear back navigation

---

### 3. Task Output Screen

**Path**: `lib/screens/task_output_screen.dart`

**Layout**:
```
├─ AppBar
├─ Linear progress indicator
├─ Progress percentage text
├─ Task title
├─ Scrollable checklist
│  └─ StepChecklistCard (multiple)
└─ Sticky bottom bar
   └─ "Read This Step Aloud" button
```

**Features**:
- Real-time progress tracking
- Current step visual emphasis
- Completion celebration dialog
- Read aloud button (placeholder)
- Demo steps (in production, would come from backend)

**Demo Steps**:
1. Research the topic (15 min)
2. Create an outline (10 min)
3. Write introduction (10 min)
4. Write body paragraphs (25 min)
5. Write conclusion (10 min)
6. Review and edit (15 min)

---

### 4. Panic Mode Screen

**Path**: `lib/screens/panic_mode_screen.dart`

**Layout**:
```
├─ Soft lavender background (full screen)
├─ SafeArea
   ├─ Breathing instruction text
   ├─ Animated breathing circle
   ├─ Breath counter
   ├─ "I'm Ready to Continue" button (after completion)
   └─ Exit button
```

**Features**:
- Guided breathing exercise (3 breaths)
- Smooth scale animation (8 seconds per breath)
- Heart icon inside breathing circle
- Calming color palette
- Text changes: "Breathe in slowly..." → "Breathe out gently..."
- Completion message: "You're doing great! 💙"

**Animation Details**:
- 4 seconds breathe in (scale 0.8 → 1.2)
- 4 seconds breathe out (scale 1.2 → 0.8)
- Soft glow shadow on circle
- Auto-restart until 3 breaths completed

---

## ♿ Accessibility Features

### Screen Reader Support
- Semantic labels on all interactive elements
- Proper reading order for content
- State announcements for checkboxes
- Meaningful button labels

### Visual Accessibility
- **Contrast**: WCAG AA compliant (4.5:1 minimum)
- **Font Scaling**: Respects system font size settings
- **No Pure White**: Reduces eye strain
- **Clear Hierarchy**: Size, weight, color differentiate content

### Motor Accessibility
- **Large Tap Targets**: 56dp minimum (exceeds 48dp guideline)
- **Generous Spacing**: Reduces mis-taps
- **Clear Affordances**: Visual indicators for interactive elements

### Cognitive Accessibility
- **Minimal Clutter**: One primary action per screen
- **Short Sentences**: Easy to parse
- **Progress Indicators**: Clear completion status
- **Friendly Tone**: Encouraging, not clinical

---

## 🚀 Running the App

### Prerequisites
- Flutter SDK (3.0+)
- iOS Simulator or Android Emulator
- Dart 3.0+

### Commands

```bash
# Navigate to frontend folder
cd frontend

# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Run on specific device
flutter run -d <device_id>

# Run on Chrome (web)
flutter run -d chrome

# Build for production
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
```

---

## 📂 File Structure

```
frontend/
├── lib/
│   ├── main.dart                      # App entry point
│   ├── theme/
│   │   ├── app_theme.dart            # Material 3 theme config
│   │   ├── app_colors.dart           # Color palette
│   │   ├── app_text_styles.dart      # Typography system
│   │   └── app_spacing.dart          # Spacing constants
│   ├── widgets/
│   │   ├── app_card.dart             # Navigation card
│   │   ├── app_button.dart           # Accessible button
│   │   ├── app_text_field.dart       # Text input
│   │   ├── step_checklist_card.dart  # Task step card
│   │   └── panic_button.dart         # Panic mode trigger
│   └── screens/
│       ├── home_screen.dart          # Main navigation
│       ├── task_input_screen.dart    # Task entry
│       ├── task_output_screen.dart   # Deconstructed steps
│       └── panic_mode_screen.dart    # Calming mode
├── pubspec.yaml                       # Dependencies
└── README.md                          # This file
```

---

## 🎯 Next Steps

### Backend Integration
- Connect to AI service for task breakdown
- Implement text-to-speech for "Read Aloud"
- Add photo upload for assignment scanning

### Additional Features
- **Sensory-Safe Reader**: Customizable reading view
- **Socratic Buddy**: Guided tutoring chat
- **Settings**: Font family toggle, color themes
- **User Accounts**: Save tasks and progress

### Testing
- Widget tests for all components
- Integration tests for user flows
- Accessibility audit with screen readers
- User testing with neurodivergent students

---

## 🎨 Design Highlights

✅ **Soft Pastel Palette**: Calming mint, blue, and lavender  
✅ **Large Typography**: 16-18px minimum, 1.6 line height  
✅ **Generous Tap Targets**: 56dp for easy interaction  
✅ **Smooth Animations**: Breathing circle, checklist feedback  
✅ **Clear Hierarchy**: Size, weight, color guide attention  
✅ **Friendly Tone**: Encouraging, student-centric language  
✅ **Panic Button**: Always accessible calming mode  
✅ **Progress Tracking**: Visual feedback on task completion  

---

## 📖 Widget API Reference

All custom widgets are stateless or internally managed, making them easy to use and test.

### AppCard
```dart
AppCard({
  required IconData icon,
  required String title,
  required String description,
  required VoidCallback onTap,
  Color? backgroundColor,
  Color? iconColor,
})
```

### AppButton
```dart
AppButton({
  required String text,
  required VoidCallback? onPressed,
  AppButtonVariant variant = AppButtonVariant.primary,
  IconData? icon,
  bool isFullWidth = true,
})
```

### AppTextField
```dart
AppTextField({
  String? label,
  String? hint,
  TextEditingController? controller,
  int maxLines = 1,
  int? minLines,
  TextInputType? keyboardType,
  bool enabled = true,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
})
```

### StepChecklistCard
```dart
StepChecklistCard({
  required String title,
  required String timeEstimate,
  required bool isCompleted,
  required bool isCurrent,
  required Function(bool) onCheckChanged,
})
```

### PanicButton
```dart
PanicButton({
  required VoidCallback onPressed,
  String label = "I'm Feeling Overwhelmed",
})
```

---

**Built with ❤️ for neurodivergent students**
