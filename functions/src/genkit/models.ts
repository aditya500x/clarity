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
 * @param module - The AI module name ('tasker', 'paragraph', or 'chatbot')
 * @returns Model configuration object
 */
export function getModelConfig(module: 'tasker' | 'paragraph' | 'chatbot') {
    return {
        model: CONSTANTS.MODEL_NAME,
        temperature: CONSTANTS.TEMPERATURE[module.toUpperCase() as keyof typeof CONSTANTS.TEMPERATURE],
        maxOutputTokens: CONSTANTS.MAX_OUTPUT_TOKENS[module.toUpperCase() as keyof typeof CONSTANTS.MAX_OUTPUT_TOKENS],
    };
}
