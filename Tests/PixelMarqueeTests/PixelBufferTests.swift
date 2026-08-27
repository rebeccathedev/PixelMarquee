// PixelBufferTests.swift
// PixelMarqueeTests

import Testing
@testable import PixelMarquee

@Suite("PixelBuffer Tests")
struct PixelBufferTests {
    
    @Test("Empty buffer initialization")
    func emptyBuffer() {
        let buffer = PixelBuffer(rows: 8, columns: 32)
        
        #expect(buffer.rows == 8)
        #expect(buffer.columns == 32)
        #expect(buffer.isEmpty == false)
        
        // All pixels should be off
        for row in 0..<8 {
            for col in 0..<32 {
                #expect(buffer[row, col] == .off)
            }
        }
    }
    
    @Test("Zero dimension buffer")
    func zeroDimensionBuffer() {
        let buffer = PixelBuffer(rows: 0, columns: 0)
        #expect(buffer.isEmpty == true)
        #expect(buffer.rows == 0)
        #expect(buffer.columns == 0)
    }
    
    @Test("Filled buffer initialization")
    func filledBuffer() {
        let buffer = PixelBuffer(rows: 3, columns: 3, fill: .on)
        
        for row in 0..<3 {
            for col in 0..<3 {
                #expect(buffer[row, col] == .on)
            }
        }
    }
    
    @Test("Bool grid initialization")
    func boolGridInit() {
        let grid = [
            [true, false, true],
            [false, true, false]
        ]
        let buffer = PixelBuffer(boolGrid: grid)
        
        #expect(buffer.rows == 2)
        #expect(buffer.columns == 3)
        #expect(buffer[0, 0] == .on)
        #expect(buffer[0, 1] == .off)
        #expect(buffer[0, 2] == .on)
        #expect(buffer[1, 0] == .off)
        #expect(buffer[1, 1] == .on)
        #expect(buffer[1, 2] == .off)
    }
    
    @Test("Subscript get/set")
    func subscriptAccess() {
        var buffer = PixelBuffer(rows: 4, columns: 4)
        
        buffer[1, 2] = .on
        #expect(buffer[1, 2] == .on)
        #expect(buffer[0, 0] == .off)
        
        // Out of bounds should return .off
        #expect(buffer[-1, 0] == .off)
        #expect(buffer[0, -1] == .off)
        #expect(buffer[100, 0] == .off)
        #expect(buffer[0, 100] == .off)
    }
    
    @Test("Clear buffer")
    func clearBuffer() {
        var buffer = PixelBuffer(rows: 3, columns: 3, fill: .on)
        buffer.clear()
        
        for row in 0..<3 {
            for col in 0..<3 {
                #expect(buffer[row, col] == .off)
            }
        }
    }
    
    @Test("Blit operation")
    func blitBuffer() {
        let source = PixelBuffer(boolGrid: [
            [true, true],
            [true, true]
        ])
        
        var dest = PixelBuffer(rows: 4, columns: 4)
        dest.blit(source, offsetX: 1, offsetY: 1)
        
        // Check that the 2x2 square is blitted at offset (1, 1)
        #expect(dest[0, 0] == .off)
        #expect(dest[1, 1] == .on)
        #expect(dest[1, 2] == .on)
        #expect(dest[2, 1] == .on)
        #expect(dest[2, 2] == .on)
        #expect(dest[3, 3] == .off)
    }
    
    @Test("Horizontal scroll")
    func horizontalScroll() {
        let buffer = PixelBuffer(boolGrid: [
            [true, false, false, false]
        ])
        
        let scrolled = buffer.scrolledHorizontally(by: 1)
        
        #expect(scrolled[0, 0] == .off)
        #expect(scrolled[0, 1] == .on)
        #expect(scrolled[0, 2] == .off)
        #expect(scrolled[0, 3] == .off)
    }
    
    @Test("Vertical scroll")
    func verticalScroll() {
        let buffer = PixelBuffer(boolGrid: [
            [true],
            [false],
            [false],
            [false]
        ])
        
        let scrolled = buffer.scrolledVertically(by: 1)
        
        #expect(scrolled[0, 0] == .off)
        #expect(scrolled[1, 0] == .on)
        #expect(scrolled[2, 0] == .off)
        #expect(scrolled[3, 0] == .off)
    }
    
    @Test("Buffer concatenation")
    func bufferConcatenation() {
        let left = PixelBuffer(boolGrid: [
            [true, true]
        ])
        let right = PixelBuffer(boolGrid: [
            [false, false]
        ])
        
        let combined = left + right
        
        #expect(combined.rows == 1)
        #expect(combined.columns == 4)
        #expect(combined[0, 0] == .on)
        #expect(combined[0, 1] == .on)
        #expect(combined[0, 2] == .off)
        #expect(combined[0, 3] == .off)
    }
    
    @Test("Row accessor")
    func rowAccessor() {
        let buffer = PixelBuffer(boolGrid: [
            [true, false, true],
            [false, true, false]
        ])
        
        let row0 = buffer.row(0)
        #expect(row0.count == 3)
        #expect(row0[0] == .on)
        #expect(row0[1] == .off)
        #expect(row0[2] == .on)
        
        // Out of bounds
        let invalidRow = buffer.row(10)
        #expect(invalidRow.isEmpty)
    }
}
