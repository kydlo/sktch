# SKTCH iOS 17 — Design Spec

## Context

SKTCH is a generative art drawing app originally built on openFrameworks 0.070 (circa 2011). It targets iOS 3.2 with 32-bit ARM architectures and OpenGL ES — none of which run on iOS 11+. The app's unique value is its 16 generative drawing algorithms (circles, meshes, networks, splines, etc.) driven by touch input. This spec describes a ground-up Swift rewrite that preserves all 16 algorithms and the original interaction model, while replacing everything else with a modern iOS 17 stack.

## Goals

- All 16 original presets reproduced in Swift with identical visual output
- iOS 17+ deployment target, arm64 only, no external dependencies
- iOS Native (HIG-compliant) aesthetic — system controls, SF Symbols, system colors
- Preset parameters (scale, opacity, R/G/B) adjustable via a bottom sheet
- Export drawing as image via share sheet or save to Photos
- No project file management — one canvas at a time

## Tech Stack

- **Language:** Swift 5.9+
- **UI:** SwiftUI
- **Rendering:** SwiftUI `Canvas` + `TimelineView`
- **Touch:** `UIViewRepresentable` overlay with `UIGestureRecognizer` (lower latency than `DragGesture`)
- **Export:** `ImageRenderer` → `UIImageWriteToSavedPhotosAlbum` / `ShareLink`
- **Minimum deployment:** iOS 17.0
- **Xcode:** 15+

## Project Structure

```
SKTCH/
├── App/
│   └── SKTCHApp.swift
├── Canvas/
│   ├── CanvasView.swift         # TimelineView + Canvas, touch overlay
│   ├── CanvasViewModel.swift    # drawing state, point accumulation
│   └── DrawingPoint.swift       # position, timestamp, pressure
├── Presets/
│   ├── Preset.swift             # protocol: name, category, draw(points:params:context:)
│   ├── PresetCategory.swift     # enum: geometric, connected, organic, expressive
│   ├── PresetRegistry.swift     # all 16 presets, ordered by category
│   ├── Geometric/
│   │   ├── SquarePreset.swift
│   │   ├── CirclePreset.swift
│   │   ├── TrianglePreset.swift
│   │   └── MeshPreset.swift
│   ├── Connected/
│   │   ├── NetworkPreset.swift
│   │   ├── SixPointsPreset.swift
│   │   ├── CrossPreset.swift
│   │   └── KiebitzPreset.swift
│   ├── Organic/
│   │   ├── SplinePreset.swift
│   │   ├── OrbitPreset.swift
│   │   ├── PhasePreset.swift
│   │   ├── JocabolaPreset.swift
│   │   └── Jocabola2Preset.swift
│   └── Expressive/
│       ├── AndreasPreset.swift
│       ├── AsendorfPreset.swift
│       └── PlanesPreset.swift
├── Parameters/
│   ├── DrawingParameters.swift  # scale, opacity, r, g, b — ObservableObject
│   └── ControlsSheet.swift      # SwiftUI bottom sheet with sliders + swatches
├── UI/
│   ├── ContentView.swift        # root layout: canvas + toolbar
│   ├── PresetsView.swift        # grouped List picker, sheet presentation
│   └── ToolbarView.swift        # bottom HStack: scribble · presets · controls · clear
└── Export/
    └── ExportHandler.swift      # off-screen render → photos / share sheet
```

## Preset Categories

| Category | Presets |
|---|---|
| Geometric | Square, Circle, Triangle, Mesh |
| Connected | Network, Six Points, Cross, Kiebitz |
| Organic | Spline, Orbit, Phase, Jocabola, Jocabola2 |
| Expressive | Andreas, Asendorf, Planes |

## Core Interfaces

```swift
protocol Preset {
    var name: String { get }
    var category: PresetCategory { get }
    func draw(points: [DrawingPoint], params: DrawingParameters, in context: GraphicsContext, size: CGSize)
}

struct DrawingPoint {
    let position: CGPoint
    let timestamp: TimeInterval
    let force: CGFloat  // 0–1, from UITouch.force (falls back to 1 on non-Force Touch)
}

class DrawingParameters: ObservableObject {
    @Published var scale: Double = 1.0      // 0.1–3.0
    @Published var opacity: Double = 1.0   // 0.0–1.0
    @Published var red: Double = 0.0
    @Published var green: Double = 0.5
    @Published var blue: Double = 1.0
}
```

## UI Layout

### Main Screen

- **Navigation bar:** Undo button (left) · "SKTCH" title (center) · Share button (right, SF: `square.and.arrow.up`)
- **Canvas:** Full-width white `Canvas` view filling available space, `TimelineView(.animation)` drives redraws
- **Bottom toolbar:** Four items — Draw (`scribble`), Presets (`square.grid.2x2`), Controls (`slider.horizontal.3`), Clear (`trash`)

### Preset Picker

Presented as a sheet (`.sheet` modifier). A `List` with section headers for each category. Active preset shows a checkmark. Tapping a row switches the preset and dismisses the sheet.

### Controls Sheet

Half-height `.sheet`. Header shows current preset name. Contains:
- Scale slider (0.1–3.0)
- Opacity slider (0–1)
- Color swatch row (7 quick-pick system colors)
- R / G / B sliders (0–1 each)

## Rendering Model

`CanvasViewModel` holds `@Published var points: [DrawingPoint]`. Touch events append to this array. On each `TimelineView` tick, `Canvas` calls `activePreset.draw(points:params:in:size:)` which redraws the full composition from the point array. This matches the original openFrameworks update loop.

Each preset translates point positions into geometric shapes using `GraphicsContext` primitives: `stroke`, `fill`, `Path`. No OpenGL, no Metal — pure 2D vector drawing.

## Touch Handling

A `UIViewRepresentable` transparent `UIView` sits on top of the canvas and forwards `UITouch` events to `CanvasViewModel`. This avoids the ~1-frame latency of SwiftUI's `DragGesture`. Multi-touch is supported (for presets that use multiple contact points).

## Export

Tapping Share in the navigation bar:
1. Renders the current canvas off-screen using `ImageRenderer` at screen resolution
2. Presents a standard iOS share sheet (`ShareLink`) with the rendered `UIImage`
3. User can save to Photos, AirDrop, Messages, etc. from there

Privacy key `NSPhotoLibraryAddUsageDescription` required in Info.plist.

## Error Handling

- Export failure (Photos permission denied): present a system alert directing to Settings
- No undo stack beyond a single undo (clear last stroke): one level is sufficient for the use case

## Testing

- **Unit:** Each preset's `draw` method can be tested by constructing a mock `GraphicsContext` or simply verifying it doesn't crash with various point arrays
- **Snapshot:** One snapshot test per preset renders a fixed set of points and compares against a reference image
- **Manual:** Golden path — draw with each preset, adjust all sliders, export via share sheet and to Photos
