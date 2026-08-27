// MarqueeAnimationState.swift
// PixelMarquee

import SwiftUI

/// Observable state for marquee animations.
///
/// Uses the new iOS 17+ `@Observable` macro for efficient SwiftUI updates.
@Observable
public final class MarqueeAnimationState {
    /// Current scroll offset in pixels (can be fractional for smooth animation)
    public var scrollOffset: CGFloat = 0
    
    /// Whether the animation is currently paused
    public var isPaused: Bool = false
    
    /// Whether the text is currently visible (for blink effect)
    public var isVisible: Bool = true
    
    /// The start time of the animation
    public var startTime: Date?
    
    /// Whether we've completed the initial pause (if any)
    public var hasStartedScrolling: Bool = false
    
    /// Creates a new animation state.
    public init() {}
    
    /// Resets the animation to its initial state.
    public func reset() {
        scrollOffset = 0
        isVisible = true
        startTime = nil
        hasStartedScrolling = false
    }
    
    /// Updates the scroll offset based on elapsed time and configuration.
    /// - Parameters:
    ///   - elapsed: Time since animation started
    ///   - config: Scroll configuration
    ///   - contentWidth: Total width of content being scrolled
    ///   - viewportWidth: Width of the visible viewport
    public func updateScroll(
        elapsed: TimeInterval,
        config: ScrollConfiguration,
        contentWidth: Int,
        viewportWidth: Int
    ) {
        guard !isPaused else { return }
        
        // Handle initial pause
        if !hasStartedScrolling {
            if elapsed < config.pauseAtStart {
                return
            }
            hasStartedScrolling = true
        }
        
        let adjustedElapsed = elapsed - config.pauseAtStart
        
        // Calculate offset based on direction and speed
        let pixelsScrolled = adjustedElapsed * config.speed
        
        // For scrolling, we need to handle the full cycle:
        // Content enters from one side, scrolls through, and exits the other side
        let totalScrollDistance: CGFloat
        
        if config.direction.isHorizontal {
            // Start with content just off-screen, end when it's fully off the other side
            totalScrollDistance = CGFloat(viewportWidth + contentWidth)
        } else {
            totalScrollDistance = CGFloat(viewportWidth + contentWidth)
        }
        
        if config.loops {
            // Continuous looping
            scrollOffset = CGFloat(pixelsScrolled).truncatingRemainder(dividingBy: totalScrollDistance)
        } else {
            // Single pass
            scrollOffset = min(CGFloat(pixelsScrolled), totalScrollDistance)
        }
    }
    
    /// Updates visibility for blink effect.
    /// - Parameters:
    ///   - elapsed: Time since animation started
    ///   - interval: Blink interval in seconds
    public func updateBlink(elapsed: TimeInterval, interval: TimeInterval) {
        guard !isPaused, interval > 0 else {
            isVisible = true
            return
        }
        
        // Simple on/off toggle based on interval
        let cyclePosition = elapsed.truncatingRemainder(dividingBy: interval * 2)
        isVisible = cyclePosition < interval
    }
}
