//
//  Created by Алексей on 08.10.2024.
//

import Foundation

// MARK: - PinSetupFlow

final class PinCodeSetupFlow: PinCodeFlow {

    private enum FlowStep {
        case checkPin
        case setupPin
    }
    
    var completion: Handler<PinCodeFlowResult>?
    var handler: Handler<String>?
    
    private var currentStep: FlowStep = .checkPin
    private var enteredPin: String?
    
    func start() {
        self.handler = { [weak self] pinCode in
            guard let currentStep = self?.currentStep else { return }
            
            switch currentStep {
            case .checkPin:
                self?.handlePinCheck(pinCode)
            case .setupPin:
                self?.handlePinSetup(pinCode)
            }
        }
        self.completion?(.init(prompt: "Enter PIN"))
    }
}

// MARK: - PinSetupFlow Private Methods

private extension PinCodeSetupFlow {
    
    func handlePinCheck(_ pinCode: String) {
        PinCodeService.shared.authenticate(with: pinCode) { isAuthenticated in
            guard isAuthenticated else {
                self.completion?(.init(actionType: .wrongPin, prompt: "Wrong PIN"))
                return
            }
            self.currentStep = .setupPin
            self.completion?(.init(prompt: "Setup PIN"))
        }
    }
    
    func handlePinSetup(_ pinCode: String) {
        guard let enteredPin = self.enteredPin else {
            self.enteredPin = pinCode
            self.completion?(.init(prompt: "Repeat PIN"))
            return
        }
        guard pinCode == enteredPin else {
            self.completion?(.init(prompt: "PIN missmatch"))
            return
        }
        PinCodeService.shared.storePin(pin: pinCode)
        self.handler = nil
        self.completion?(.init(actionType: .completeFlow))
        
    }
}
