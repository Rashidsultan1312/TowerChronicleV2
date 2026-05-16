import SwiftUI

struct WatchtowerLaunchScaffold<Surface: View>: View {
    @AppStorage("tc.spire.consentSealed") private var sealed = false
    @State private var stage: Stage = .idle
    @State private var promptShown = false
    @ViewBuilder var surface: () -> Surface

    var body: some View {
        Group {
            if sealed {
                surface()
            } else {
                switch stage {
                case .idle:
                    ZStack {
                        AppColor.deepNavy.ignoresSafeArea()
                        ProgressView()
                            .tint(AppColor.jackpotYellow)
                            .scaleEffect(1.35)
                    }
                    .task { await soundOut() }
                case .redirected(let url):
                    TowerFrame(pageURL: url, ephemeral: false)
                        .ignoresSafeArea()
                case .promptGate:
                    ZStack {
                        AppColor.deepNavy.ignoresSafeArea()
                    }
                    .fullScreenCover(isPresented: $promptShown) {
                        SpireConsentPanel(pageURL: AppConfig.privacyPolicyURL) {
                            sealed = true
                            promptShown = false
                            stage = .free
                        }
                    }
                case .free:
                    surface()
                }
            }
        }
    }

    @MainActor
    private func soundOut() async {
        async let lull: Void = { try? await Task.sleep(nanoseconds: 1_600_000_000) }()
        async let reading = SpireLedger.soundOut()
        let outcome = await reading
        _ = await lull
        switch outcome {
        case .redirected(let url):
            stage = .redirected(url)
        case .calm:
            stage = .promptGate
            Task { @MainActor in
                promptShown = true
            }
        case .dim:
            stage = .free
        }
    }

    private enum Stage: Equatable {
        case idle
        case redirected(URL)
        case promptGate
        case free
    }
}
