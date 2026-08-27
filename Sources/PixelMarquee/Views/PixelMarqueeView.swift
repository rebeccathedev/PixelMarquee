// PixelMarqueeView.swift
// PixelMarquee

import SwiftUI

/// A SwiftUI view that displays text on a simulated LED matrix display.
///
/// `PixelMarqueeView` renders text using a pixel font on an authentic-looking
/// LED matrix with circular LEDs, gaps between them, and configurable colors.
///
/// ## Basic Usage
///
/// ```swift
/// PixelMarqueeView("Hello, World!")
///     .matrixSize(rows: 8, columns: 32)
///     .ledColor(.red)
///     .scrolling(.left())
/// ```
///
/// ## Static Display
///
/// ```swift
/// PixelMarqueeView("OPEN")
///     .matrixSize(rows: 8, columns: 24)
///     .ledColor(.green)
/// ```
///
/// ## Blinking Text
///
/// ```swift
/// PixelMarqueeView("ALERT")
///     .effect(.blink(interval: 0.5))
/// ```
public struct PixelMarqueeView: View {
    // MARK: - Properties
    
    /// The text to display
    private let text: String
    
    /// The pixel font to use for rendering
    private let font: PixelFont
    
    /// Matrix configuration
    private var configuration: MatrixConfiguration
    
    /// Animation effect
    private var effect: MarqueeEffect
    
    /// Whether animation is paused
    private var isPaused: Bool
    
    /// Animation state
    @State private var animationState = MarqueeAnimationState()
    
    /// Cached pixel buffer of rendered text
    @State private var textBuffer: PixelBuffer?
    
    // MARK: - Initialization
    
    /// Creates a new pixel marquee view with the specified text.
    /// - Parameters:
    ///   - text: The text to display
    ///   - font: The pixel font to use (defaults to the built-in 5×7 font)
    public init(_ text: String, font: PixelFont = .default) {
        self.text = text
        self.font = font
        self.configuration = .standard
        self.effect = .none
        self.isPaused = false
    }
    
    // MARK: - Body
    
    public var body: some View {
        TimelineView(.animation(minimumInterval: 1.0/60.0, paused: shouldPauseTimeline)) { timeline in
            let buffer = currentBuffer
            let (offsetX, offsetY) = calculateScrollOffset(at: timeline.date, buffer: buffer)
            
            LEDMatrixCanvas(
                buffer: buffer,
                configuration: configuration,
                scrollOffsetX: offsetX,
                scrollOffsetY: offsetY,
                isVisible: animationState.isVisible
            )
            .onChange(of: timeline.date) { _, newDate in
                updateAnimation(at: newDate, buffer: buffer)
            }
        }
        .onAppear {
            renderText()
            animationState.startTime = Date()
        }
        .onChange(of: text) { _, _ in
            renderText()
            animationState.reset()
            animationState.startTime = Date()
        }
        .onChange(of: isPaused) { _, newValue in
            animationState.isPaused = newValue
        }
    }
    
    // MARK: - Private Methods
    
    /// Whether the timeline should be paused
    private var shouldPauseTimeline: Bool {
        isPaused || effect == .none
    }
    
    /// The current pixel buffer to display
    private var currentBuffer: PixelBuffer {
        textBuffer ?? PixelBuffer(rows: configuration.rows, columns: configuration.columns)
    }
    
    /// Renders the text to a pixel buffer
    private func renderText() {
        textBuffer = font.rasterize(text, padHeight: configuration.rows)
    }
    
    /// Calculates scroll offset based on current time and effect configuration
    private func calculateScrollOffset(at date: Date, buffer: PixelBuffer) -> (CGFloat, CGFloat) {
        guard case .scrolling(let config) = effect,
              let startTime = animationState.startTime else {
            return (0, 0)
        }
        
        let elapsed = date.timeIntervalSince(startTime)
        
        // Handle initial pause
        let effectiveElapsed: TimeInterval
        if elapsed < config.pauseAtStart {
            return calculateInitialOffset(config: config, buffer: buffer)
        } else {
            effectiveElapsed = elapsed - config.pauseAtStart
        }
        
        let pixelsScrolled = effectiveElapsed * config.speed
        
        switch config.direction {
        case .left:
            // Content starts off-screen right, scrolls left
            let totalDistance = CGFloat(configuration.columns + buffer.columns)
            let rawOffset = pixelsScrolled.truncatingRemainder(dividingBy: Double(totalDistance))
            let offset = CGFloat(rawOffset) - CGFloat(configuration.columns)
            return (offset, 0)
            
        case .right:
            // Content starts off-screen left, scrolls right
            let totalDistance = CGFloat(configuration.columns + buffer.columns)
            let rawOffset = pixelsScrolled.truncatingRemainder(dividingBy: Double(totalDistance))
            let offset = CGFloat(buffer.columns) - CGFloat(rawOffset)
            return (offset, 0)
            
        case .up:
            // Content starts below, scrolls up
            let totalDistance = CGFloat(configuration.rows + buffer.rows)
            let rawOffset = pixelsScrolled.truncatingRemainder(dividingBy: Double(totalDistance))
            let offset = CGFloat(rawOffset) - CGFloat(configuration.rows)
            return (0, offset)
            
        case .down:
            // Content starts above, scrolls down
            let totalDistance = CGFloat(configuration.rows + buffer.rows)
            let rawOffset = pixelsScrolled.truncatingRemainder(dividingBy: Double(totalDistance))
            let offset = CGFloat(buffer.rows) - CGFloat(rawOffset)
            return (0, offset)
        }
    }
    
    /// Calculates the initial offset before scrolling starts
    private func calculateInitialOffset(config: ScrollConfiguration, buffer: PixelBuffer) -> (CGFloat, CGFloat) {
        switch config.direction {
        case .left:
            return (-CGFloat(configuration.columns), 0)
        case .right:
            return (CGFloat(buffer.columns), 0)
        case .up:
            return (0, -CGFloat(configuration.rows))
        case .down:
            return (0, CGFloat(buffer.rows))
        }
    }
    
    /// Updates animation state
    private func updateAnimation(at date: Date, buffer: PixelBuffer) {
        guard let startTime = animationState.startTime else { return }
        let elapsed = date.timeIntervalSince(startTime)
        
        switch effect {
        case .blink(let interval):
            animationState.updateBlink(elapsed: elapsed, interval: interval)
        default:
            break
        }
    }
}

// MARK: - View Modifiers

extension PixelMarqueeView {
    /// Sets the matrix size (rows and columns).
    /// - Parameters:
    ///   - rows: Number of LED rows
    ///   - columns: Number of LED columns
    /// - Returns: Modified view
    public func matrixSize(rows: Int, columns: Int) -> PixelMarqueeView {
        var copy = self
        copy.configuration.rows = max(1, rows)
        copy.configuration.columns = max(1, columns)
        return copy
    }
    
    /// Sets the LED color.
    /// - Parameter color: The color for lit LEDs
    /// - Returns: Modified view
    public func ledColor(_ color: LEDColor) -> PixelMarqueeView {
        var copy = self
        copy.configuration.ledColor = color
        return copy
    }
    
    /// Sets the color pattern for LEDs.
    ///
    /// Use this for multi-color displays like pride flags!
    ///
    /// ```swift
    /// PixelMarqueeView("PRIDE")
    ///     .colorPattern(.transgender)
    ///
    /// PixelMarqueeView("LOVE")
    ///     .colorPattern(.rainbow)
    /// ```
    ///
    /// - Parameter pattern: The color pattern to apply
    /// - Returns: Modified view
    public func colorPattern(_ pattern: ColorPattern) -> PixelMarqueeView {
        var copy = self
        copy.configuration.colorPattern = pattern
        return copy
    }
    
    /// Sets the LED visual style.
    /// - Parameters:
    ///   - diameter: LED diameter relative to cell size (0.0-1.0)
    ///   - spacing: Spacing between LED cells in points
    /// - Returns: Modified view
    public func ledStyle(diameter: CGFloat = 0.7, spacing: CGFloat = 1) -> PixelMarqueeView {
        var copy = self
        copy.configuration.ledDiameter = min(max(diameter, 0.1), 1.0)
        copy.configuration.ledSpacing = max(0, spacing)
        return copy
    }
    
    /// Sets the background color behind the LED matrix.
    /// - Parameter color: Background color
    /// - Returns: Modified view
    public func backgroundColor(_ color: Color) -> PixelMarqueeView {
        var copy = self
        copy.configuration.backgroundColor = color
        return copy
    }
    
    /// Sets the brightness of unlit LEDs.
    /// - Parameter brightness: Brightness factor (0.0 = invisible, 1.0 = full)
    /// - Returns: Modified view
    public func unlitBrightness(_ brightness: CGFloat) -> PixelMarqueeView {
        var copy = self
        copy.configuration.unlitBrightness = min(max(brightness, 0), 1.0)
        return copy
    }
    
    /// Sets the animation effect.
    /// - Parameter effect: The effect to apply
    /// - Returns: Modified view
    public func effect(_ effect: MarqueeEffect) -> PixelMarqueeView {
        var copy = self
        copy.effect = effect
        return copy
    }
    
    /// Configures horizontal scrolling.
    /// - Parameter config: Scroll configuration
    /// - Returns: Modified view
    public func scrolling(_ config: ScrollConfiguration) -> PixelMarqueeView {
        var copy = self
        copy.effect = .scrolling(config)
        return copy
    }
    
    /// Pauses or resumes the animation.
    /// - Parameter paused: Whether to pause
    /// - Returns: Modified view
    public func paused(_ paused: Bool) -> PixelMarqueeView {
        var copy = self
        copy.isPaused = paused
        return copy
    }
    
    /// Applies a complete matrix configuration.
    /// - Parameter config: The configuration to apply
    /// - Returns: Modified view
    public func configuration(_ config: MatrixConfiguration) -> PixelMarqueeView {
        var copy = self
        copy.configuration = config
        return copy
    }
}

// MARK: - Previews

#Preview("Static Display") {
    PixelMarqueeView("HELLO")
        .matrixSize(rows: 8, columns: 32)
        .ledColor(.red)
        .frame(width: 400, height: 100)
}

#Preview("Scrolling Left") {
    PixelMarqueeView("Welcome to PixelMarquee!")
        .matrixSize(rows: 8, columns: 32)
        .ledColor(.amber)
        .scrolling(.left(speed: 30))
        .frame(width: 400, height: 100)
}

#Preview("Blinking") {
    PixelMarqueeView("ALERT!")
        .matrixSize(rows: 8, columns: 32)
        .ledColor(.red)
        .effect(.blink(interval: 0.5))
        .frame(width: 400, height: 100)
}

#Preview("Green Display") {
    PixelMarqueeView("OPEN")
        .matrixSize(rows: 8, columns: 24)
        .ledColor(.green)
        .frame(width: 300, height: 100)
}
