import Foundation
import UIKit
@preconcurrency import WebKit

enum BeaconReading: Equatable {
    case redirected(URL)
    case calm
    case dim
}

enum SpireLedger {
    @MainActor
    static func soundOut() async -> BeaconReading {
        await SpireScout().run()
    }

    static func compact(_ url: URL) -> String {
        guard var bits = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return url.absoluteString.lowercased()
        }
        bits.fragment = nil
        if let sc = bits.scheme { bits.scheme = sc.lowercased() }
        if let h = bits.host { bits.host = h.lowercased() }
        var p = bits.path
        while p.count > 1, p.hasSuffix("/") { p.removeLast() }
        bits.path = p
        return bits.url?.absoluteString ?? url.absoluteString.lowercased()
    }
}

@MainActor
final class SpireScout: NSObject, WKNavigationDelegate {
    private var pending: CheckedContinuation<BeaconReading, Never>?
    private var lookout: WKWebView?
    private var locked = false
    private var hourglass: Task<Void, Never>?

    func run() async -> BeaconReading {
        await withCheckedContinuation { cont in
            pending = cont
            let cfg = WKWebViewConfiguration()
            cfg.websiteDataStore = .nonPersistent()
            let glass = WKWebView(frame: CGRect(x: 0, y: 0, width: 6, height: 6), configuration: cfg)
            glass.alpha = 0.03
            glass.navigationDelegate = self
            glass.load(URLRequest(url: AppConfig.beaconAnchor))
            lookout = glass
            hourglass = Task { [weak self] in
                try? await Task.sleep(nanoseconds: 11_000_000_000)
                await MainActor.run { self?.finish(with: .dim) }
            }
        }
    }

    private func finish(with reading: BeaconReading) {
        if locked { return }
        locked = true
        hourglass?.cancel()
        lookout?.navigationDelegate = nil
        lookout?.stopLoading()
        lookout = nil
        pending?.resume(returning: reading)
        pending = nil
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let landed = webView.url else {
            finish(with: .dim)
            return
        }
        let anchor = AppConfig.beaconAnchor
        if SpireLedger.compact(anchor) == SpireLedger.compact(landed) {
            finish(with: .calm)
        } else {
            finish(with: .redirected(landed))
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        _ = error
        finish(with: .dim)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        _ = error
        finish(with: .dim)
    }
}
