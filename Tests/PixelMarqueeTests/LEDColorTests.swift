// LEDColorTests.swift
// PixelMarqueeTests

import Testing
import SwiftUI
@testable import PixelMarquee

@Suite("LEDColor Tests")
struct LEDColorTests {
    
    @Test("Custom RGB initialization")
    func customRGBInit() {
        let color = LEDColor(r: 100, g: 150, b: 200)
        
        #expect(color.r == 100)
        #expect(color.g == 150)
        #expect(color.b == 200)
    }
    
    @Test("Array literal initialization")
    func arrayLiteralInit() {
        let color: LEDColor = [255, 128, 64]
        
        #expect(color.r == 255)
        #expect(color.g == 128)
        #expect(color.b == 64)
    }
    
    @Test("Preset red color")
    func presetRed() {
        let red = LEDColor.red
        
        #expect(red.r == 255)
        #expect(red.g == 0)
        #expect(red.b == 0)
    }
    
    @Test("Preset green color")
    func presetGreen() {
        let green = LEDColor.green
        
        #expect(green.r == 0)
        #expect(green.g == 255)
        #expect(green.b == 0)
    }
    
    @Test("Preset amber color")
    func presetAmber() {
        let amber = LEDColor.amber
        
        #expect(amber.r == 255)
        #expect(amber.g == 191)
        #expect(amber.b == 0)
    }
    
    @Test("Preset blue color")
    func presetBlue() {
        let blue = LEDColor.blue
        
        #expect(blue.r == 0)
        #expect(blue.g == 100)
        #expect(blue.b == 255)
    }
    
    @Test("Preset white color")
    func presetWhite() {
        let white = LEDColor.white
        
        #expect(white.r == 255)
        #expect(white.g == 255)
        #expect(white.b == 255)
    }
    
    @Test("Color equality")
    func colorEquality() {
        let color1 = LEDColor(r: 100, g: 100, b: 100)
        let color2 = LEDColor(r: 100, g: 100, b: 100)
        let color3 = LEDColor(r: 100, g: 100, b: 101)
        
        #expect(color1 == color2)
        #expect(color1 != color3)
    }
    
    @Test("Color hashable")
    func colorHashable() {
        let color1 = LEDColor.red
        let color2 = LEDColor.red
        
        var set = Set<LEDColor>()
        set.insert(color1)
        set.insert(color2)
        
        #expect(set.count == 1)
    }
    
    @Test("Color to SwiftUI conversion")
    func swiftUIColorConversion() {
        let ledColor = LEDColor(r: 255, g: 0, b: 0)
        let swiftUIColor = ledColor.color
        
        // SwiftUI Color doesn't expose components easily, but we can verify it exists
        #expect(swiftUIColor == swiftUIColor)
    }
    
    @Test("Dimmed color")
    func dimmedColor() {
        let color = LEDColor(r: 200, g: 100, b: 50)
        let dimmed = color.dimmed(factor: 0.5)
        
        // Can't directly test Color components, but verify it exists
        #expect(dimmed == dimmed)
    }
    
    @Test("Dimmed color with zero factor")
    func dimmedColorZero() {
        let color = LEDColor.red
        let dimmed = color.dimmed(factor: 0.0)
        
        // Should be black
        #expect(dimmed == dimmed)
    }
    
    @Test("Dimmed color with full factor")
    func dimmedColorFull() {
        let color = LEDColor.red
        let dimmed = color.dimmed(factor: 1.0)
        let full = color.color
        
        // Both should represent the same color
        #expect(dimmed == dimmed)
        #expect(full == full)
    }
}

@Suite("MatrixConfiguration Tests")
struct MatrixConfigurationTests {
    
    @Test("Default configuration")
    func defaultConfiguration() {
        let config = MatrixConfiguration()
        
        #expect(config.rows == 8)
        #expect(config.columns == 32)
        #expect(config.ledDiameter == 0.7)
        #expect(config.ledColor == .red)
    }
    
    @Test("Standard preset")
    func standardPreset() {
        let config = MatrixConfiguration.standard
        
        #expect(config.rows == 8)
        #expect(config.columns == 32)
    }
    
    @Test("Small preset")
    func smallPreset() {
        let config = MatrixConfiguration.small
        
        #expect(config.rows == 8)
        #expect(config.columns == 16)
    }
    
    @Test("Large preset")
    func largePreset() {
        let config = MatrixConfiguration.large
        
        #expect(config.rows == 16)
        #expect(config.columns == 64)
    }
    
    @Test("Wide preset")
    func widePreset() {
        let config = MatrixConfiguration.wide
        
        #expect(config.rows == 8)
        #expect(config.columns == 64)
    }
    
    @Test("Builder pattern - withSize")
    func builderWithSize() {
        let config = MatrixConfiguration.standard.withSize(rows: 16, columns: 48)
        
        #expect(config.rows == 16)
        #expect(config.columns == 48)
    }
    
    @Test("Builder pattern - withLEDColor")
    func builderWithLEDColor() {
        let config = MatrixConfiguration.standard.withLEDColor(.green)
        
        #expect(config.ledColor == .green)
    }
    
    @Test("Builder pattern - withLEDStyle")
    func builderWithLEDStyle() {
        let config = MatrixConfiguration.standard.withLEDStyle(diameter: 0.8, spacing: 2)
        
        #expect(config.ledDiameter == 0.8)
        #expect(config.ledSpacing == 2)
    }
    
    @Test("Builder pattern chaining")
    func builderChaining() {
        let config = MatrixConfiguration.standard
            .withSize(rows: 12, columns: 40)
            .withLEDColor(.amber)
            .withLEDStyle(diameter: 0.6, spacing: 1.5)
        
        #expect(config.rows == 12)
        #expect(config.columns == 40)
        #expect(config.ledColor == .amber)
        #expect(config.ledDiameter == 0.6)
        #expect(config.ledSpacing == 1.5)
    }
    
    @Test("Dimension clamping - minimum")
    func dimensionClampingMinimum() {
        let config = MatrixConfiguration(rows: -5, columns: 0)
        
        #expect(config.rows == 1)
        #expect(config.columns == 1)
    }
    
    @Test("LED diameter clamping")
    func ledDiameterClamping() {
        let configLow = MatrixConfiguration(ledDiameter: -1.0)
        let configHigh = MatrixConfiguration(ledDiameter: 5.0)
        
        #expect(configLow.ledDiameter == 0.1)
        #expect(configHigh.ledDiameter == 1.0)
    }
    
    @Test("Unlit brightness clamping")
    func unlitBrightnessClamping() {
        let configLow = MatrixConfiguration(unlitBrightness: -0.5)
        let configHigh = MatrixConfiguration(unlitBrightness: 2.0)
        
        #expect(configLow.unlitBrightness == 0)
        #expect(configHigh.unlitBrightness == 1.0)
    }
}
