/**
 * safety_helpers.ts
 * 
 * Utilities for handling AI safety settings and response validation.
 */

import { HarmCategory, HarmBlockThreshold } from '@genkit-ai/googleai';

/**
 * Get safety settings for Gemini API.
 * Blocks medium and above harmful content.
 */
export function getSafetySettings() {
    return [
        {
            category: HarmCategory.HARM_CATEGORY_HATE_SPEECH,
            threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
        },
        {
            category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
            threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
        },
        {
            category: HarmCategory.HARM_CATEGORY_HARASSMENT,
            threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
        },
        {
            category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT,
            threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
        },
    ];
}

/**
 * Validate that AI response is not empty or blocked.
 * 
 * @param response - The AI response to validate
 * @returns true if valid, false otherwise
 */
export function isValidResponse(response: any): boolean {
    if (!response) {
        return false;
    }

    // Check if response was blocked by safety filters
    if (response.blocked) {
        console.warn('Response was blocked by safety filters');
        return false;
    }

    // Check if response has content
    if (!response.text && !response.output) {
        console.warn('Response has no content');
        return false;
    }

    return true;
}

/**
 * Extract error message from AI response or error object.
 * 
 * @param error - Error object or AI response
 * @returns User-friendly error message
 */
export function getErrorMessage(error: any): string {
    if (error?.message) {
        return error.message;
    }

    if (error?.error?.message) {
        return error.error.message;
    }

    if (typeof error === 'string') {
        return error;
    }

    return 'An unexpected error occurred';
}
