// PixelMarqueeClockView.swift
// PixelMarquee

import SwiftUI

/// The time format displayed by ``PixelMarqueeClockView``.
public enum PixelClockFormat: String, CaseIterable, Sendable {
    case twelveHour
    case twelveHourWithSeconds
    case twentyFourHour
    case twentyFourHourWithSeconds

    /// Whether the format includes seconds.
    public var includesSeconds: Bool {
        switch self {
        case .twelveHourWithSeconds, .twentyFourHourWithSeconds:
            return true
        case .twelveHour, .twentyFourHour:
            return false
        }
    }

    /// Formats a date for display on the clock.
    public func string(
        from date: Date,
        timeZone: TimeZone = .autoupdatingCurrent,
        locale: Locale = .autoupdatingCurrent
    ) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone

        switch self {
        case .twelveHour:
            formatter.dateFormat = "h:mm a"
        case .twelveHourWithSeconds:
            formatter.dateFormat = "h:mm:ss a"
        case .twentyFourHour:
            formatter.dateFormat = "HH:mm"
        case .twentyFourHourWithSeconds:
            formatter.dateFormat = "HH:mm:ss"
        }

        return formatter.string(from: date)
    }
}

/// A live clock rendered as an LED matrix display.
///
/// The clock refreshes once per minute, or once per second when its format
/// includes seconds. It supports the same visual configuration as
/// ``PixelMarqueeView``.
public struct PixelMarqueeClockView: View {
    private let format: PixelClockFormat
    private let timeZone: TimeZone
    private let locale: Locale
    private let font: PixelFont
    private var configuration: MatrixConfiguration

    /// Creates a live LED clock.
    /// - Parameters:
    ///   - format: The clock's 12- or 24-hour time format.
    ///   - timeZone: The time zone to display.
    ///   - locale: The locale used to render the AM/PM marker.
    ///   - font: The pixel font used to render the time.
    public init(
        format: PixelClockFormat = .twelveHourWithSeconds,
        timeZone: TimeZone = .autoupdatingCurrent,
        locale: Locale = .autoupdatingCurrent,
        font: PixelFont = .default
    ) {
        self.format = format
        self.timeZone = timeZone
        self.locale = locale
        self.font = font
        self.configuration = MatrixConfiguration(
            rows: 8,
            columns: format.includesSeconds ? 72 : 48,
            ledColor: .amber
        )
    }

    public var body: some View {
        TimelineView(.periodic(from: .now, by: format.includesSeconds ? 1 : 60)) { timeline in
            PixelMarqueeView(
                format.string(from: timeline.date, timeZone: timeZone, locale: locale),
                font: font
            )
            .configuration(configuration)
        }
    }
}

// MARK: - View Modifiers

extension PixelMarqueeClockView {
    public func matrixSize(rows: Int, columns: Int) -> PixelMarqueeClockView {
        var copy = self
        copy.configuration.rows = max(1, rows)
        copy.configuration.columns = max(1, columns)
        return copy
    }

    public func ledColor(_ color: LEDColor) -> PixelMarqueeClockView {
        var copy = self
        copy.configuration.ledColor = color
        return copy
    }

    public func colorPattern(_ pattern: ColorPattern) -> PixelMarqueeClockView {
        var copy = self
        copy.configuration.colorPattern = pattern
        return copy
    }

    public func ledStyle(diameter: CGFloat = 0.7, spacing: CGFloat = 1) -> PixelMarqueeClockView {
        var copy = self
        copy.configuration.ledDiameter = min(max(diameter, 0.1), 1)
        copy.configuration.ledSpacing = max(0, spacing)
        return copy
    }

    public func backgroundColor(_ color: Color) -> PixelMarqueeClockView {
        var copy = self
        copy.configuration.backgroundColor = color
        return copy
    }

    public func unlitBrightness(_ brightness: CGFloat) -> PixelMarqueeClockView {
        var copy = self
        copy.configuration.unlitBrightness = min(max(brightness, 0), 1)
        return copy
    }

    public func configuration(_ configuration: MatrixConfiguration) -> PixelMarqueeClockView {
        var copy = self
        copy.configuration = configuration
        return copy
    }
}

#Preview("LED Clock") {
    PixelMarqueeClockView(format: .twentyFourHourWithSeconds)
        .ledColor(.cyan)
        .frame(width: 600, height: 100)
        .padding()
        .background(Color.black)
}
