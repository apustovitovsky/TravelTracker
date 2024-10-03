//
//  Created by Алексей on 01.10.2024.
//

import Foundation

// MARK: - PinManagerProtocol

protocol PinManagerProtocol {
    func isPinStored() -> Bool
    func checkPin(pin: String, completion: (PinManagerResult) -> Void)
    func storePin(pin: String)
}

// MARK: - PinValidationResult

enum PinManagerResult {
    case success
    case failure
}

// MARK: - MockPinManager

final class DefaultPinManager: PinManagerProtocol {
    private var storedPin: String?
    
    func isPinStored() -> Bool {
        return storedPin != .none
    }
    func checkPin(pin: String, completion: (PinManagerResult) -> Void) {
        completion(storedPin == pin ? .success : .failure)
    }
    func storePin(pin: String) {
        return storedPin = pin
    }
}

