// PixelFontTests.swift
// PixelMarqueeTests

import Testing
@testable import PixelMarquee

@Suite("PixelFont Tests")
struct PixelFontTests {
    
    @Test("Default font exists")
    func defaultFontExists() {
        let font = PixelFont.default
        #expect(font.height == 7)
        #expect(font.characterSpacing == 1)
        #expect(font.spaceWidth == 3)
    }
    
    @Test("Default font contains basic ASCII")
    func defaultFontContainsBasicASCII() {
        let font = PixelFont.default
        
        // Check uppercase letters
        for char in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" {
            #expect(font.glyph(for: char) != nil, "Missing uppercase: \(char)")
        }
        
        // Check lowercase letters
        for char in "abcdefghijklmnopqrstuvwxyz" {
            #expect(font.glyph(for: char) != nil, "Missing lowercase: \(char)")
        }
        
        // Check digits
        for char in "0123456789" {
            #expect(font.glyph(for: char) != nil, "Missing digit: \(char)")
        }
        
        // Check common punctuation
        for char in "!@#$%^&*()-=_+[]{}|;':\",./<>?" {
            #expect(font.glyph(for: char) != nil, "Missing punctuation: \(char)")
        }
    }
    
    @Test("Measure width of empty string")
    func measureEmptyString() {
        let font = PixelFont.default
        let width = font.measureWidth("")
        #expect(width == 0)
    }
    
    @Test("Measure width of single character")
    func measureSingleCharacter() {
        let font = PixelFont.default
        
        // 'A' should have a width equal to its glyph width
        if let glyph = font.glyph(for: "A") {
            let width = font.measureWidth("A")
            #expect(width == glyph.width)
        }
    }
    
    @Test("Measure width includes spacing")
    func measureWidthWithSpacing() {
        let font = PixelFont.default
        
        if let glyphA = font.glyph(for: "A"),
           let glyphB = font.glyph(for: "B") {
            let width = font.measureWidth("AB")
            let expected = glyphA.width + font.characterSpacing + glyphB.width
            #expect(width == expected)
        }
    }
    
    @Test("Measure width handles spaces")
    func measureWidthWithSpaces() {
        let font = PixelFont.default
        
        let widthWithoutSpace = font.measureWidth("AB")
        let widthWithSpace = font.measureWidth("A B")
        
        // Width with space should be larger by spaceWidth + 2 * characterSpacing
        let expectedDiff = font.spaceWidth + font.characterSpacing
        #expect(widthWithSpace == widthWithoutSpace + expectedDiff)
    }
    
    @Test("Rasterize produces correct height")
    func rasterizeHeight() {
        let font = PixelFont.default
        let buffer = font.rasterize("Hello")
        
        #expect(buffer.rows == font.height)
    }
    
    @Test("Rasterize produces correct width")
    func rasterizeWidth() {
        let font = PixelFont.default
        let buffer = font.rasterize("Hi")
        
        let expectedWidth = font.measureWidth("Hi")
        #expect(buffer.columns == expectedWidth)
    }
    
    @Test("Rasterize with padding")
    func rasterizeWithPadding() {
        let font = PixelFont.default
        let buffer = font.rasterize("Hi", padHeight: 16)
        
        #expect(buffer.rows == 16)
    }
    
    @Test("Rasterize with alignment - center")
    func rasterizeWithCenterAlignment() {
        let font = PixelFont.default
        let buffer = font.rasterize("Hi", width: 100, height: 8, alignment: .center)
        
        #expect(buffer.columns == 100)
        #expect(buffer.rows == 8)
        
        // First column should be off (padding)
        #expect(buffer[0, 0] == .off)
    }
    
    @Test("Rasterize empty string")
    func rasterizeEmptyString() {
        let font = PixelFont.default
        let buffer = font.rasterize("")
        
        #expect(buffer.rows == font.height)
        #expect(buffer.columns == 0)
    }
    
    @Test("Custom font creation")
    func customFontCreation() {
        let glyphs: [Character: PixelGlyph] = [
            "X": PixelGlyph(rows: [
                "101",
                "010",
                "101"
            ])
        ]
        
        let font = PixelFont(glyphs: glyphs, height: 3, characterSpacing: 1, spaceWidth: 2)
        
        #expect(font.height == 3)
        #expect(font.characterSpacing == 1)
        #expect(font.spaceWidth == 2)
        #expect(font.glyph(for: "X") != nil)
        #expect(font.glyph(for: "Y") == nil)
    }
}

@Suite("PixelGlyph Tests")
struct PixelGlyphTests {
    
    @Test("Glyph from binary rows")
    func glyphFromBinaryRows() {
        let glyph = PixelGlyph(rows: [
            "111",
            "101",
            "111"
        ])
        
        #expect(glyph.width == 3)
        #expect(glyph.height == 3)
        #expect(glyph[0, 0] == true)
        #expect(glyph[1, 1] == false)
        #expect(glyph[2, 2] == true)
    }
    
    @Test("Glyph from bool array")
    func glyphFromBoolArray() {
        let bitmap = [
            [true, false],
            [false, true]
        ]
        let glyph = PixelGlyph(bitmap: bitmap)
        
        #expect(glyph.width == 2)
        #expect(glyph.height == 2)
        #expect(glyph[0, 0] == true)
        #expect(glyph[0, 1] == false)
        #expect(glyph[1, 0] == false)
        #expect(glyph[1, 1] == true)
    }
    
    @Test("Glyph subscript bounds checking")
    func glyphBoundsChecking() {
        let glyph = PixelGlyph(rows: ["11", "11"])
        
        // In bounds
        #expect(glyph[0, 0] == true)
        
        // Out of bounds returns false
        #expect(glyph[-1, 0] == false)
        #expect(glyph[0, -1] == false)
        #expect(glyph[10, 0] == false)
        #expect(glyph[0, 10] == false)
    }
    
    @Test("Glyph to pixel buffer conversion")
    func glyphToPixelBuffer() {
        let glyph = PixelGlyph(rows: [
            "10",
            "01"
        ])
        
        let buffer = glyph.toPixelBuffer()
        
        #expect(buffer.rows == 2)
        #expect(buffer.columns == 2)
        #expect(buffer[0, 0] == .on)
        #expect(buffer[0, 1] == .off)
        #expect(buffer[1, 0] == .off)
        #expect(buffer[1, 1] == .on)
    }
}
