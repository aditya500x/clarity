/**
 * tasker.ts
 * 
 * HTTP handler for the Task Deconstructor AI endpoint.
 * 
 * This handler:
 * 1. Validates incoming HTTP requests
 * 2. Calls the tasker flow
 * 3. Returns JSON responses
 * 
 * NO AI logic here - pure HTTP handling.
 */

import { Request, Response } from 'firebase-functions/v2/https';
import { taskerFlow } from '../flows/tasker.flow';
import { TaskerInputSchema, type TaskerResponse } from '../schemas/tasker.schema';
import { getErrorMessage } from '../utils/safety_helpers';

/**
 * Handle tasker AI requests.
 * 
 * Expected request body:
 * {
 *   "userInput": "string",
 *   "sessionId": "string"
 * }
 * 
 * Returns:
 * {
 *   "success": boolean,
 *   "data": TaskerOutput | undefined,
 *   "error": string | undefined,
 *   "sessionId": string
 * }
 */
export async function handleTaskerRequest(req: Request, res: Response): Promise<void> {
    try {
        console.log('[Tasker HTTP] Received request');

        // Validate request method
        if (req.method !== 'POST') {
            res.status(405).json({
                success: false,
                error: 'Method not allowed. Use POST.',
                sessionId: '',
            } as TaskerResponse);
            return;
        }

        // Parse and validate request body
        let validatedInput;
        try {
            validatedInput = TaskerInputSchema.parse(req.body);
        } catch (validationError: any) {
            console.error('[Tasker HTTP] Validation error:', validationError);
            res.status(400).json({
                success: false,
                error: `Invalid request: ${validationError.message || 'Validation failed'}`,
                sessionId: req.body?.sessionId || '',
            } as TaskerResponse);
            return;
        }

        console.log(`[Tasker HTTP] Processing for session: ${validatedInput.sessionId}`);

        // Call the tasker flow
        const result = await taskerFlow(validatedInput);

        // Return success response
        res.status(200).json({
            success: true,
            data: result,
            sessionId: validatedInput.sessionId,
        } as TaskerResponse);

        console.log('[Tasker HTTP] Request completed successfully');

    } catch (error) {
        console.error('[Tasker HTTP] Error:', error);

        // Return error response
        res.status(500).json({
            success: false,
            error: getErrorMessage(error),
            sessionId: req.body?.sessionId || '',
        } as TaskerResponse);
    }
}
