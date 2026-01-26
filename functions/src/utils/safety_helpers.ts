/**
 * safety_helpers.ts
 * 
 * Utilities for handling AI safety settings and response validation.
 */

/**
 * Get safety settings for Gemini API.
 * Blocks medium and above harmful content.
 */
export function getSafetySettings() {
    return [
        {
            category: 'HARM_CATEGORY_HATE_SPEECH' as const,
            threshold: 'BLOCK_MEDIUM_AND_ABOVE' as const,
        },
        {
            category: 'HARM_CATEGORY_DANGEROUS_CONTENT' as const,
            threshold: 'BLOCK_MEDIUM_AND_ABOVE' as const,
        },
        {
            category: 'HARM_CATEGORY_HARASSMENT' as const,
            threshold: 'BLOCK_MEDIUM_AND_ABOVE' as const,
        },
        {
            category: 'HARM_CATEGORY_SEXUALLY_EXPLICIT' as const,
            threshold: 'BLOCK_MEDIUM_AND_ABOVE' as const,
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
