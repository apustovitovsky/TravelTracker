//
//  Created by Алексей on 08.10.2024.
//

import Foundation

// MARK: - PinEntryFlow

final class PinCodeEntryFlow: Flow {

    var completion: Handler<PinCodeFlowResult>?
    
    func start() -> ((String) -> Void) {
        self.completion?(.init(prompt: "Enter PIN"))
        
        return { [weak self] pinCode in
            self?.handlePinCheck(pinCode)
        }
    }
}

// MARK: - PinEntryFlow Private Methods

private extension PinCodeEntryFlow {
    
    func handlePinCheck(_ pinCode: String) {
        PinCodeService.shared.authenticate(with: pinCode) { [weak self] isAuthenticated in
            if isAuthenticated {
                self?.completion?(.init(resultType: .flowCompleted))
            } else {
                self?.completion?(.init(resultType: .wrongPin, prompt: "Wrong PIN"))
            }
        }
    }
}

