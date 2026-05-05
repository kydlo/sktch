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
}
