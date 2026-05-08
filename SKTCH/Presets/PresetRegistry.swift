import Foundation

enum PresetRegistry {
    static let all: [Preset] = [
        // Geometric (4)
        SquarePreset(),
        CirclePreset(),
        TrianglePreset(),
        MeshPreset(),
        // Connected (4)
        NetworkPreset(),
        SixPointsPreset(),
        CrossPreset(),
        KiebitzPreset(),
        // Organic (5)
        SplinePreset(),
        OrbitPreset(),
        PhasePreset(),
        JocabolaPreset(),
        Jocabola2Preset(),
        // Expressive (3)
        AndreasPreset(),
        AsendorfPreset(),
        PlanesPreset(),
    ]

    static func makeFresh(like preset: any Preset) -> any Preset {
        switch preset {
        case is SquarePreset:    return SquarePreset()
        case is CirclePreset:    return CirclePreset()
        case is TrianglePreset:  return TrianglePreset()
        case is MeshPreset:      return MeshPreset()
        case is NetworkPreset:   return NetworkPreset()
        case is SixPointsPreset: return SixPointsPreset()
        case is CrossPreset:     return CrossPreset()
        case is KiebitzPreset:   return KiebitzPreset()
        case is SplinePreset:    return SplinePreset()
        case is OrbitPreset:     return OrbitPreset()
        case is PhasePreset:     return PhasePreset()
        case is JocabolaPreset:  return JocabolaPreset()
        case is Jocabola2Preset: return Jocabola2Preset()
        case is AndreasPreset:   return AndreasPreset()
        case is AsendorfPreset:  return AsendorfPreset()
        case is PlanesPreset:    return PlanesPreset()
        default: fatalError("Unknown preset type: \(type(of: preset))")
        }
    }
}
