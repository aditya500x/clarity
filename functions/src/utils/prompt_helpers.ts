/**
 * prompt_helpers.ts
 * 
 * Utilities for loading and managing prompt files.
 * Each AI module reads all .txt files from its respective prompt directory.
 */

import * as fs from 'fs';
import * as path from 'path';

/**
 * Load all .txt files from a directory and concatenate them.
 * Files are sorted alphabetically for deterministic ordering.
 * 
 * @param promptDir - Relative path to the prompt directory
 * @returns Concatenated prompt text
 */
export function loadPrompts(promptDir: string): string {
    try {
        // Resolve the absolute path
        const absolutePath = path.resolve(__dirname, promptDir);

        // Check if directory exists
        if (!fs.existsSync(absolutePath)) {
            console.warn(`Prompt directory not found: ${absolutePath}`);
            return '';
        }

        // Read all files in the directory
        const files = fs.readdirSync(absolutePath);

        // Filter for .txt files and sort alphabetically
        const txtFiles = files
            .filter(file => file.endsWith('.txt'))
            .sort();

        if (txtFiles.length === 0) {
            console.warn(`No .txt files found in: ${absolutePath}`);
            return '';
        }

        // Read and concatenate all prompt files
        const prompts = txtFiles.map(file => {
            const filePath = path.join(absolutePath, file);
            const content = fs.readFileSync(filePath, 'utf-8');
            return content.trim();
        });

        // Join with double newlines for clarity
        const concatenated = prompts.join('\n\n');

        console.log(`Loaded ${txtFiles.length} prompt file(s) from ${promptDir}`);
        return concatenated;

    } catch (error) {
        console.error(`Error loading prompts from ${promptDir}:`, error);
        throw new Error(`Failed to load prompts: ${error}`);
    }
}

/**
 * Validate that a prompt directory exists and contains .txt files.
 * 
 * @param promptDir - Relative path to the prompt directory
 * @returns true if valid, false otherwise
 */
export function validatePromptDirectory(promptDir: string): boolean {
    try {
        const absolutePath = path.resolve(__dirname, promptDir);

        if (!fs.existsSync(absolutePath)) {
            return false;
        }

        const files = fs.readdirSync(absolutePath);
        const txtFiles = files.filter(file => file.endsWith('.txt'));

        return txtFiles.length > 0;
    } catch (error) {
        console.error(`Error validating prompt directory ${promptDir}:`, error);
        return false;
    }
}
