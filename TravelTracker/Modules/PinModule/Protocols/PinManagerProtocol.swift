//
//  Created by Алексей on 01.10.2024.
//

import Foundation

// MARK: - PinManagerProtocol

protocol PinManagerProtocol {
    func validate(pin: String, completion: @escaping (PinValidationResult) -> Void)
}

// MARK: - PinValidationResult

enum PinValidationResult {
    case success
    case failure
}

// MARK: - MockPinManager

final class DefaultPinManager: PinManagerProtocol {
    
    private let correctPin = "1234"
    
    func validate(pin: String, completion: @escaping (PinValidationResult) -> Void) {
        // Simulating a delay for network or validation process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if pin == self.correctPin {
                completion(.success)
            } else {
                completion(.failure)
            }
        }
    }
}

