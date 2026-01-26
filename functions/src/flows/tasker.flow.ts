/**
 * tasker.flow.ts
 * 
 * Genkit flow for the Task Deconstructor AI.
 * Breaks down large tasks into small, actionable steps.
 * 
 * This flow:
 * 1. Loads prompts from the tasker directory
 * 2. Calls Gemini via Genkit
 * 3. Returns structured JSON
 * 
 * NO HTTP logic here - pure AI orchestration.
 */

import { defineFlow, generate, gemini15Flash } from '../genkit/genkit';
import { getModelConfig } from '../genkit/models';
import { loadPrompts } from '../utils/prompt_helpers';
import { getSafetySettings, getErrorMessage } from '../utils/safety_helpers';
import { CONSTANTS } from '../config/constants';
import { TaskerInputSchema, TaskerOutputSchema, type TaskerInput, type TaskerOutput } from '../schemas/tasker.schema';

/**
 * Load tasker prompts once at module initialization.
 * This happens when the function cold-starts.
 */
const TASKER_PROMPTS = loadPrompts(CONSTANTS.PROMPT_DIRS.TASKER);

/**
 * Tasker AI Flow
 * 
 * Takes user input and returns a structured task breakdown.
 */
export const taskerFlow = defineFlow(
    {
        name: 'taskerFlow',
        inputSchema: TaskerInputSchema,
        outputSchema: TaskerOutputSchema,
    },
    async (input: TaskerInput): Promise<TaskerOutput> => {
        try {
            console.log(`[Tasker Flow] Processing task for session: ${input.sessionId}`);

            // Get model configuration
            const modelConfig = getModelConfig('TASKER');

            // Construct the full prompt
            const fullPrompt = `${TASKER_PROMPTS}

USER INPUT:
${input.userInput}

Please break down this task into clear, actionable steps. Return your response as JSON with the following structure:
{
  "taskTitle": "A clear, concise title for the task",
  "steps": [
    {
      "stepNumber": 1,
      "description": "First step description",
      "completed": false
    }
  ],
  "estimatedDuration": "optional estimate like '30 minutes' or '2 hours'",
  "difficulty": "easy|medium|hard"
}`;

            // Call Gemini via Genkit
            const response = await generate({
                model: gemini15Flash,
                prompt: fullPrompt,
                config: {
                    temperature: modelConfig.temperature,
                    maxOutputTokens: modelConfig.maxOutputTokens,
                    safetySettings: getSafetySettings(),
                },
            });

            // Get text from response (text() is a function in Genkit)
            const text = response.text();

            // Validate response
            if (!text) {
                throw new Error('AI returned empty response');
            }

            console.log('[Tasker Flow] Raw AI response received');

            // Parse JSON response
            let parsedResponse: any;
            try {
                // Extract JSON from markdown code blocks if present
                const jsonMatch = text.match(/```json\n?([\s\S]*?)\n?```/) || text.match(/```\n?([\s\S]*?)\n?```/);
                const jsonText = jsonMatch ? jsonMatch[1] : text;
                parsedResponse = JSON.parse(jsonText.trim());
            } catch (parseError) {
                console.error('[Tasker Flow] Failed to parse AI response as JSON:', parseError);
                throw new Error('AI response was not valid JSON');
            }

            // Validate against schema
            const validatedOutput = TaskerOutputSchema.parse(parsedResponse);

            console.log(`[Tasker Flow] Successfully generated task with ${validatedOutput.steps.length} steps`);

            return validatedOutput;

        } catch (error) {
            console.error('[Tasker Flow] Error:', error);
            throw new Error(`Tasker flow failed: ${getErrorMessage(error)}`);
        }
    }
);

console.log('✅ Tasker flow registered');
