import Foundation

struct Message: Codable, Identifiable {
    let id = UUID()
    let username: String
    let value: String
    let timestamp: String
    let languageCode: String
    let translatedLanguageCode: String
    let translatedValue: String

    var isFromLocalUser: Bool { username == User.local.name }
    var isTranslated: Bool { translatedValue.isEmpty == false }
}
