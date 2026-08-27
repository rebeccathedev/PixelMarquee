// PixelBuffer.swift
// PixelMarquee

import Foundation

/// Represents the state of a single LED in the matrix.
public enum LEDState: Equatable, Sendable {
    /// LED is off (will be rendered with unlit color)
    case off
    /// LED is on (will be rendered with lit color)
    case on
}

/// A 2D buffer of LED states representing the content to be displayed.
///
/// The buffer is row-major, meaning `pixels[row][column]`.
public struct PixelBuffer: Equatable, Sendable {
    /// The pixel data, stored as rows of LED states
    public private(set) var pixels: [[LEDState]]
    
    /// Number of rows in the buffer
    public var rows: Int { pixels.count }
    
    /// Number of columns in the buffer (0 if empty)
    public var columns: Int { pixels.first?.count ?? 0 }
    
    /// Whether the buffer is empty
    public var isEmpty: Bool { rows == 0 || columns == 0 }
    
    // MARK: - Initialization
    
    /// Creates an empty buffer with specified dimensions.
    /// - Parameters:
    ///   - rows: Number of rows
    ///   - columns: Number of columns
    ///   - fill: Initial state for all LEDs (default: .off)
    public init(rows: Int, columns: Int, fill: LEDState = .off) {
        self.pixels = Array(
            repeating: Array(repeating: fill, count: max(0, columns)),
            count: max(0, rows)
        )
    }
    
    /// Creates a buffer from existing pixel data.
    /// - Parameter pixels: 2D array of LED states (row-major)
    public init(pixels: [[LEDState]]) {
        // Ensure all rows have the same length
        let maxColumns = pixels.map { $0.count }.max() ?? 0
        self.pixels = pixels.map { row in
            if row.count < maxColumns {
                return row + Array(repeating: LEDState.off, count: maxColumns - row.count)
            }
            return row
        }
    }
    
    /// Creates a buffer from a boolean grid (true = on, false = off)
    /// - Parameter boolGrid: 2D array of booleans
    public init(boolGrid: [[Bool]]) {
        self.init(pixels: boolGrid.map { row in
            row.map { $0 ? LEDState.on : LEDState.off }
        })
    }
    
    // MARK: - Accessors
    
    /// Gets or sets the LED state at a specific position.
    /// - Parameters:
    ///   - row: Row index
    ///   - column: Column index
    /// - Returns: The LED state, or `.off` if out of bounds
    public subscript(row: Int, column: Int) -> LEDState {
        get {
            guard row >= 0, row < rows, column >= 0, column < columns else {
                return .off
            }
            return pixels[row][column]
        }
        set {
            guard row >= 0, row < rows, column >= 0, column < columns else {
                return
            }
            pixels[row][column] = newValue
        }
    }
    
    /// Returns a row of LED states.
    /// - Parameter index: Row index
    /// - Returns: Array of LED states for that row
    public func row(_ index: Int) -> [LEDState] {
        guard index >= 0, index < rows else { return [] }
        return pixels[index]
    }
    
    // MARK: - Manipulation
    
    /// Sets all pixels to the specified state.
    /// - Parameter state: The state to fill with
    public mutating func fill(_ state: LEDState) {
        for row in 0..<rows {
            for col in 0..<columns {
                pixels[row][col] = state
            }
        }
    }
    
    /// Clears the buffer (all LEDs off).
    public mutating func clear() {
        fill(.off)
    }
    
    /// Copies a source buffer into this buffer at the specified offset.
    /// - Parameters:
    ///   - source: The buffer to copy from
    ///   - offsetX: Horizontal offset (can be negative)
    ///   - offsetY: Vertical offset (can be negative)
    public mutating func blit(_ source: PixelBuffer, offsetX: Int = 0, offsetY: Int = 0) {
        for srcRow in 0..<source.rows {
            let dstRow = srcRow + offsetY
            guard dstRow >= 0, dstRow < rows else { continue }
            
            for srcCol in 0..<source.columns {
                let dstCol = srcCol + offsetX
                guard dstCol >= 0, dstCol < columns else { continue }
                
                if source[srcRow, srcCol] == .on {
                    pixels[dstRow][dstCol] = .on
                }
            }
        }
    }
    
    /// Returns a new buffer with horizontal scrolling applied.
    /// - Parameter offset: Number of columns to scroll (positive = right, negative = left)
    /// - Returns: A new scrolled buffer
    public func scrolledHorizontally(by offset: Int) -> PixelBuffer {
        guard !isEmpty else { return self }
        
        var result = PixelBuffer(rows: rows, columns: columns)
        
        for row in 0..<rows {
            for col in 0..<columns {
                var srcCol = col - offset
                // Wrap around
                while srcCol < 0 { srcCol += columns }
                while srcCol >= columns { srcCol -= columns }
                
                result[row, col] = self[row, srcCol]
            }
        }
        
        return result
    }
    
    /// Returns a new buffer with vertical scrolling applied.
    /// - Parameter offset: Number of rows to scroll (positive = down, negative = up)
    /// - Returns: A new scrolled buffer
    public func scrolledVertically(by offset: Int) -> PixelBuffer {
        guard !isEmpty else { return self }
        
        var result = PixelBuffer(rows: rows, columns: columns)
        
        for row in 0..<rows {
            var srcRow = row - offset
            // Wrap around
            while srcRow < 0 { srcRow += rows }
            while srcRow >= rows { srcRow -= rows }
            
            for col in 0..<columns {
                result[row, col] = self[srcRow, col]
            }
        }
        
        return result
    }
    
    // MARK: - Combination
    
    /// Horizontally concatenates two buffers.
    /// - Parameters:
    ///   - lhs: Left buffer
    ///   - rhs: Right buffer
    /// - Returns: Combined buffer
    public static func + (lhs: PixelBuffer, rhs: PixelBuffer) -> PixelBuffer {
        let resultRows = max(lhs.rows, rhs.rows)
        let resultCols = lhs.columns + rhs.columns
        
        var result = PixelBuffer(rows: resultRows, columns: resultCols)
        
        // Copy left buffer
        result.blit(lhs, offsetX: 0, offsetY: 0)
        
        // Copy right buffer
        result.blit(rhs, offsetX: lhs.columns, offsetY: 0)
        
        return result
    }
}

// MARK: - Debug Description

extension PixelBuffer: CustomStringConvertible {
    public var description: String {
        pixels.map { row in
            row.map { $0 == .on ? "█" : "░" }.joined()
        }.joined(separator: "\n")
    }
}
