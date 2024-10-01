import Foundation


final class PinCodeCreationManager: PinCodeManagerProtocol {

    private enum Status: String {
        case createPin = "Create PIN"
        case repeatPin = "Repeat PIN"
        case pinMismatch = "PIN missmatch"
    }
    
    private var keychainManager: KeychainManagerProtocol
    private var status: Status = .createPin
    
    var prompt: String {
        status.rawValue
    }
    
    private var storedPin: String?
    
    init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }
    
    func setPin(_ pin: String, completion: (PinCodeManagerResult) -> Void) {
        switch status {
        case .createPin:
            status = .repeatPin
            storedPin = pin
        case .repeatPin, .pinMismatch:
            if storedPin == pin {
                keychainManager.save(key: "PIN", value: pin)
                completion(.success)
            } else {
                status = .pinMismatch
            }
        }
    }
}


