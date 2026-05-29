import SwiftUI

@main
struct iOSApp: App {
    init() {
        IosApplicationBootstrapKt.launchOnApplicationStart()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()

        }
    }
}
