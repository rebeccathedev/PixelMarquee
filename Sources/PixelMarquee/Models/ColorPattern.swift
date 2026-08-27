// ColorPattern.swift
// PixelMarquee

import SwiftUI

/// Defines how colors are applied across the LED matrix.
///
/// Use `ColorPattern` to create solid colors, horizontal stripes (one color per row),
/// or pride flag presets.
///
/// ## Usage
///
/// ```swift
/// // Solid color (default behavior)
/// .colorPattern(.solid(.red))
///
/// // Pride flags!
/// .colorPattern(.transgender)
/// .colorPattern(.rainbow)
///
/// // Custom stripes
/// .colorPattern(.stripes([.red, .white, .blue]))
/// ```
public enum ColorPattern: Equatable, Sendable {
    /// Single solid color for all LEDs
    case solid(LEDColor)
    
    /// Horizontal stripes - colors are distributed evenly across rows
    case stripes([LEDColor])
    
    // MARK: - Pride Flag Presets 🏳️‍🌈🏳️‍⚧️
    
    /// Transgender pride flag (light blue, pink, white, pink, light blue)
    public static let transgender = ColorPattern.stripes([
        LEDColor(r: 91, g: 206, b: 250),   // Light blue
        LEDColor(r: 245, g: 169, b: 184),  // Pink
        LEDColor(r: 255, g: 255, b: 255),  // White
        LEDColor(r: 245, g: 169, b: 184),  // Pink
        LEDColor(r: 91, g: 206, b: 250),   // Light blue
    ])
    
    /// Classic 6-stripe rainbow pride flag
    public static let rainbow = ColorPattern.stripes([
        LEDColor(r: 228, g: 3, b: 3),      // Red
        LEDColor(r: 255, g: 140, b: 0),    // Orange
        LEDColor(r: 255, g: 237, b: 0),    // Yellow
        LEDColor(r: 0, g: 128, b: 38),     // Green
        LEDColor(r: 36, g: 64, b: 142),    // Blue
        LEDColor(r: 115, g: 41, b: 130),   // Purple
    ])
    
    /// Bisexual pride flag (magenta, purple, blue)
    public static let bisexual = ColorPattern.stripes([
        LEDColor(r: 214, g: 2, b: 112),    // Magenta
        LEDColor(r: 214, g: 2, b: 112),    // Magenta
        LEDColor(r: 155, g: 79, b: 150),   // Purple
        LEDColor(r: 0, g: 56, b: 168),     // Blue
        LEDColor(r: 0, g: 56, b: 168),     // Blue
    ])
    
    /// Pansexual pride flag (magenta, yellow, cyan)
    public static let pansexual = ColorPattern.stripes([
        LEDColor(r: 255, g: 33, b: 140),   // Magenta
        LEDColor(r: 255, g: 216, b: 0),    // Yellow
        LEDColor(r: 33, g: 177, b: 255),   // Cyan
    ])
    
    /// Non-binary pride flag (yellow, white, purple, black)
    public static let nonbinary = ColorPattern.stripes([
        LEDColor(r: 255, g: 244, b: 48),   // Yellow
        LEDColor(r: 255, g: 255, b: 255),  // White
        LEDColor(r: 156, g: 89, b: 209),   // Purple
        LEDColor(r: 45, g: 45, b: 45),     // Black (dark gray for visibility)
    ])
    
    /// Lesbian pride flag (orange to pink gradient, 5 stripes)
    public static let lesbian = ColorPattern.stripes([
        LEDColor(r: 213, g: 45, b: 0),     // Dark orange
        LEDColor(r: 239, g: 118, b: 39),   // Orange
        LEDColor(r: 255, g: 255, b: 255),  // White
        LEDColor(r: 209, g: 98, b: 164),   // Pink
        LEDColor(r: 163, g: 2, b: 98),     // Dark pink
    ])
    
    /// Gay/MLM pride flag (green to blue gradient)
    public static let gay = ColorPattern.stripes([
        LEDColor(r: 7, g: 141, b: 112),    // Teal
        LEDColor(r: 38, g: 206, b: 170),   // Mint
        LEDColor(r: 152, g: 232, b: 193),  // Light green
        LEDColor(r: 255, g: 255, b: 255),  // White
        LEDColor(r: 123, g: 173, b: 226),  // Light blue
        LEDColor(r: 80, g: 73, b: 203),    // Blue
        LEDColor(r: 62, g: 26, b: 120),    // Purple
    ])
    
    /// Asexual pride flag (black, gray, white, purple)
    public static let asexual = ColorPattern.stripes([
        LEDColor(r: 45, g: 45, b: 45),     // Black (dark gray)
        LEDColor(r: 163, g: 163, b: 163),  // Gray
        LEDColor(r: 255, g: 255, b: 255),  // White
        LEDColor(r: 128, g: 0, b: 128),    // Purple
    ])
    
    /// Aromantic pride flag (green, light green, white, gray, black)
    public static let aromantic = ColorPattern.stripes([
        LEDColor(r: 61, g: 165, b: 66),    // Green
        LEDColor(r: 167, g: 211, b: 121),  // Light green
        LEDColor(r: 255, g: 255, b: 255),  // White
        LEDColor(r: 169, g: 169, b: 169),  // Gray
        LEDColor(r: 45, g: 45, b: 45),     // Black (dark gray)
    ])
    
    /// Genderqueer pride flag (lavender, white, green)
    public static let genderqueer = ColorPattern.stripes([
        LEDColor(r: 181, g: 126, b: 220),  // Lavender
        LEDColor(r: 255, g: 255, b: 255),  // White
        LEDColor(r: 74, g: 129, b: 35),    // Green
    ])
    
    /// Genderfluid pride flag (pink, white, purple, black, blue)
    public static let genderfluid = ColorPattern.stripes([
        LEDColor(r: 255, g: 118, b: 164),  // Pink
        LEDColor(r: 255, g: 255, b: 255),  // White
        LEDColor(r: 190, g: 24, b: 214),   // Purple
        LEDColor(r: 45, g: 45, b: 45),     // Black (dark gray)
        LEDColor(r: 51, g: 62, b: 189),    // Blue
    ])
    
    /// Intersex pride flag (yellow with purple circle - approximated as stripes)
    public static let intersex = ColorPattern.stripes([
        LEDColor(r: 255, g: 216, b: 0),    // Yellow
        LEDColor(r: 255, g: 216, b: 0),    // Yellow
        LEDColor(r: 121, g: 2, b: 170),    // Purple
        LEDColor(r: 121, g: 2, b: 170),    // Purple
        LEDColor(r: 255, g: 216, b: 0),    // Yellow
        LEDColor(r: 255, g: 216, b: 0),    // Yellow
    ])
    
    /// Progress pride flag (simplified as stripes)
    public static let progress = ColorPattern.stripes([
        LEDColor(r: 255, g: 255, b: 255),  // White (trans)
        LEDColor(r: 245, g: 169, b: 184),  // Pink (trans)
        LEDColor(r: 91, g: 206, b: 250),   // Light blue (trans)
        LEDColor(r: 97, g: 57, b: 21),     // Brown
        LEDColor(r: 45, g: 45, b: 45),     // Black
        LEDColor(r: 228, g: 3, b: 3),      // Red
        LEDColor(r: 255, g: 140, b: 0),    // Orange
        LEDColor(r: 255, g: 237, b: 0),    // Yellow
        LEDColor(r: 0, g: 128, b: 38),     // Green
        LEDColor(r: 36, g: 64, b: 142),    // Blue
        LEDColor(r: 115, g: 41, b: 130),   // Purple
    ])
    
    // MARK: - Color Resolution
    
    /// Returns the color for a specific row given the total number of rows.
    /// - Parameters:
    ///   - row: The row index (0-based)
    ///   - totalRows: Total number of rows in the matrix
    /// - Returns: The LED color for that row
    public func color(forRow row: Int, totalRows: Int) -> LEDColor {
        switch self {
        case .solid(let color):
            return color
            
        case .stripes(let colors):
            guard !colors.isEmpty, totalRows > 0 else {
                return .red // Fallback
            }
            
            // Map row to color index, distributing colors evenly
            let colorIndex = (row * colors.count) / totalRows
            return colors[min(colorIndex, colors.count - 1)]
        }
    }
    
    /// Returns the unlit (dim) color for a specific row.
    /// - Parameters:
    ///   - row: The row index (0-based)
    ///   - totalRows: Total number of rows in the matrix
    ///   - brightness: Dim brightness factor (0-1)
    /// - Returns: The dimmed LED color for that row
    public func unlitColor(forRow row: Int, totalRows: Int, brightness: CGFloat) -> Color {
        color(forRow: row, totalRows: totalRows).dimmed(factor: brightness)
    }
}
