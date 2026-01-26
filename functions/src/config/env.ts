/**
 * env.ts
 * 
 * Environment configuration for Firebase Functions.
 * Loads API keys and other environment variables.
 */

// Load dotenv for local development
import * as dotenv from 'dotenv';
dotenv.config();

export const config = {
    // Google AI API key for Gemini
    googleApiKey: process.env.GOOGLE_API_KEY || '',

    // Environment
    isDevelopment: process.env.NODE_ENV !== 'production',

    // CORS settings
    allowedOrigins: process.env.ALLOWED_ORIGINS?.split(',') || ['*'],
};

// Validate required environment variables
export function validateConfig(): void {
    if (!config.googleApiKey) {
        throw new Error('GOOGLE_API_KEY environment variable is required');
    }
}
