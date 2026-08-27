// PixelMarqueeNSView.swift
// PixelMarquee
//
// AppKit wrapper for PixelMarqueeView

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import SwiftUI

/// An AppKit view that wraps `PixelMarqueeView` for use in AppKit-based apps.
///
/// ## Usage
///
/// ```swift
/// let marquee = PixelMarqueeNSView()
/// marquee.text = "Hello, AppKit!"
/// marquee.ledColor = .red
/// marquee.effect = .scrolling(.left())
/// view.addSubview(marquee)
/// ```
@MainActor
public final class PixelMarqueeNSView: NSView {
    // MARK: - Properties
    
    /// The text to display
    public var text: String = "" {
        didSet { updateHostingView() }
    }
    
    /// The pixel font to use
    public var font: PixelFont = .default {
        didSet { updateHostingView() }
    }
    
    /// Number of LED rows
    public var rows: Int = 8 {
        didSet { updateHostingView() }
    }
    
    /// Number of LED columns
    public var columns: Int = 32 {
        didSet { updateHostingView() }
    }
    
    /// LED color
    public var ledColor: LEDColor = .red {
        didSet { updateHostingView() }
    }
    
    /// LED diameter relative to cell size (0.0-1.0)
    public var ledDiameter: CGFloat = 0.7 {
        didSet { updateHostingView() }
    }
    
    /// Background color
    public var matrixBackgroundColor: NSColor = .black {
        didSet { updateHostingView() }
    }
    
    /// Brightness of unlit LEDs (0.0-1.0)
    public var unlitBrightness: CGFloat = 0.15 {
        didSet { updateHostingView() }
    }
    
    /// Animation effect
    public var effect: MarqueeEffect = .none {
        didSet { updateHostingView() }
    }
    
    /// Whether animation is paused
    public var isPaused: Bool = false {
        didSet { updateHostingView() }
    }
    
    // MARK: - Private Properties
    
    private var hostingView: NSHostingView<PixelMarqueeView>?
    
    // MARK: - Initialization
    
    /// Creates a new pixel marquee NSView.
    /// - Parameter text: Initial text to display (default: empty)
    public init(text: String = "") {
        self.text = text
        super.init(frame: .zero)
        setupHostingView()
    }
    
    /// Creates a new pixel marquee NSView with configuration.
    /// - Parameters:
    ///   - text: Text to display
    ///   - configuration: Matrix configuration
    ///   - effect: Animation effect
    public convenience init(
        text: String,
        configuration: MatrixConfiguration,
        effect: MarqueeEffect = .none
    ) {
        self.init(text: text)
        self.rows = configuration.rows
        self.columns = configuration.columns
        self.ledColor = configuration.ledColor
        self.ledDiameter = configuration.ledDiameter
        self.unlitBrightness = configuration.unlitBrightness
        self.matrixBackgroundColor = NSColor(configuration.backgroundColor)
        self.effect = effect
        updateHostingView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHostingView()
    }
    
    // MARK: - Setup
    
    private func setupHostingView() {
        let swiftUIView = createSwiftUIView()
        let hostingView = NSHostingView(rootView: swiftUIView)
        
        addSubview(hostingView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: topAnchor),
            hostingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.hostingView = hostingView
    }
    
    private func updateHostingView() {
        hostingView?.rootView = createSwiftUIView()
    }
    
    private func createSwiftUIView() -> PixelMarqueeView {
        let config = MatrixConfiguration(
            rows: rows,
            columns: columns,
            ledDiameter: ledDiameter,
            ledSpacing: 1,
            ledColor: ledColor,
            unlitBrightness: unlitBrightness,
            backgroundColor: Color(matrixBackgroundColor)
        )
        
        return PixelMarqueeView(text, font: font)
            .configuration(config)
            .effect(effect)
            .paused(isPaused)
    }
    
    // MARK: - Public Methods
    
    /// Starts or resumes the animation.
    public func play() {
        isPaused = false
    }
    
    /// Pauses the animation.
    public func pause() {
        isPaused = true
    }
    
    /// Toggles between playing and paused states.
    public func togglePlayPause() {
        isPaused.toggle()
    }
}
#endif
