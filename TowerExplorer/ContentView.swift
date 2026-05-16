import SwiftUI

struct ContentView: View {
    @AppStorage("app.tower.onboarded") private var didCompleteIntro: Bool = false

    var body: some View {
        WatchtowerLaunchScaffold {
            switch didCompleteIntro {
            case true:  RootTabView()
            case false: OnboardingView(didCompleteIntro: $didCompleteIntro)
            }
        }
    }
}
