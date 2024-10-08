//
//  Created by Алексей on 08.10.2024.
//

import Foundation

// MARK: - PinEntryFlow

final class PinEntryFlow: PinFlowProtocol {
    
    var handler: ((PinEntryModel.Result) -> Void)?
    private var enteredPin: String?
    
    func start() -> ((String) -> Void) {
        self.handler?(Result("Enter PIN"))
        
        return { [weak self] pinCode in
            self?.handlePinEntry(pinCode)
        }
    }
}

// MARK: - PinEntryFlow Private Methods

private extension PinEntryFlow {
    
    func handlePinEntry(_ pinCode: String) {
        PinCodeService.shared.authenticate(with: pinCode) { [weak self] isAuthenticated in
            if isAuthenticated {
                self?.handler?(Result("Success!", event: .completion))
            } else {
                self?.handler?(Result("Wrong PIN", event: .wrongPin))
            }
        }
    }
}

