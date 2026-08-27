// LEDColor.swift
// PixelMarquee

import SwiftUI

/// Represents the color of an LED in the matrix display.
///
/// `LEDColor` supports both preset classic LED colors and custom RGB values.
///
/// ## Usage
///
/// ```swift
/// // Using presets
/// .ledColor(.red)
/// .ledColor(.amber)
///
/// // Custom RGB
/// .ledColor(LEDColor(r: 255, g: 100, b: 0))
/// ```
public struct LEDColor: Equatable, Hashable, Sendable {
    /// Red component (0-255)
    public let r: UInt8
    /// Green component (0-255)
    public let g: UInt8
    /// Blue component (0-255)
    public let b: UInt8
    
    /// Creates a custom LED color with RGB values.
    /// - Parameters:
    ///   - r: Red component (0-255)
    ///   - g: Green component (0-255)
    ///   - b: Blue component (0-255)
    public init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }
    
    // MARK: - Preset Colors
    
    /// Classic red LED color
    public static let red = LEDColor(r: 255, g: 0, b: 0)
    
    /// Classic green LED color
    public static let green = LEDColor(r: 0, g: 255, b: 0)
    
    /// Classic amber/yellow LED color
    public static let amber = LEDColor(r: 255, g: 191, b: 0)
    
    /// Blue LED color
    public static let blue = LEDColor(r: 0, g: 100, b: 255)
    
    /// White LED color
    public static let white = LEDColor(r: 255, g: 255, b: 255)
    
    /// Cyan LED color
    public static let cyan = LEDColor(r: 0, g: 255, b: 255)
    
    /// Magenta LED color
    public static let magenta = LEDColor(r: 255, g: 0, b: 255)
    
    /// Orange LED color
    public static let orange = LEDColor(r: 255, g: 69, b: 0)
    
    // MARK: - SwiftUI Color Conversion
    
    /// Converts the LED color to a SwiftUI Color for the "lit" state.
    public var color: Color {
        Color(
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue: Double(b) / 255.0
        )
    }
    
    /// Returns a dimmed version of the color for the "unlit" LED state.
    /// - Parameter factor: The dimming factor (0.0 = black, 1.0 = full brightness)
    /// - Returns: A dimmed SwiftUI Color
    public func dimmed(factor: Double = 0.15) -> Color {
        Color(
            red: Double(r) / 255.0 * factor,
            green: Double(g) / 255.0 * factor,
            blue: Double(b) / 255.0 * factor
        )
    }
}

// MARK: - ExpressibleByArrayLiteral

extension LEDColor: ExpressibleByArrayLiteral {
    /// Creates an LED color from an array literal of RGB values.
    ///
    /// ```swift
    /// let color: LEDColor = [255, 100, 0]
    /// ```
    public init(arrayLiteral elements: UInt8...) {
        precondition(elements.count == 3, "LEDColor requires exactly 3 RGB values")
        self.r = elements[0]
        self.g = elements[1]
        self.b = elements[2]
    }
}
