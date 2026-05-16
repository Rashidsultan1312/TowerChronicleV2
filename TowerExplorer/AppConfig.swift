import Foundation

enum AppConfig {
    static let beaconAnchor = URL(string: "https://keitaro-zaglushka.com")!
    static let privacyPolicyURL = URL(string: "https://hallowtommy.github.io/tower-explorer-privacy")!
    static let supportEmail = "mykser9204@icloud.com"

    static var versionLine: String {
        let marketing = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "\(marketing) (build \(build))"
    }
}
