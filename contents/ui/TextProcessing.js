/**
 * Utility functions for text processing in Command Plasma Widget
 */

const boldNumberMap = [
    "⓿", "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"
];

// Ensure command output doesn't contain empty trailing whitespace/newlines
function cleanOutput(text) {
    if (!text) {
        return "";
    }

    let sanitizedText = text.trim();
    // Remove control characters except for newlines (\n)
    sanitizedText = sanitizedText
        .replace(/[\u0000-\u0009\u000B-\u001F\u007F-\u009F]/g, '\\');

    console.log("Cleaning output: " + sanitizedText);

    return sanitizedText;
}

// Get estimated dimensions of text
function getTextDimensions(text, fontFamily, fontSize) {
    if (!text) {
        return { width: 100, height: 50 }; // Minimum size for empty text
    }
    
    const lines = text.split('\n');
    const lineCount = Math.max(1, lines.length);
    
    // Find the longest line
    let maxLineLength = 0;
    for (let i = 0; i < lines.length; i++) {
        if (lines[i].length > maxLineLength) {
            maxLineLength = lines[i].length;
        }
    }
    
    // Ensure a minimum size for the popup
    maxLineLength = Math.max(20, maxLineLength);
    
    // Rough estimate of character width in pixels
    // Monospace fonts are typically about 0.6x the font size in width
    const charWidth = fontSize * 0.6;
    
    // Add some extra space to ensure text fits
    const width = maxLineLength * charWidth * 1.05;
    const height = lineCount * fontSize * 1.3;
    
    return {
        width: width,
        height: height
    };
}

// Determine if the output is suitable for a compact display
function isCompactOutput(text) {
    if (!text) {
        return true;
    }
    
    const lines = text.split('\n');
    
    // If it's just a single line or 1-2 short lines, it's compact
    if (lines.length <= 2 && text.length < 50) {
        return true;
    }
    
    return false;
}

// Count visible lines (excluding empty lines at the end)
function countLines(text) {
    if (!text) {
        return 0;
    }
    
    // Split by newlines and filter out empty lines at the end
    const lines = text.split('\n');
    let count = 0;
    
    for (let i = 0; i < lines.length; i++) {
        if (lines[i].trim() !== '' || i < lines.length - 1) {
            count++;
        }
    }
    
    return count;
} 