// PixelMarquee
// A Swift library for simulating classic LED matrix sign displays
//
// Copyright (c) 2026 Rebecca
// MIT License

import Foundation

/// PixelMarquee is a Swift library that simulates classic LED matrix sign displays
/// with authentic circular LEDs, configurable colors, and smooth scrolling animations.
///
/// ## Basic Usage
///
/// ```swift
/// import PixelMarquee
///
/// // Simple scrolling text
/// PixelMarqueeView("Hello, World!")
///     .matrixSize(rows: 8, columns: 32)
///     .ledColor(.red)
///     .scrolling(.left())
/// ```
///
/// ## Features
///
/// - Authentic circular LED rendering with visible gaps
/// - Full RGB color support with classic presets
/// - Horizontal and vertical scrolling
/// - Blink effects
/// - Built-in 5×7 pixel font (full ASCII)
/// - Custom font support
/// - SwiftUI, UIKit, and AppKit compatibility
