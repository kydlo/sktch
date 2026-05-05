import SwiftUI

protocol Preset: AnyObject {
    var name: String { get }
    var category: PresetCategory { get }
    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize)
    func resetState()
}
