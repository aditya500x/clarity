import * as fs from 'fs';
import * as path from 'path';

/**
 * Loads and concatenates all .txt files in a module directory in deterministic order.
 * @param moduleDir The path to the module directory.
 * @returns The concatenated prompt string.
 */
export function loadPrompts(moduleDir: string): string {
    const files = fs.readdirSync(moduleDir)
        .filter(file => file.endsWith('.txt'))
        .sort(); // Deterministic order

    return files.map(file => {
        const filePath = path.join(moduleDir, file);
        return fs.readFileSync(filePath, 'utf-8');
    }).join('\n\n');
}
