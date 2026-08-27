// PixelGlyph.swift
// PixelMarquee

import Foundation

/// Represents a single character's pixel representation for LED display.
///
/// A glyph contains a bitmap of pixels that define how a character looks
/// when rendered on an LED matrix.
public struct PixelGlyph: Equatable, Sendable {
    /// Width of the glyph in pixels
    public let width: Int
    
    /// Height of the glyph in pixels
    public let height: Int
    
    /// Bitmap data stored as rows of booleans (true = lit)
    /// Row-major order: bitmap[row][column]
    public let bitmap: [[Bool]]
    
    /// Creates a glyph from a 2D boolean array.
    /// - Parameter bitmap: Row-major 2D array where `true` = lit pixel
    public init(bitmap: [[Bool]]) {
        self.bitmap = bitmap
        self.height = bitmap.count
        self.width = bitmap.first?.count ?? 0
    }
    
    /// Creates a glyph from a string representation.
    ///
    /// Each line represents a row. Any non-space character is treated as a lit pixel.
    ///
    /// ```swift
    /// let A = PixelGlyph(pattern: """
    ///   █
    ///  █ █
    ///  ███
    ///  █ █
    ///  █ █
    /// """)
    /// ```
    ///
    /// - Parameter pattern: Multi-line string pattern
    public init(pattern: String) {
        let lines = pattern.split(separator: "\n", omittingEmptySubsequences: false)
        let bitmap = lines.map { line in
            line.map { $0 != " " }
        }
        self.init(bitmap: bitmap)
    }
    
    /// Creates a glyph from compact binary strings.
    ///
    /// Each string represents a row. '1' or '#' = lit, anything else = unlit.
    ///
    /// ```swift
    /// let A = PixelGlyph(rows: [
    ///     "01110",
    ///     "10001",
    ///     "11111",
    ///     "10001",
    ///     "10001"
    /// ])
    /// ```
    ///
    /// - Parameter rows: Array of binary strings
    public init(rows: [String]) {
        let bitmap = rows.map { row in
            row.map { $0 == "1" || $0 == "#" }
        }
        self.init(bitmap: bitmap)
    }
    
    /// Converts the glyph to a PixelBuffer.
    /// - Returns: A PixelBuffer containing this glyph's pixels
    public func toPixelBuffer() -> PixelBuffer {
        PixelBuffer(boolGrid: bitmap)
    }
    
    /// Gets the pixel state at a specific position.
    /// - Parameters:
    ///   - row: Row index
    ///   - column: Column index
    /// - Returns: `true` if the pixel is lit, `false` otherwise or if out of bounds
    public subscript(row: Int, column: Int) -> Bool {
        guard row >= 0, row < height, column >= 0, column < width else {
            return false
        }
        return bitmap[row][column]
    }
}

// MARK: - Debug Description

extension PixelGlyph: CustomStringConvertible {
    public var description: String {
        bitmap.map { row in
            row.map { $0 ? "█" : " " }.joined()
        }.joined(separator: "\n")
    }
}
