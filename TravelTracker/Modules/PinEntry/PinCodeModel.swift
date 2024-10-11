//
//  Created by Алексей on 23.09.2024.
//

import Foundation
import UIKit

//MARK: - PinCodeModel/

struct PinCodeModel {
    
    var promptLabel: String?
    var keypadView: KeypadView
    var indicatorView: IndicatorView
    
    struct IndicatorView {
        
        enum State {
            case normal
            case processingPin
            case wrongPin
        }
        
        var state: IndicatorView.State = .normal {
            didSet {
                print(state)
            }
        }
        var pinCode: [Int] = []
        var previousPinCode: [Int] = []
        let pinCodeLength: Int = 4
    }
    
    struct KeypadView {
        
        enum Action {
            case append(Int)
            case removeLast
            case cancelFlow
        }
        
        struct Button {
            var action: KeypadView.Action?
            let title: String
            var image: UIImage?
            var isEnabled: Bool = true
        }
        
        var buttons: [KeypadView.Button]
        var handler: Handler<KeypadView.Action>?
        var isEnabled: Bool = true
    }
}

// MARK: - PinCodeFlowResult

struct PinCodeFlowResult {
    
    enum ResultType {
        case wrongPin
        case flowCompleted
    }
    
    let prompt: String?
    let resultType: ResultType?
    
    init(resultType: ResultType? = nil, prompt: String? = nil) {
        self.resultType = resultType
        self.prompt = prompt
    }
}
