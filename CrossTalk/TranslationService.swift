import Foundation
import Combine

struct TranslationService {
    private let apiKey = "trnsl.1.1.20200206T101358Z.0e7057b4a87791ed.1dcd4be721a9caa5962826afe11d9b23aaca6a3e"
    func publisher(for message: Message, to languageCode: String) -> AnyPublisher<Data, URLError> {
        URLSession.shared.dataTaskPublisher(for: url(for: message, to: languageCode))
            .map(\.data)
            .eraseToAnyPublisher()
    }

    private func url(for message: Message, to languageCode: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "translate.yandex.net"
        components.path = "/api/v1.5/tr.json/translate"
        components.setQueryItems(with: ["key": apiKey, "text": message.value, "lang": languageCode])
        return components.url!
    }
}
extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
