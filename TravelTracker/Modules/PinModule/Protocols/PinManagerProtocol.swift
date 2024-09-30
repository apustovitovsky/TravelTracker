import Foundation


enum PinManagerResult {
    case success
    case failure
}

protocol PinManagerProtocol: AnyObject {
    var prompt: String { get }
    func setPin(_ pin: String, completion: @escaping (PinManagerResult) -> Void)
}

