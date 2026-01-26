/**
 * genkit.ts
 * 
 * Genkit configuration - SINGLE SOURCE OF TRUTH.
 * This file configures Genkit plugins and exports utilities.
 * All flows must import from this file.
 */

import { configureGenkit } from '@genkit-ai/core';
import { googleAI } from '@genkit-ai/googleai';
import { config, validateConfig } from '../config/env';

// Validate environment configuration on import
validateConfig();

/**
 * Configure Genkit with Google AI plugin.
 * This happens ONCE when the module is first imported.
 */
configureGenkit({
    plugins: [
        googleAI({
            apiKey: config.googleApiKey,
        }),
    ],
    logLevel: config.isDevelopment ? 'debug' : 'info',
    enableTracingAndMetrics: false,
});

console.log('✅ Genkit configured successfully');

// Re-export defineFlow and generate for use in flows
export { defineFlow } from '@genkit-ai/flow';
export { generate } from '@genkit-ai/ai';
// Use gemini-1.5-flash model (valid Genkit model identifier)
export const geminiModel = 'googleai/gemini-1.5-flash';
