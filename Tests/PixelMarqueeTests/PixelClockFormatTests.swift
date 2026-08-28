import Foundation
import Testing
@testable import PixelMarquee

@Suite("Pixel Clock Format Tests")
struct PixelClockFormatTests {
    private let utc = TimeZone(secondsFromGMT: 0)!
    private let locale = Locale(identifier: "en_US_POSIX")
    private let date = Date(timeIntervalSince1970: 47_706) // 13:15:06 UTC

    @Test("12-hour time")
    func twelveHourTime() {
        #expect(PixelClockFormat.twelveHour.string(from: date, timeZone: utc, locale: locale) == "1:15 PM")
    }

    @Test("12-hour time with seconds")
    func twelveHourTimeWithSeconds() {
        #expect(PixelClockFormat.twelveHourWithSeconds.string(from: date, timeZone: utc, locale: locale) == "1:15:06 PM")
    }

    @Test("24-hour time")
    func twentyFourHourTime() {
        #expect(PixelClockFormat.twentyFourHour.string(from: date, timeZone: utc, locale: locale) == "13:15")
    }

    @Test("24-hour time with seconds")
    func twentyFourHourTimeWithSeconds() {
        #expect(PixelClockFormat.twentyFourHourWithSeconds.string(from: date, timeZone: utc, locale: locale) == "13:15:06")
    }

    @Test("Seconds detection")
    func secondsDetection() {
        #expect(PixelClockFormat.twelveHourWithSeconds.includesSeconds)
        #expect(PixelClockFormat.twentyFourHourWithSeconds.includesSeconds)
        #expect(!PixelClockFormat.twelveHour.includesSeconds)
        #expect(!PixelClockFormat.twentyFourHour.includesSeconds)
    }
}
