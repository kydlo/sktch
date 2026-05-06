# SKTCH iOS 17 Rewrite — Session Summary

**Date:** 2026-05-04  
**Branch:** `feature/ios17-rewrite` (open PR against `master`)  
**PR URL:** https://github.com/kydlo/sktch/pull/new/feature/ios17-rewrite

---

## What We Started With

A fork of SKTCH — a generative art drawing app originally built in 2010–2011 on openFrameworks 0.070. The codebase was entirely incompatible with modern iOS:

- **Language:** Objective-C++ (`.mm` files) + C++ preset implementations
- **Graphics:** OpenGL ES (deprecated, unsupported on iOS 17)
- **Framework:** openFrameworks 0.070 with pre-built 32-bit static libraries (`armv6`, `armv7`)
- **Deployment target:** iOS 3.2
- **UI:** XIB-based UIKit, `UIAlertView` (removed in iOS 13), manual memory management
- The pre-built `.a` libraries couldn't be recompiled without the full openFrameworks build chain

The app had not been runnable on any device since iOS 10 (2016).

---

## What We Built

A complete ground-up Swift/SwiftUI rewrite targeting iOS 17+, preserving all 16 original generative drawing algorithms with a clean iOS-native interface.

### Design Decisions Made

| Question | Decision | Rationale |
|---|---|---|
| Visual direction | iOS Native (HIG-compliant) | Familiar, accessible, system controls |
| Preset organization | Categorized into 4 groups | Helps new users explore |
| Parameter controls | Bottom sheet | Clean canvas while drawing |
| Save/export | Photo library + share sheet | Covers real use cases without project management |
| Rendering tech | SwiftUI Canvas + TimelineView | No Metal expertise needed; all presets are vector/point-based |
| Algorithm porting | Full Swift rewrite | Simpler than C++ interop; algorithms are straightforward |

### Architecture

```
SKTCH/
├── App/SKTCHApp.swift              — @main, injects environment objects
├── Canvas/
│   ├── DrawingPoint.swift          — position, timestamp, force (value type)
│   ├── DrawingParameters.swift     — ObservableObject: scale, opacity, r, g, b
│   ├── CanvasViewModel.swift       — points array, stroke-boundary undo
│   ├── CanvasView.swift            — TimelineView + Canvas + overlay
│   └── TouchOverlay.swift          — UIViewRepresentable, low-latency touch
├── Presets/
│   ├── Preset.swift                — protocol: name, category, draw, resetState
│   ├── PresetCategory.swift        — enum: geometric, connected, organic, expressive
│   ├── PresetRegistry.swift        — all 16 instances
│   ├── Geometric/                  — Square, Circle, Triangle, Mesh
│   ├── Connected/                  — Network, SixPoints, Cross, Kiebitz
│   ├── Organic/                    — Spline, Orbit, Phase, Jocabola, Jocabola2
│   └── Expressive/                 — Andreas, Asendorf, Planes
├── UI/
│   ├── ContentView.swift           — NavigationStack, sheet bindings
│   ├── ToolbarView.swift           — scribble · presets · controls · trash
│   ├── PresetsView.swift           — grouped List, checkmark on active
│   └── ControlsSheet.swift         — sliders + 7 color swatches + RGB
└── Export/ExportHandler.swift      — ImageRenderer → UIActivityViewController
```

### The 16 Presets

Each preset is a `final class` conforming to `protocol Preset: AnyObject`. The `draw(points:params:in:size:)` method receives the full accumulated point array and renders into a SwiftUI `GraphicsContext` on every display refresh.

| Category | Presets | Notes |
|---|---|---|
| Geometric | Square, Circle, Triangle, Mesh | Triangle is stateful (drifting particles) |
| Connected | Network, SixPoints, Cross, Kiebitz | Kiebitz uses recursive fractal branching |
| Organic | Spline, Orbit, Phase, Jocabola, Jocabola2 | Spline + Jocabola2 are stateful |
| Expressive | Andreas, Asendorf, Planes | Andreas draws quote text along path |

All algorithms were ported directly from the original C++ source files in `openFrameworks/sktch_b2.083 iPhone/src/`. Color inversion (`255-r` in OpenGL) was mapped to `1-r` in the 0–1 Swift color space to maintain visual fidelity on a white canvas background.

### Key Technical Choices

- **Touch input:** `UIViewRepresentable` overlay using `UIGestureRecognizer` avoids the ~1-frame latency of SwiftUI's `DragGesture`. Multi-touch `endStroke` fires only when all active touches lift (not on first-finger-up).
- **Undo:** `CanvasViewModel` tracks `strokeBoundaries: [Int]` — indices into the points array where each stroke ends. Undo pops the last boundary and removes points since the previous one. Stateful presets call `resetState()` on undo/clear.
- **Export:** `ImageRenderer` renders `CanvasView` off-screen at `UIWindowScene.screen.scale`, presents `UIActivityViewController`. `UIScreen.main` (deprecated iOS 16+) avoided.
- **Project generation:** XcodeGen (`project.yml`) instead of a hand-crafted `.xcodeproj`. Clean, reproducible, DRY build settings.

---

## Testing

10 unit tests, all passing:

| Suite | Tests |
|---|---|
| `DrawingParametersTests` | Defaults, `n` computed property |
| `CanvasViewModelTests` | addPoint, clear, undo, initial preset |
| `PresetRegistryTests` | Count == 16, all 4 categories present, names unique |

---

## Artifacts

| Artifact | Path |
|---|---|
| Design spec | `docs/superpowers/specs/2026-05-04-sktch-ios17-design.md` |
| Implementation plan | `docs/superpowers/plans/2026-05-04-sktch-ios17.md` |
| Feature branch | `feature/ios17-rewrite` (16 commits) |
| Visual mockups | `.superpowers/brainstorm/` (brainstorming session) |

---

## What's Not Done

- **Snapshot tests** — the spec called for one per preset; not implemented. The visual algorithms are verified manually.
- **3D rotation mode** — the original had `xmanval`/`ymanval`/`zmanval` gyroscope-driven rotation; dropped (out of scope for this rewrite).
- **XML save/load** — the original saved preset+parameter state as XML; replaced by iOS share sheet (image export only).
- **iPad layout** — the original had a separate iPad project; this rewrite is iPhone-only (`TARGETED_DEVICE_FAMILY: "1"`).
