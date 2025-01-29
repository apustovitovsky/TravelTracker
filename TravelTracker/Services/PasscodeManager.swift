//
//  Created by Алексей on 04.10.2024.
//

import Foundation


protocol PasscodeManagerProtocol: AnyObject {
    func validate(with: String, _: @escaping Handler<Bool>)
    func isPinStored() -> Bool
}


final class PasscodeManager: PasscodeManagerProtocol {

    static let shared = PasscodeManager()
    
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
    
    func validate(with passcode: String, _ completion: @escaping Handler<Bool>) {

        if let storedPasscode = keychainService.load(key: "PIN") {
            isLoggedIn = passcode == storedPasscode
        } else {
            isLoggedIn = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
            completion(self?.isLoggedIn ?? false)
        }

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

