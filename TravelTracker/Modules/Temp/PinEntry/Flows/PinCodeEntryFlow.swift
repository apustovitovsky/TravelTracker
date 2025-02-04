//
//  Created by Алексей on 08.10.2024.
//

import Foundation

// MARK: - PinCodeEntryFlow

final class PinCodeEntryFlow: PinCodeFlow {
    
    var completion: Handler<PinCodeFlowResult>?
    var handler: Handler<String>?

    func start() {
        self.handler = { [weak self] pinCode in
            self?.handlePinCheck(pinCode)
        }
    }
}

// MARK: - PinCodeEntryFlow Private Methods

private extension PinCodeEntryFlow {
    
    func handlePinCheck(_ pinCode: String) {
        PinCodeService.shared.authenticate(with: pinCode) { [weak self] isAuthenticated in
            guard isAuthenticated else {
                self?.completion?(.init(actionType: .wrongPin, prompt: "Wrong PIN"))
                return
            }
            self?.handler = nil
            self?.completion?(.init(actionType: .completeFlow))
        }
    }
}

