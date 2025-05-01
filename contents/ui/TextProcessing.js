/**
 * Utility functions for text processing in Command Plasma Widget
 */

// Ensure command output doesn't contain empty trailing whitespace/newlines
function cleanOutput(text) {
    if (!text) {
        return "";
    }
    
    // Trim trailing/leading whitespace
    return text.trim();
}

// Get estimated dimensions of text
function getTextDimensions(text, fontFamily, fontSize) {
    if (!text) {
        return { width: 0, height: 0 };
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
    maxLineLength = Math.max(10, maxLineLength);
    
    // Rough estimate of character width in pixels (this could be improved)
    const charWidth = fontSize * 0.6;
    
    return {
        width: maxLineLength * charWidth,
        height: lineCount * fontSize * 1.2
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