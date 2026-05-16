import SwiftUI
@preconcurrency import WebKit

struct TowerFrame: UIViewRepresentable {
    let pageURL: URL
    var ephemeral: Bool = true

    func makeUIView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        cfg.allowsInlineMediaPlayback = true
        cfg.mediaTypesRequiringUserActionForPlayback = []
        cfg.websiteDataStore = ephemeral ? .nonPersistent() : .default()
        let panel = WKWebView(frame: .zero, configuration: cfg)
        panel.allowsBackForwardNavigationGestures = true
        panel.scrollView.bounces = true
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.scrollView.backgroundColor = .clear
        panel.load(URLRequest(url: pageURL))
        return panel
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
