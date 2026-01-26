/**
 * constants.ts
 * 
 * Application-wide constants for the Clarity AI engine.
 */

export const CONSTANTS = {
    // Model configuration
    MODEL_NAME: 'gemini-1.5-flash',

    // Temperature settings for different AI tasks
    TEMPERATURE: {
        TASKER: 0.7,      // Balanced for task breakdown
        PARAGRAPH: 0.5,   // More focused for text rewriting
        CHATBOT: 0.8,     // More creative for conversation
    },

    // Token limits
    MAX_OUTPUT_TOKENS: {
        TASKER: 2048,
        PARAGRAPH: 4096,
        CHATBOT: 2048,
    },

    // Safety settings
    SAFETY_THRESHOLD: 'BLOCK_MEDIUM_AND_ABOVE',

    // Prompt directories
    PROMPT_DIRS: {
        TASKER: '../prompts/tasker',
        PARAGRAPH: '../prompts/paragraph',
        CHATBOT: '../prompts/chatbot',
    },
} as const;
