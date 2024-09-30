//
//  Created by Алексей on 23.09.2024.
//

import Foundation
import UIKit

//MARK: - HomeModel

struct PinEntryModel {
    
    enum State {
        case normal
        case reloading
    }
    
    var state: State = .normal
    var title: String?
    var enteredPinDigits: [Int] = []
    var previousPinDigits: [Int] = []
    let requiredPinLength: Int
    var buttons: [Button] = []
    var handler: Handler<Action>?
}

extension PinEntryModel {
    
    enum Action {
        case add(Int)
        case removeLast
    }
    
    struct Button {
        var state: UIControl.State = .normal
        let title: String
        var actionType: Action?
    }
    
    struct KeypadView {
        var buttons: [Button] = []
        var handler: Handler<Action>?
    }
}
