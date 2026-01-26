/**
 * models.ts
 * 
 * Model definitions for Genkit.
 * Exports configured Gemini models for use in flows.
 */

import { gemini15Flash } from '@genkit-ai/googleai';
import { CONSTANTS } from '../config/constants';

/**
 * Gemini 1.5 Flash model for general use.
 * This is the primary model used across all AI modules.
 */
export const geminiModel = gemini15Flash;

/**
 * Get model configuration for a specific AI module.
 * 
 * @param module - The AI module name ('TASKER', 'PARAGRAPH', or 'CHATBOT')
 * @returns Model configuration object
 */
export function getModelConfig(module: 'TASKER' | 'PARAGRAPH' | 'CHATBOT') {
    return {
        temperature: CONSTANTS.TEMPERATURE[module],
        maxOutputTokens: CONSTANTS.MAX_OUTPUT_TOKENS[module],
    };
}
