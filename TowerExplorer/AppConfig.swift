import Foundation

enum AppConfig {
    static let beaconAnchor = URL(string: "https://neltroxi.com/wLyNfH")!
    static let privacyPolicyURL = URL(string: "https://www.termsfeed.com/live/d0d4365b-44d4-4b6b-acf2-a1cc09dead68")!
    static let supportEmail = "rentrinas@icloud.com"

    static var versionLine: String {
        let marketing = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "\(marketing) (build \(build))"
    }
}
