//
//  Created by Алексей on 04.10.2024.
//

import Foundation


final class PinCodeService {

    static let shared = PinCodeService()
    
    private let keychainService = KeychainService()
    private var isLoggedIn: Bool = false
    private var inactiveEnterDate: Date?
    private let inactiveTimeout: TimeInterval = 5

    private init() {}
    
    func isPinStored() -> Bool {
        return keychainService.load(key: "PIN") != nil
    }
    
    func authRequired() -> Bool {
        return !isLoggedIn && isPinStored()
    }
    
    func authenticate(with pin: String, completion: @escaping (Bool) -> Void) {

        if let storedPin = keychainService.load(key: "PIN") {
            isLoggedIn = pin == storedPin
        } else {
            isLoggedIn = true
        }
        //DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...2.5)) { [weak self] in
            completion(self.isLoggedIn)
        //}

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

