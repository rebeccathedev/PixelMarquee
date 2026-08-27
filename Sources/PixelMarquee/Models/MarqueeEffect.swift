// MarqueeEffect.swift
// PixelMarquee

import Foundation

/// Defines the animation effect applied to the marquee display.
///
/// ## Usage
///
/// ```swift
/// PixelMarqueeView("Hello")
///     .effect(.scrolling(.left()))
///
/// PixelMarqueeView("ALERT")
///     .effect(.blink(interval: 0.5))
/// ```
public enum MarqueeEffect: Equatable, Sendable {
    /// No animation - static display
    case none
    
    /// Scrolling text animation
    case scrolling(ScrollConfiguration)
    
    /// Blinking text animation
    case blink(interval: TimeInterval)
    
    /// Default scrolling effect (horizontal left at moderate speed)
    public static var scroll: MarqueeEffect {
        .scrolling(.left())
    }
}

/// Configuration for scrolling animation behavior.
public struct ScrollConfiguration: Equatable, Sendable {
    /// The direction of scrolling
    public let direction: ScrollDirection
    
    /// Speed of scrolling in pixels per second
    public let speed: Double
    
    /// Whether to pause at the start before scrolling begins
    public let pauseAtStart: TimeInterval
    
    /// Whether to loop the scroll animation
    public let loops: Bool
    
    /// Creates a scroll configuration.
    /// - Parameters:
    ///   - direction: The direction to scroll
    ///   - speed: Pixels per second (default: 30)
    ///   - pauseAtStart: Time to pause before scrolling starts (default: 0)
    ///   - loops: Whether to loop continuously (default: true)
    public init(
        direction: ScrollDirection,
        speed: Double = 30,
        pauseAtStart: TimeInterval = 0,
        loops: Bool = true
    ) {
        self.direction = direction
        self.speed = speed
        self.pauseAtStart = pauseAtStart
        self.loops = loops
    }
    
    // MARK: - Convenience Initializers
    
    /// Scroll left (most common marquee direction)
    /// - Parameters:
    ///   - speed: Pixels per second (default: 30)
    ///   - pauseAtStart: Initial pause duration (default: 0)
    /// - Returns: A left-scrolling configuration
    public static func left(speed: Double = 30, pauseAtStart: TimeInterval = 0) -> ScrollConfiguration {
        ScrollConfiguration(direction: .left, speed: speed, pauseAtStart: pauseAtStart)
    }
    
    /// Scroll right
    /// - Parameters:
    ///   - speed: Pixels per second (default: 30)
    ///   - pauseAtStart: Initial pause duration (default: 0)
    /// - Returns: A right-scrolling configuration
    public static func right(speed: Double = 30, pauseAtStart: TimeInterval = 0) -> ScrollConfiguration {
        ScrollConfiguration(direction: .right, speed: speed, pauseAtStart: pauseAtStart)
    }
    
    /// Scroll up
    /// - Parameters:
    ///   - speed: Pixels per second (default: 30)
    ///   - pauseAtStart: Initial pause duration (default: 0)
    /// - Returns: An upward-scrolling configuration
    public static func up(speed: Double = 30, pauseAtStart: TimeInterval = 0) -> ScrollConfiguration {
        ScrollConfiguration(direction: .up, speed: speed, pauseAtStart: pauseAtStart)
    }
    
    /// Scroll down
    /// - Parameters:
    ///   - speed: Pixels per second (default: 30)
    ///   - pauseAtStart: Initial pause duration (default: 0)
    /// - Returns: A downward-scrolling configuration
    public static func down(speed: Double = 30, pauseAtStart: TimeInterval = 0) -> ScrollConfiguration {
        ScrollConfiguration(direction: .down, speed: speed, pauseAtStart: pauseAtStart)
    }
}

/// The direction of scrolling animation.
public enum ScrollDirection: Equatable, Sendable {
    /// Scroll horizontally to the left
    case left
    /// Scroll horizontally to the right
    case right
    /// Scroll vertically upward
    case up
    /// Scroll vertically downward
    case down
    
    /// Whether this is a horizontal scroll direction
    public var isHorizontal: Bool {
        self == .left || self == .right
    }
    
    /// Whether this is a vertical scroll direction
    public var isVertical: Bool {
        self == .up || self == .down
    }
    
    /// The sign of movement (-1 for left/up, +1 for right/down)
    public var sign: Double {
        switch self {
        case .left, .up: return -1
        case .right, .down: return 1
        }
    }
}
