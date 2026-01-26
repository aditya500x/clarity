/**
 * genkit.ts
 * 
 * Genkit initialization - SINGLE SOURCE OF TRUTH.
 * This file initializes Genkit ONCE and exports the configured instance.
 * All flows must import and use this instance.
 */

import { genkit } from 'genkit';
import { googleAI } from '@genkit-ai/googleai';
import { config, validateConfig } from '../config/env';

// Validate environment configuration on import
validateConfig();

/**
 * Initialize Genkit with Google AI plugin.
 * This happens ONCE when the module is first imported.
 */
export const ai = genkit({
    plugins: [
        googleAI({
            apiKey: config.googleApiKey,
        }),
    ],
    // Enable logging in development
    logLevel: config.isDevelopment ? 'debug' : 'info',
});

console.log('✅ Genkit initialized successfully');
