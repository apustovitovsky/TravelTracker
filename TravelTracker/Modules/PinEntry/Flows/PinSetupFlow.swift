//
//  Created by Алексей on 08.10.2024.
//

import Foundation

// MARK: - PinSetupFlow

final class PinSetupFlow: PinFlowProtocol {
    
    private enum FlowStep {
        case enterPin
        case setupPin
    }
    
    private var currentStep: FlowStep = .enterPin
    
    var handler: Handler<PinEntryModel.Result>?
    private var enteredPin: String?
    
    func start() -> Handler<String> {
        self.handler?(Result("Enter PIN"))
        
        return { [weak self] pinCode in
            switch self?.currentStep {
            case .enterPin:
                self?.handlePinEntry(pinCode)
            case .setupPin:
                self?.handlePinSetup(pinCode)
            default:
                return
            }
        }
    }
}

// MARK: - PinSetupFlow Private Methods

private extension PinSetupFlow {
    
    func handlePinEntry(_ pinCode: String) {
        PinCodeService.shared.authenticate(with: pinCode) { isAuthenticated in
            guard isAuthenticated else {
                self.handler?(Result("Wrong PIN", event: .wrongPin))
                return
            }
            self.currentStep = .setupPin
            self.handler?(Result("Setup PIN"))
        }
    }
    
    func handlePinSetup(_ pinCode: String) {
        guard let enteredPin = self.enteredPin else {
            self.enteredPin = pinCode
            self.handler?(Result("Repeat PIN"))
            return
        }
        if pinCode == enteredPin {
            PinCodeService.shared.storePin(pin: pinCode)
            self.currentStep = .enterPin
            self.enteredPin = .none
            self.handler?(Result("PIN Stored", event: .completion))
        } else {
            self.handler?(Result("PIN missmatch"))
        }
    }
}
