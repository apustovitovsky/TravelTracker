//
//  Created by Алексей on 23.09.2024.
//

import Foundation
import UIKit

//MARK: - PinEntryModel

struct PinEntryModel {
    
    enum EventType {
        case none
        case completion
        case wrongPin
    }
    
    struct Result {
        let title: String?
        let event: EventType
        
        init(_ title: String? = .none, event: EventType = .none) {
            self.title = title
            self.event = event
        }
    }
    
    var enteredDigits: [Int] = [] {
        willSet {
            indicatorView.pinLengthFrom = enteredDigits.count
        }
        didSet {
            indicatorView.pinLengthTo = enteredDigits.count
        }
    }

    var title: String?
    let requiredPinLength: Int
    var keypadView: KeypadView
    var indicatorView: IndicatorView
}

//MARK: - IndicatorView

extension PinEntryModel {
    
    struct IndicatorView {
        var pinLengthFrom: Int = 0
        var pinLengthTo: Int = 0
    }
}

//MARK: - KeypadView

extension PinEntryModel {
    
    enum KeypadAction {
        case add(Int)
        case removeLast
    }
    
    struct Button {
        let title: String
        var image: UIImage?
        var action: KeypadAction?
        var isEnabled: Bool = true
    }
    
    struct KeypadView {
        var buttons: [Button]
        var handler: Handler<KeypadAction>?
        var isEnabled: Bool = true
    }
}
