/**
 * index.ts
 * 
 * Firebase Cloud Functions entry point.
 * 
 * This file ONLY exports HTTP functions.
 * NO business logic here.
 * NO AI logic here.
 */

import { onRequest } from 'firebase-functions/v2/https';
import { handleTaskerRequest } from './http/tasker';

/**
 * Task Deconstructor AI endpoint.
 * 
 * POST /tasker_ai
 * Body: { userInput: string, sessionId: string }
 * 
 * Returns: { success: boolean, data?: TaskerOutput, error?: string, sessionId: string }
 */
export const tasker_ai = onRequest(
    {
        cors: true,
        maxInstances: 10,
        timeoutSeconds: 60,
        memory: '512MiB',
    },
    handleTaskerRequest
);

console.log('✅ Firebase Functions exported');
