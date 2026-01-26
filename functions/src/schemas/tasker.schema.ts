/**
 * tasker.schema.ts
 * 
 * Zod schemas for the Task Deconstructor AI module.
 * Defines input validation and output structure.
 */

import { z } from 'zod';

/**
 * Input schema for tasker AI.
 * Validates the user's task input.
 */
export const TaskerInputSchema = z.object({
    userInput: z.string()
        .min(1, 'Task input cannot be empty')
        .max(5000, 'Task input is too long (max 5000 characters)'),
    sessionId: z.string()
        .min(1, 'Session ID is required'),
});

export type TaskerInput = z.infer<typeof TaskerInputSchema>;

/**
 * Schema for a single task step.
 */
export const TaskStepSchema = z.object({
    stepNumber: z.number().int().positive(),
    description: z.string().min(1),
    completed: z.boolean().default(false),
});

export type TaskStep = z.infer<typeof TaskStepSchema>;

/**
 * Output schema for tasker AI.
 * Defines the structure of the AI's response.
 */
export const TaskerOutputSchema = z.object({
    taskTitle: z.string()
        .min(1, 'Task title cannot be empty')
        .max(200, 'Task title is too long'),
    steps: z.array(TaskStepSchema)
        .min(1, 'At least one step is required')
        .max(20, 'Too many steps (max 20)'),
    estimatedDuration: z.string().optional(),
    difficulty: z.enum(['easy', 'medium', 'hard']).optional(),
});

export type TaskerOutput = z.infer<typeof TaskerOutputSchema>;

/**
 * HTTP response schema for the tasker endpoint.
 */
export const TaskerResponseSchema = z.object({
    success: z.boolean(),
    data: TaskerOutputSchema.optional(),
    error: z.string().optional(),
    sessionId: z.string(),
});

export type TaskerResponse = z.infer<typeof TaskerResponseSchema>;
