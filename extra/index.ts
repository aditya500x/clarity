import { genkit, z } from 'genkit';
import { googleAI, gemini15Flash } from '@genkit-ai/googleai';
import { loadPrompts } from './utils';
import * as path from 'path';

const ai = genkit({
    plugins: [googleAI()],
    model: gemini15Flash, // Default model
});

const MODULES_DIR = path.join(__dirname, 'modules');

/**
 * FUNCTION 1: tasker_ai
 * Convert messy user input into a task + steps.
 */
export const tasker_ai = ai.defineFlow(
    {
        name: 'tasker_ai',
        inputSchema: z.string(),
        outputSchema: z.object({
            task_title: z.string(),
            steps: z.array(z.string()),
        }),
    },
    async (input) => {
        const promptPath = path.join(MODULES_DIR, 'tasker');
        const systemPrompt = loadPrompts(promptPath);

        try {
            const response = await ai.generate({
                prompt: input,
                config: {
                    systemPrompt: systemPrompt,
                    temperature: 0.2,
                },
                output: {
                    schema: z.object({
                        task_title: z.string(),
                        steps: z.array(z.string()),
                    }),
                },
            });

            if (!response.output) {
                throw new Error('No output returned');
            }
            return response.output;
        } catch (error) {
            console.error('tasker_ai failed:', error);
            return {
                task_title: input || 'New Task',
                steps: ['Process your request'],
            };
        }
    }
);

/**
 * FUNCTION 2: paragraph_ai
 * Rewrite text to be sensory-safe and easy to read.
 */
export const paragraph_ai = ai.defineFlow(
    {
        name: 'paragraph_ai',
        inputSchema: z.string(),
        outputSchema: z.object({
            adapted_text: z.string(),
        }),
    },
    async (input) => {
        const promptPath = path.join(MODULES_DIR, 'paragraph');
        const systemPrompt = loadPrompts(promptPath);

        try {
            const response = await ai.generate({
                prompt: input,
                config: {
                    systemPrompt: systemPrompt,
                    temperature: 0.2,
                },
                output: {
                    schema: z.object({
                        adapted_text: z.string(),
                    }),
                },
            });

            if (!response.output) {
                throw new Error('No output returned');
            }
            return response.output;
        } catch (error) {
            console.error('paragraph_ai failed:', error);
            return {
                adapted_text: input || 'I am here to help you understand this clearly.',
            };
        }
    }
);

/**
 * FUNCTION 3: chatbot_ai
 * General conversational AI for support/chat.
 */
export const chatbot_ai = ai.defineFlow(
    {
        name: 'chatbot_ai',
        inputSchema: z.array(
            z.object({
                sender: z.enum(['user', 'ai']),
                text: z.string(),
            })
        ),
        outputSchema: z.object({
            reply: z.string(),
        }),
    },
    async (messages) => {
        const promptPath = path.join(MODULES_DIR, 'chatbot');
        const systemPrompt = loadPrompts(promptPath);

        const history = messages.map((m) => ({
            role: (m.sender === 'user' ? 'user' : 'model') as 'user' | 'model',
            content: [{ text: m.text }],
        }));

        // Extract the last user message as the actual prompt
        const lastUserMessage = messages.slice().reverse().find(m => m.sender === 'user');
        const prompt = lastUserMessage ? lastUserMessage.text : 'Hello';

        try {
            const response = await ai.generate({
                messages: history,
                config: {
                    systemPrompt: systemPrompt,
                    temperature: 0.7,
                },
                output: {
                    schema: z.object({
                        reply: z.string(),
                    }),
                },
            });

            if (!response.output) {
                throw new Error('No output returned');
            }
            return response.output;
        } catch (error) {
            console.error('chatbot_ai failed:', error);
            return {
                reply: 'I’m here with you. Can you tell me a bit more about what’s going on?',
            };
        }
    }
);
