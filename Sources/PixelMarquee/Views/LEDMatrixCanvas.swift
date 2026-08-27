// LEDMatrixCanvas.swift
// PixelMarquee

import SwiftUI

/// A SwiftUI Canvas that renders an LED matrix display with authentic circular LEDs.
struct LEDMatrixCanvas: View {
    /// The pixel buffer to render
    let buffer: PixelBuffer
    
    /// Matrix configuration
    let configuration: MatrixConfiguration
    
    /// Horizontal offset for scrolling (in pixels)
    let scrollOffsetX: CGFloat
    
    /// Vertical offset for scrolling (in pixels)
    let scrollOffsetY: CGFloat
    
    /// Whether the display is visible (for blink effect)
    let isVisible: Bool
    
    init(
        buffer: PixelBuffer,
        configuration: MatrixConfiguration,
        scrollOffsetX: CGFloat = 0,
        scrollOffsetY: CGFloat = 0,
        isVisible: Bool = true
    ) {
        self.buffer = buffer
        self.configuration = configuration
        self.scrollOffsetX = scrollOffsetX
        self.scrollOffsetY = scrollOffsetY
        self.isVisible = isVisible
    }
    
    var body: some View {
        Canvas { context, size in
            // Fill background
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(configuration.backgroundColor)
            )
            
            // Calculate cell size
            let cellWidth = size.width / CGFloat(configuration.columns)
            let cellHeight = size.height / CGFloat(configuration.rows)
            let cellSize = min(cellWidth, cellHeight)
            
            // Calculate LED diameter based on cell size and configuration
            let ledDiameter = cellSize * configuration.ledDiameter
            let ledRadius = ledDiameter / 2
            
            // Calculate offsets to center the matrix in the view
            let totalMatrixWidth = cellSize * CGFloat(configuration.columns)
            let totalMatrixHeight = cellSize * CGFloat(configuration.rows)
            let originX = (size.width - totalMatrixWidth) / 2
            let originY = (size.height - totalMatrixHeight) / 2
            
            // Draw each LED
            for row in 0..<configuration.rows {
                // Get colors for this row based on color pattern
                let rowLitColor = configuration.colorPattern.color(forRow: row, totalRows: configuration.rows).color
                let rowUnlitColor = configuration.colorPattern.unlitColor(
                    forRow: row,
                    totalRows: configuration.rows,
                    brightness: configuration.unlitBrightness
                )
                
                for col in 0..<configuration.columns {
                    // Calculate the source pixel considering scroll offset
                    let sourceCol = col + Int(scrollOffsetX.rounded())
                    let sourceRow = row + Int(scrollOffsetY.rounded())
                    
                    // Get pixel state
                    let state: LEDState
                    if sourceCol >= 0 && sourceCol < buffer.columns &&
                       sourceRow >= 0 && sourceRow < buffer.rows {
                        state = buffer[sourceRow, sourceCol]
                    } else {
                        state = .off
                    }
                    
                    // Calculate LED center position
                    let centerX = originX + CGFloat(col) * cellSize + cellSize / 2
                    let centerY = originY + CGFloat(row) * cellSize + cellSize / 2
                    
                    // Create circular LED path
                    let ledRect = CGRect(
                        x: centerX - ledRadius,
                        y: centerY - ledRadius,
                        width: ledDiameter,
                        height: ledDiameter
                    )
                    let ledPath = Path(ellipseIn: ledRect)
                    
                    // Determine color based on state and visibility
                    let color: Color
                    if !isVisible {
                        // Blink off state - show unlit
                        color = rowUnlitColor
                    } else if state == .on {
                        color = rowLitColor
                    } else {
                        color = rowUnlitColor
                    }
                    
                    // Draw the LED
                    context.fill(ledPath, with: .color(color))
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("LED Matrix Canvas") {
    let font = PixelFont.default
    let buffer = font.rasterize("HELLO", padHeight: 8)
    
    LEDMatrixCanvas(
        buffer: buffer,
        configuration: MatrixConfiguration(
            rows: 8,
            columns: 32,
            ledColor: .red
        )
    )
    .frame(width: 400, height: 100)
    .padding()
    .background(Color.gray.opacity(0.2))
}
