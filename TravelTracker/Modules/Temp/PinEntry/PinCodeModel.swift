//
//  Created by Алексей on 23.09.2024.
//

import Foundation
import UIKit

//MARK: - PinCodeModel

struct PinCodeModel {
    
    var promptLabel: PromptLabel
    var indicatorView: IndicatorView
    var keypadView: KeypadView
    
    
    struct PromptLabel {
        var text: String?
    }

    struct IndicatorView {
        
        enum State {
            case setupPin
            case clearPin
            case wrongPin
        }
        
        var state: State?
        var onAnimationComplete: ((State) -> Void)?
        var pinCode: [Int] = []
        var previousPinCode: [Int] = []
        let pinCodeLength: Int = 4
    }
    
    struct KeypadView {
        
        enum State {
            case normal
            case disabled
        }
        
        enum ActionType {
            case append(Int)
            case removeLast
            case cancelFlow
        }
        
        struct Button {
            var state: State = .normal
            var action: ActionType?
            let title: String
        }
        
        var state: State = .normal
        var buttons: [Button]
        var handler: Handler<ActionType>?
    }
}

// MARK: - PinCodeFlowResult

struct PinCodeFlowResult {
    
    enum ActionType {
        case clearPin
        case wrongPin
        case completeFlow
    }
    
    let actionType: ActionType
    let prompt: String?
    
    init(actionType: ActionType = .clearPin, prompt: String? = nil) {
        self.actionType = actionType
        self.prompt = prompt
    }
}
