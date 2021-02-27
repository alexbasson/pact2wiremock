import Foundation

class Config {
    static var baseUrl: String {
        return infoPlist?["API_BASE_URL"] as? String ?? ""
    }

    private static var infoPlist: NSDictionary? {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
        return NSDictionary(contentsOfFile: path)
    }
}
