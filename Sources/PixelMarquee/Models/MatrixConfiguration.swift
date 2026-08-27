// MatrixConfiguration.swift
// PixelMarquee

import SwiftUI

/// Configuration for the LED matrix display appearance.
///
/// This struct defines the visual properties of the matrix including
/// size, LED styling, and colors.
public struct MatrixConfiguration: Equatable, Sendable {
    /// Number of rows in the matrix
    public var rows: Int
    
    /// Number of columns in the matrix
    public var columns: Int
    
    /// LED diameter relative to cell size (0.0 to 1.0)
    /// A value of 1.0 means LEDs touch, 0.7 is a good default for visible gaps.
    public var ledDiameter: CGFloat
    
    /// Spacing between LED cells in points
    public var ledSpacing: CGFloat
    
    /// Color pattern for the LEDs (solid color or stripes)
    public var colorPattern: ColorPattern
    
    /// Brightness factor for unlit LEDs (0.0 = invisible, 0.2 = subtly visible)
    public var unlitBrightness: CGFloat
    
    /// Background color behind the LED matrix
    public var backgroundColor: Color
    
    /// Color of lit LEDs (convenience accessor for solid color patterns)
    public var ledColor: LEDColor {
        get {
            switch colorPattern {
            case .solid(let color):
                return color
            case .stripes(let colors):
                return colors.first ?? .red
            }
        }
        set {
            colorPattern = .solid(newValue)
        }
    }
    
    /// Creates a matrix configuration.
    /// - Parameters:
    ///   - rows: Number of rows (default: 8)
    ///   - columns: Number of columns (default: 32)
    ///   - ledDiameter: LED diameter relative to cell (default: 0.7)
    ///   - ledSpacing: Spacing between cells in points (default: 1)
    ///   - ledColor: Color of lit LEDs (default: .red)
    ///   - unlitBrightness: Brightness of unlit LEDs (default: 0.15)
    ///   - backgroundColor: Background color (default: .black)
    public init(
        rows: Int = 8,
        columns: Int = 32,
        ledDiameter: CGFloat = 0.7,
        ledSpacing: CGFloat = 1,
        ledColor: LEDColor = .red,
        unlitBrightness: CGFloat = 0.15,
        backgroundColor: Color = .black
    ) {
        self.rows = max(1, rows)
        self.columns = max(1, columns)
        self.ledDiameter = min(max(ledDiameter, 0.1), 1.0)
        self.ledSpacing = max(0, ledSpacing)
        self.colorPattern = .solid(ledColor)
        self.unlitBrightness = min(max(unlitBrightness, 0), 1.0)
        self.backgroundColor = backgroundColor
    }
    
    /// Creates a matrix configuration with a color pattern.
    /// - Parameters:
    ///   - rows: Number of rows (default: 8)
    ///   - columns: Number of columns (default: 32)
    ///   - ledDiameter: LED diameter relative to cell (default: 0.7)
    ///   - ledSpacing: Spacing between cells in points (default: 1)
    ///   - colorPattern: Color pattern for LEDs
    ///   - unlitBrightness: Brightness of unlit LEDs (default: 0.15)
    ///   - backgroundColor: Background color (default: .black)
    public init(
        rows: Int = 8,
        columns: Int = 32,
        ledDiameter: CGFloat = 0.7,
        ledSpacing: CGFloat = 1,
        colorPattern: ColorPattern,
        unlitBrightness: CGFloat = 0.15,
        backgroundColor: Color = .black
    ) {
        self.rows = max(1, rows)
        self.columns = max(1, columns)
        self.ledDiameter = min(max(ledDiameter, 0.1), 1.0)
        self.ledSpacing = max(0, ledSpacing)
        self.colorPattern = colorPattern
        self.unlitBrightness = min(max(unlitBrightness, 0), 1.0)
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Presets
    
    /// Standard 8×32 matrix (common for single-line text displays)
    public static let standard = MatrixConfiguration()
    
    /// Small 8×16 matrix
    public static let small = MatrixConfiguration(rows: 8, columns: 16)
    
    /// Large 16×64 matrix (good for longer messages or two lines)
    public static let large = MatrixConfiguration(rows: 16, columns: 64)
    
    /// Wide 8×64 matrix (good for longer scrolling text)
    public static let wide = MatrixConfiguration(rows: 8, columns: 64)
    
    // MARK: - Computed Properties
    
    /// The color used for unlit LEDs (for solid color patterns)
    public var unlitColor: Color {
        ledColor.dimmed(factor: unlitBrightness)
    }
    
    /// The color used for lit LEDs (for solid color patterns)
    public var litColor: Color {
        ledColor.color
    }
    
    /// Total width of the matrix in cells
    public var totalWidth: Int { columns }
    
    /// Total height of the matrix in cells
    public var totalHeight: Int { rows }
}

// MARK: - Builder Pattern Support

extension MatrixConfiguration {
    /// Returns a new configuration with the specified number of rows and columns.
    public func withSize(rows: Int, columns: Int) -> MatrixConfiguration {
        var config = self
        config.rows = max(1, rows)
        config.columns = max(1, columns)
        return config
    }
    
    /// Returns a new configuration with the specified LED color.
    public func withLEDColor(_ color: LEDColor) -> MatrixConfiguration {
        var config = self
        config.colorPattern = .solid(color)
        return config
    }
    
    /// Returns a new configuration with the specified color pattern.
    public func withColorPattern(_ pattern: ColorPattern) -> MatrixConfiguration {
        var config = self
        config.colorPattern = pattern
        return config
    }
    
    /// Returns a new configuration with the specified LED styling.
    public func withLEDStyle(diameter: CGFloat, spacing: CGFloat) -> MatrixConfiguration {
        var config = self
        config.ledDiameter = min(max(diameter, 0.1), 1.0)
        config.ledSpacing = max(0, spacing)
        return config
    }
    
    /// Returns a new configuration with the specified background color.
    public func withBackgroundColor(_ color: Color) -> MatrixConfiguration {
        var config = self
        config.backgroundColor = color
        return config
    }
    
    /// Returns a new configuration with the specified unlit LED brightness.
    public func withUnlitBrightness(_ brightness: CGFloat) -> MatrixConfiguration {
        var config = self
        config.unlitBrightness = min(max(brightness, 0), 1.0)
        return config
    }
}
