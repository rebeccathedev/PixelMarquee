// PixelMarqueeDemoApp.swift
// PixelMarqueeDemo
//
// A demo app showcasing PixelMarquee features

import SwiftUI
import PixelMarquee

@main
struct PixelMarqueeDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Basic Examples") {
                    BasicExamplesView()
                }
                
                NavigationLink("Scrolling Demos") {
                    ScrollingDemosView()
                }
                
                NavigationLink("Color Showcase") {
                    ColorShowcaseView()
                }
                
                NavigationLink("🏳️‍🌈 Pride Flags") {
                    PrideFlagsView()
                }
                
                NavigationLink("Interactive Playground") {
                    PlaygroundView()
                }
                
                NavigationLink("Custom Font Demo") {
                    CustomFontDemoView()
                }
            }
            .navigationTitle("PixelMarquee Demo")
        }
    }
}

// MARK: - Basic Examples

struct BasicExamplesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                DemoCard(title: "Static Text") {
                    PixelMarqueeView("HELLO")
                        .matrixSize(rows: 8, columns: 32)
                        .ledColor(.red)
                        .frame(height: 80)
                }
                
                DemoCard(title: "Green LED") {
                    PixelMarqueeView("OPEN")
                        .matrixSize(rows: 8, columns: 24)
                        .ledColor(.green)
                        .frame(height: 80)
                }
                
                DemoCard(title: "Amber Warning") {
                    PixelMarqueeView("CAUTION")
                        .matrixSize(rows: 8, columns: 40)
                        .ledColor(.amber)
                        .frame(height: 80)
                }
                
                DemoCard(title: "Blinking Alert") {
                    PixelMarqueeView("ALERT!")
                        .matrixSize(rows: 8, columns: 36)
                        .ledColor(.red)
                        .effect(.blink(interval: 0.5))
                        .frame(height: 80)
                }
            }
            .padding()
        }
        .navigationTitle("Basic Examples")
        .background(Color.black.opacity(0.9))
    }
}

// MARK: - Scrolling Demos

struct ScrollingDemosView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                DemoCard(title: "Scroll Left (Classic)") {
                    PixelMarqueeView("Welcome to PixelMarquee! This text scrolls smoothly...")
                        .matrixSize(rows: 8, columns: 32)
                        .ledColor(.red)
                        .scrolling(.left(speed: 30))
                        .frame(height: 80)
                }
                
                DemoCard(title: "Scroll Right") {
                    PixelMarqueeView("Going the other way!")
                        .matrixSize(rows: 8, columns: 32)
                        .ledColor(.cyan)
                        .scrolling(.right(speed: 40))
                        .frame(height: 80)
                }
                
                DemoCard(title: "Scroll Up") {
                    PixelMarqueeView("UP")
                        .matrixSize(rows: 16, columns: 16)
                        .ledColor(.green)
                        .scrolling(.up(speed: 20))
                        .frame(height: 120)
                }
                
                DemoCard(title: "Scroll Down") {
                    PixelMarqueeView("DN")
                        .matrixSize(rows: 16, columns: 16)
                        .ledColor(.amber)
                        .scrolling(.down(speed: 20))
                        .frame(height: 120)
                }
                
                DemoCard(title: "Slow & Dramatic") {
                    PixelMarqueeView("S L O W   M O T I O N")
                        .matrixSize(rows: 8, columns: 48)
                        .ledColor(.magenta)
                        .scrolling(.left(speed: 10))
                        .frame(height: 80)
                }
                
                DemoCard(title: "Fast News Ticker") {
                    PixelMarqueeView("BREAKING NEWS: PixelMarquee is now available! Download today!")
                        .matrixSize(rows: 8, columns: 64)
                        .ledColor(.red)
                        .scrolling(.left(speed: 60))
                        .frame(height: 80)
                }
            }
            .padding()
        }
        .navigationTitle("Scrolling Demos")
        .background(Color.black.opacity(0.9))
    }
}

// MARK: - Color Showcase

struct ColorShowcaseView: View {
    let colors: [(String, LEDColor)] = [
        ("Red", .red),
        ("Green", .green),
        ("Amber", .amber),
        ("Blue", .blue),
        ("Cyan", .cyan),
        ("Magenta", .magenta),
        ("Orange", .orange),
        ("White", .white),
        ("Custom", LEDColor(r: 255, g: 100, b: 150))
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(colors, id: \.0) { name, color in
                    DemoCard(title: name) {
                        PixelMarqueeView(name.uppercased())
                            .matrixSize(rows: 8, columns: 32)
                            .ledColor(color)
                            .frame(height: 60)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Color Showcase")
        .background(Color.black.opacity(0.9))
    }
}

// MARK: - Pride Flags 🏳️‍🌈🏳️‍⚧️

struct PrideFlagsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                DemoCard(title: "🏳️‍⚧️ Transgender") {
                    PixelMarqueeView("TRANS RIGHTS!")
                        .matrixSize(rows: 10, columns: 64)
                        .colorPattern(.transgender)
                        .scrolling(.left(speed: 25))
                        .frame(height: 100)
                }
                
                DemoCard(title: "🏳️‍🌈 Rainbow") {
                    PixelMarqueeView("PRIDE")
                        .matrixSize(rows: 12, columns: 32)
                        .colorPattern(.rainbow)
                        .frame(height: 100)
                }
                
                DemoCard(title: "Bisexual") {
                    PixelMarqueeView("BI PRIDE")
                        .matrixSize(rows: 10, columns: 40)
                        .colorPattern(.bisexual)
                        .frame(height: 100)
                }
                
                DemoCard(title: "Pansexual") {
                    PixelMarqueeView("PAN")
                        .matrixSize(rows: 9, columns: 24)
                        .colorPattern(.pansexual)
                        .frame(height: 90)
                }
                
                DemoCard(title: "Non-Binary") {
                    PixelMarqueeView("ENBY")
                        .matrixSize(rows: 8, columns: 28)
                        .colorPattern(.nonbinary)
                        .frame(height: 80)
                }
                
                DemoCard(title: "Lesbian") {
                    PixelMarqueeView("LESBIAN")
                        .matrixSize(rows: 10, columns: 40)
                        .colorPattern(.lesbian)
                        .frame(height: 100)
                }
                
                DemoCard(title: "Gay/MLM") {
                    PixelMarqueeView("GAY")
                        .matrixSize(rows: 14, columns: 24)
                        .colorPattern(.gay)
                        .frame(height: 120)
                }
                
                DemoCard(title: "Asexual") {
                    PixelMarqueeView("ACE")
                        .matrixSize(rows: 8, columns: 20)
                        .colorPattern(.asexual)
                        .frame(height: 80)
                }
                
                DemoCard(title: "Aromantic") {
                    PixelMarqueeView("ARO")
                        .matrixSize(rows: 10, columns: 20)
                        .colorPattern(.aromantic)
                        .frame(height: 100)
                }
                
                DemoCard(title: "Genderqueer") {
                    PixelMarqueeView("GQ")
                        .matrixSize(rows: 9, columns: 16)
                        .colorPattern(.genderqueer)
                        .frame(height: 90)
                }
                
                DemoCard(title: "Genderfluid") {
                    PixelMarqueeView("FLUID")
                        .matrixSize(rows: 10, columns: 32)
                        .colorPattern(.genderfluid)
                        .frame(height: 100)
                }
                
                DemoCard(title: "Progress Pride") {
                    PixelMarqueeView("LOVE IS LOVE")
                        .matrixSize(rows: 11, columns: 64)
                        .colorPattern(.progress)
                        .scrolling(.left(speed: 30))
                        .frame(height: 110)
                }
            }
            .padding()
        }
        .navigationTitle("Pride Flags")
        .background(Color.black.opacity(0.95))
    }
}

// MARK: - Playground

struct PlaygroundView: View {
    @State private var text = "HELLO WORLD"
    @State private var rows = 8
    @State private var columns = 32
    
    // Color mode
    @State private var colorMode: ColorMode = .solid
    @State private var selectedSolidColor = LEDColor.red
    @State private var selectedPrideFlag: PrideFlag = .transgender
    
    // Effects
    @State private var effectType: EffectType = .scroll
    @State private var scrollDirection: ScrollDir = .left
    @State private var scrollSpeed: Double = 30
    @State private var blinkInterval: Double = 0.5
    @State private var isPaused = false
    
    // LED Style
    @State private var ledDiameter: Double = 0.7
    @State private var unlitBrightness: Double = 0.15
    
    enum ColorMode: String, CaseIterable {
        case solid = "Solid"
        case pride = "Pride 🏳️‍🌈"
    }
    
    enum PrideFlag: String, CaseIterable {
        case transgender = "🏳️‍⚧️ Trans"
        case rainbow = "🏳️‍🌈 Rainbow"
        case bisexual = "Bi"
        case pansexual = "Pan"
        case nonbinary = "Non-Binary"
        case lesbian = "Lesbian"
        case gay = "Gay"
        case asexual = "Ace"
        case aromantic = "Aro"
        case genderqueer = "Genderqueer"
        case genderfluid = "Genderfluid"
        case progress = "Progress"
        
        var pattern: ColorPattern {
            switch self {
            case .transgender: return .transgender
            case .rainbow: return .rainbow
            case .bisexual: return .bisexual
            case .pansexual: return .pansexual
            case .nonbinary: return .nonbinary
            case .lesbian: return .lesbian
            case .gay: return .gay
            case .asexual: return .asexual
            case .aromantic: return .aromantic
            case .genderqueer: return .genderqueer
            case .genderfluid: return .genderfluid
            case .progress: return .progress
            }
        }
    }
    
    enum EffectType: String, CaseIterable {
        case none = "Static"
        case scroll = "Scroll"
        case blink = "Blink"
    }
    
    enum ScrollDir: String, CaseIterable {
        case left = "← Left"
        case right = "→ Right"
        case up = "↑ Up"
        case down = "↓ Down"
        
        var config: ScrollConfiguration {
            switch self {
            case .left: return .left(speed: 30)
            case .right: return .right(speed: 30)
            case .up: return .up(speed: 30)
            case .down: return .down(speed: 30)
            }
        }
        
        func config(speed: Double) -> ScrollConfiguration {
            switch self {
            case .left: return .left(speed: speed)
            case .right: return .right(speed: speed)
            case .up: return .up(speed: speed)
            case .down: return .down(speed: speed)
            }
        }
    }
    
    let solidColorOptions: [(String, LEDColor)] = [
        ("Red", .red),
        ("Green", .green),
        ("Amber", .amber),
        ("Blue", .blue),
        ("Cyan", .cyan),
        ("Magenta", .magenta),
        ("White", .white)
    ]
    
    var currentColorPattern: ColorPattern {
        switch colorMode {
        case .solid:
            return .solid(selectedSolidColor)
        case .pride:
            return selectedPrideFlag.pattern
        }
    }
    
    var currentEffect: MarqueeEffect {
        switch effectType {
        case .none:
            return .none
        case .scroll:
            return .scrolling(scrollDirection.config(speed: scrollSpeed))
        case .blink:
            return .blink(interval: blinkInterval)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Preview
            ZStack {
                Color.black
                PixelMarqueeView(text)
                    .matrixSize(rows: rows, columns: columns)
                    .colorPattern(currentColorPattern)
                    .effect(currentEffect)
                    .paused(isPaused)
                    .ledStyle(diameter: ledDiameter, spacing: 1)
                    .unlitBrightness(unlitBrightness)
                    .padding()
            }
            .frame(height: 160)
            
            // Controls
            Form {
                Section("Text") {
                    TextField("Display Text", text: $text)
                }
                
                Section("Matrix Size") {
                    Stepper("Rows: \(rows)", value: $rows, in: 4...32)
                    Stepper("Columns: \(columns)", value: $columns, in: 8...128)
                }
                
                Section("Color Mode") {
                    Picker("Mode", selection: $colorMode) {
                        ForEach(ColorMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if colorMode == .solid {
                        Picker("Color", selection: $selectedSolidColor) {
                            ForEach(solidColorOptions, id: \.1) { name, color in
                                Text(name).tag(color)
                            }
                        }
                        .pickerStyle(.segmented)
                    } else {
                        Picker("Flag", selection: $selectedPrideFlag) {
                            ForEach(PrideFlag.allCases, id: \.self) { flag in
                                Text(flag.rawValue).tag(flag)
                            }
                        }
                    }
                }
                
                Section("Effect") {
                    Picker("Type", selection: $effectType) {
                        ForEach(EffectType.allCases, id: \.self) { effect in
                            Text(effect.rawValue).tag(effect)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if effectType == .scroll {
                        Picker("Direction", selection: $scrollDirection) {
                            ForEach(ScrollDir.allCases, id: \.self) { dir in
                                Text(dir.rawValue).tag(dir)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        HStack {
                            Text("Speed: \(Int(scrollSpeed))")
                                .frame(width: 80, alignment: .leading)
                            Slider(value: $scrollSpeed, in: 5...120)
                        }
                        
                        Toggle("Paused", isOn: $isPaused)
                    }
                    
                    if effectType == .blink {
                        HStack {
                            Text("Interval: \(String(format: "%.1fs", blinkInterval))")
                                .frame(width: 100, alignment: .leading)
                            Slider(value: $blinkInterval, in: 0.1...2.0)
                        }
                    }
                }
                
                Section("LED Style") {
                    HStack {
                        Text("Size: \(Int(ledDiameter * 100))%")
                            .frame(width: 80, alignment: .leading)
                        Slider(value: $ledDiameter, in: 0.3...1.0)
                    }
                    
                    HStack {
                        Text("Unlit: \(Int(unlitBrightness * 100))%")
                            .frame(width: 80, alignment: .leading)
                        Slider(value: $unlitBrightness, in: 0.0...0.5)
                    }
                }
                
                Section {
                    Button("Reset to Defaults") {
                        withAnimation {
                            text = "HELLO WORLD"
                            rows = 8
                            columns = 32
                            colorMode = .solid
                            selectedSolidColor = .red
                            selectedPrideFlag = .transgender
                            effectType = .scroll
                            scrollDirection = .left
                            scrollSpeed = 30
                            blinkInterval = 0.5
                            isPaused = false
                            ledDiameter = 0.7
                            unlitBrightness = 0.15
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Playground")
    }
}

// MARK: - Custom Font Demo

struct CustomFontDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                DemoCard(title: "Full ASCII Support") {
                    PixelMarqueeView("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
                        .matrixSize(rows: 8, columns: 64)
                        .ledColor(.green)
                        .scrolling(.left(speed: 20))
                        .frame(height: 80)
                }
                
                DemoCard(title: "Lowercase") {
                    PixelMarqueeView("abcdefghijklmnopqrstuvwxyz")
                        .matrixSize(rows: 8, columns: 64)
                        .ledColor(.amber)
                        .scrolling(.left(speed: 20))
                        .frame(height: 80)
                }
                
                DemoCard(title: "Numbers") {
                    PixelMarqueeView("0123456789")
                        .matrixSize(rows: 8, columns: 48)
                        .ledColor(.cyan)
                        .frame(height: 80)
                }
                
                DemoCard(title: "Punctuation & Symbols") {
                    PixelMarqueeView("!@#$%^&*()-=+[]{}|;:',.<>?/~`")
                        .matrixSize(rows: 8, columns: 64)
                        .ledColor(.magenta)
                        .scrolling(.left(speed: 15))
                        .frame(height: 80)
                }
                
                DemoCard(title: "Mixed Content") {
                    PixelMarqueeView("Hello, World! 123 @#$")
                        .matrixSize(rows: 8, columns: 48)
                        .ledColor(.red)
                        .scrolling(.left(speed: 25))
                        .frame(height: 80)
                }
            }
            .padding()
        }
        .navigationTitle("Font Demo")
        .background(Color.black.opacity(0.9))
    }
}

// MARK: - Helper Views

struct DemoCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            content()
                .background(Color.black)
                .cornerRadius(8)
        }
    }
}

#Preview {
    ContentView()
}
