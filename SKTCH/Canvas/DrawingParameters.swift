import SwiftUI

final class DrawingParameters: ObservableObject {
    @Published var scale: Double = 1.0       // 0.1–3.0
    @Published var opacity: Double = 1.0     // 0.0–1.0
    @Published var red: Double = 0.0
    @Published var green: Double = 0.5
    @Published var blue: Double = 1.0

    var color: Color { Color(red: red, green: green, blue: blue, opacity: opacity) }
    var n: Double { scale * 10.0 }           // secondary scale, mirrors original `n` param
}
