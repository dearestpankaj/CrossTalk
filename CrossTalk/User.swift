import UIKit

class User {
    static let local = User()
    let id = UUID()
    var name: String { UIDevice.current.name }

    private init() { }
}
