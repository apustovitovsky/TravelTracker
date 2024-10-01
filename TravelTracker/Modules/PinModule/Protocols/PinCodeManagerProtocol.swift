import Foundation


enum PinCodeManagerResult {
    case success
    case failure
}

protocol PinCodeManagerProtocol: AnyObject {
    var prompt: String { get }
    func setPin(_ pin: String, completion: @escaping (PinCodeManagerResult) -> Void)
}

