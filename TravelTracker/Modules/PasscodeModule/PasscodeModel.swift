//
//  Created by Алексей on 16.11.2024.
//

import UIKit

//MARK: - PasscodeEntryModel

struct PasscodeModel {
    
    enum State: String {
        case normal
        case loading
        case failure
    }
    
    var state: State = .normal
    var title: String?
    var progressIndicator: ProgressIndicator
    var handlers = Handlers()
    var passcode: [Int] = []
    let passcodeLength: Int
    var remainingAttempts: Int = 5


    var canAddDigit: Bool {
        passcode.count < passcodeLength
    }
    var canRemoveDigit: Bool {
        !passcode.isEmpty
    }
    
    init(length: Int) {
        self.progressIndicator = ProgressIndicator(length)
        self.passcodeLength = length
    }
}

//MARK: - PasscodeEntryModel Extension

extension PasscodeModel {
    
    struct ProgressIndicator {
        
        enum State: String {
            case normal
            case failure
        }
        
        enum CircleState {
            case filled
            case toFill
            case empty
            case toClear
        }
        
        var state: State = .normal
        var circleStates: [CircleState]
        
        init(_ length: Int) {
            self.circleStates = Array(repeating: .empty, count: length)
        }
        
        mutating func updateProgress(with value: Int) {
            self.circleStates = circleStates.enumerated().map{ index, state in
                return index < value
                    ? (state == .toFill || state == .filled) ? .filled : .toFill
                    : (state == .toClear || state == .empty) ? .empty : .toClear
            }
        }
    }
    
    struct Handlers {
        var digitTap: Handler<Int>?
        var backspaceTap: Action?
        var cancelTap: Action?
        var resetInput: Action?
    }
}
