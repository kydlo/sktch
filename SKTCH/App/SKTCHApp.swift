import SwiftUI

@main
struct SKTCHApp: App {
    @StateObject private var viewModel = CanvasViewModel()
    @StateObject private var params = DrawingParameters()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(params)
        }
    }
}
