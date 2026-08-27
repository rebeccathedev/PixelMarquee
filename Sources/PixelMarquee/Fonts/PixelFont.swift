// PixelFont.swift
// PixelMarquee

import Foundation

/// A pixel font for rendering text on LED matrix displays.
///
/// A `PixelFont` contains a mapping of characters to their pixel representations
/// (glyphs) and provides methods for rasterizing text into pixel buffers.
///
/// ## Usage
///
/// ```swift
/// // Use the built-in font
/// let buffer = PixelFont.default.rasterize("Hello!")
///
/// // Create a custom font
/// let customFont = PixelFont(glyphs: myGlyphs, height: 7)
/// ```
public struct PixelFont: Sendable {
    /// The character-to-glyph mapping
    public let glyphs: [Character: PixelGlyph]
    
    /// The standard height of glyphs in this font
    public let height: Int
    
    /// Space between characters in pixels
    public let characterSpacing: Int
    
    /// Width of space character (if not defined as a glyph)
    public let spaceWidth: Int
    
    /// The default built-in 5×7 pixel font with full ASCII support
    public static let `default` = DefaultPixelFont.font
    
    /// Creates a custom pixel font.
    /// - Parameters:
    ///   - glyphs: Dictionary mapping characters to their glyphs
    ///   - height: Standard height of the font
    ///   - characterSpacing: Pixels between characters (default: 1)
    ///   - spaceWidth: Width of space character (default: 3)
    public init(
        glyphs: [Character: PixelGlyph],
        height: Int,
        characterSpacing: Int = 1,
        spaceWidth: Int = 3
    ) {
        self.glyphs = glyphs
        self.height = height
        self.characterSpacing = characterSpacing
        self.spaceWidth = spaceWidth
    }
    
    /// Returns the glyph for a character, or nil if not found.
    /// - Parameter character: The character to look up
    /// - Returns: The glyph, or nil
    public func glyph(for character: Character) -> PixelGlyph? {
        glyphs[character]
    }
    
    /// Calculates the total width needed to render a string.
    /// - Parameter text: The text to measure
    /// - Returns: Width in pixels
    public func measureWidth(_ text: String) -> Int {
        var width = 0
        var isFirst = true
        
        for char in text {
            if !isFirst {
                width += characterSpacing
            }
            isFirst = false
            
            if char == " " {
                width += spaceWidth
            } else if let glyph = glyphs[char] {
                width += glyph.width
            } else {
                // Unknown character - use space width
                width += spaceWidth
            }
        }
        
        return width
    }
    
    /// Rasterizes text into a pixel buffer.
    /// - Parameters:
    ///   - text: The text to rasterize
    ///   - padHeight: If provided, ensures the buffer has at least this height
    /// - Returns: A PixelBuffer containing the rendered text
    public func rasterize(_ text: String, padHeight: Int? = nil) -> PixelBuffer {
        let totalWidth = measureWidth(text)
        let bufferHeight = padHeight ?? height
        
        guard totalWidth > 0 else {
            return PixelBuffer(rows: bufferHeight, columns: 0)
        }
        
        var buffer = PixelBuffer(rows: bufferHeight, columns: totalWidth)
        var xOffset = 0
        
        for char in text {
            if char == " " {
                xOffset += spaceWidth + characterSpacing
                continue
            }
            
            guard let glyph = glyphs[char] else {
                xOffset += spaceWidth + characterSpacing
                continue
            }
            
            // Center glyph vertically if buffer is taller than glyph
            let yOffset = max(0, (bufferHeight - glyph.height) / 2)
            
            // Copy glyph pixels to buffer
            for row in 0..<glyph.height {
                for col in 0..<glyph.width {
                    if glyph[row, col] {
                        buffer[row + yOffset, col + xOffset] = .on
                    }
                }
            }
            
            xOffset += glyph.width + characterSpacing
        }
        
        return buffer
    }
    
    /// Rasterizes text to fit within a specified width, optionally with horizontal padding.
    /// - Parameters:
    ///   - text: The text to rasterize
    ///   - width: Target width in pixels
    ///   - height: Target height in pixels
    ///   - alignment: Horizontal alignment within the width
    /// - Returns: A PixelBuffer of the specified dimensions
    public func rasterize(
        _ text: String,
        width: Int,
        height: Int,
        alignment: HorizontalAlignment = .leading
    ) -> PixelBuffer {
        let textBuffer = rasterize(text, padHeight: height)
        
        // If text fits within width, apply alignment
        if textBuffer.columns <= width {
            var result = PixelBuffer(rows: height, columns: width)
            
            let xOffset: Int
            switch alignment {
            case .leading:
                xOffset = 0
            case .center:
                xOffset = (width - textBuffer.columns) / 2
            case .trailing:
                xOffset = width - textBuffer.columns
            }
            
            result.blit(textBuffer, offsetX: xOffset)
            return result
        }
        
        // Text is wider than target - just use the text buffer
        return textBuffer
    }
    
    /// Horizontal alignment for text rendering.
    public enum HorizontalAlignment: Sendable {
        case leading
        case center
        case trailing
    }
}
