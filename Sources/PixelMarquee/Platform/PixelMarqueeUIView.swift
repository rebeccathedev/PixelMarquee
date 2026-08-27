// PixelMarqueeUIView.swift
// PixelMarquee
//
// UIKit wrapper for PixelMarqueeView

#if canImport(UIKit)
import UIKit
import SwiftUI

/// A UIKit view that wraps `PixelMarqueeView` for use in UIKit-based apps.
///
/// ## Usage
///
/// ```swift
/// let marquee = PixelMarqueeUIView()
/// marquee.text = "Hello, UIKit!"
/// marquee.ledColor = .red
/// marquee.effect = .scrolling(.left())
/// view.addSubview(marquee)
/// ```
@MainActor
public final class PixelMarqueeUIView: UIView {
    // MARK: - Properties
    
    /// The text to display
    public var text: String = "" {
        didSet { updateHostingController() }
    }
    
    /// The pixel font to use
    public var font: PixelFont = .default {
        didSet { updateHostingController() }
    }
    
    /// Number of LED rows
    public var rows: Int = 8 {
        didSet { updateHostingController() }
    }
    
    /// Number of LED columns
    public var columns: Int = 32 {
        didSet { updateHostingController() }
    }
    
    /// LED color
    public var ledColor: LEDColor = .red {
        didSet { updateHostingController() }
    }
    
    /// LED diameter relative to cell size (0.0-1.0)
    public var ledDiameter: CGFloat = 0.7 {
        didSet { updateHostingController() }
    }
    
    /// Background color
    public var matrixBackgroundColor: UIColor = .black {
        didSet { updateHostingController() }
    }
    
    /// Brightness of unlit LEDs (0.0-1.0)
    public var unlitBrightness: CGFloat = 0.15 {
        didSet { updateHostingController() }
    }
    
    /// Animation effect
    public var effect: MarqueeEffect = .none {
        didSet { updateHostingController() }
    }
    
    /// Whether animation is paused
    public var isPaused: Bool = false {
        didSet { updateHostingController() }
    }
    
    // MARK: - Private Properties
    
    private var hostingController: UIHostingController<PixelMarqueeView>?
    
    // MARK: - Initialization
    
    /// Creates a new pixel marquee UIView.
    /// - Parameter text: Initial text to display (default: empty)
    public init(text: String = "") {
        self.text = text
        super.init(frame: .zero)
        setupHostingController()
    }
    
    /// Creates a new pixel marquee UIView with configuration.
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
        self.matrixBackgroundColor = UIColor(configuration.backgroundColor)
        self.effect = effect
        updateHostingController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHostingController()
    }
    
    // MARK: - Setup
    
    private func setupHostingController() {
        let swiftUIView = createSwiftUIView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.backgroundColor = .clear
        
        addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.hostingController = hostingController
    }
    
    private func updateHostingController() {
        hostingController?.rootView = createSwiftUIView()
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
