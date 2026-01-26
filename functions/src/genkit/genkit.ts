/**
 * genkit.ts
 * 
 * Genkit configuration - SINGLE SOURCE OF TRUTH.
 * This file configures Genkit plugins and exports utilities.
 * All flows must import from this file.
 */

import { googleAI, gemini15Flash } from '@genkit-ai/googleai';
import { config, validateConfig } from '../config/env';

// Validate environment configuration on import
validateConfig();

/**
 * Configure Google AI plugin.
 * This happens ONCE when the module is first imported.
 */
googleAI({
    apiKey: config.googleApiKey,
});

console.log('✅ Genkit configured successfully');

// Re-export defineFlow and generate for use in flows
export { defineFlow } from '@genkit-ai/flow';
export { generate } from '@genkit-ai/ai';
export { gemini15Flash };
