//
//  Created by Алексей on 04.10.2024.
//

import Foundation


final class PinCodeService {

    static let shared = PinCodeService()
    
    private let keychainService = KeychainService()
    private var isLoggedIn: Bool = false {
        didSet {
            print(isLoggedIn)
        }
    }
    private var inactiveEnterDate: Date?
    private let inactiveTimeout: TimeInterval = 5

    private init() {}
    
    func isPinStored() -> Bool {
        return keychainService.load(key: "PIN") != nil
    }
    
    func authRequired() -> Bool {
        return !isLoggedIn && isPinStored()
    }
    
    func authenticate(with pin: String, completion: (Bool) -> Void) {

        if let storedPin = keychainService.load(key: "PIN") {
            isLoggedIn = pin == storedPin
        } else {
            isLoggedIn = true
        }
        completion(isLoggedIn)
    }
    
    func storePin(pin: String) {
        keychainService.save(key: "PIN", value: pin)
    }
    
    func sceneWillEnterForeground() {
        guard isLoggedIn, let lastDate = inactiveEnterDate else {
            isLoggedIn = false
            return
        }
        if Date().timeIntervalSince(lastDate) > inactiveTimeout {
            isLoggedIn = false
        }
    }

    func sceneDidEnterBackground() {
        inactiveEnterDate = Date()
    }
}

