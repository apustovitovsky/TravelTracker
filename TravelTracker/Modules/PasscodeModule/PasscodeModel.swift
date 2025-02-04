//
//  Created by Алексей on 16.11.2024.
//

import Foundation

public enum PasscodeValidationResult {
    
    case success
    case failure(Error)
}

public extension PasscodeValidationResult {
    
    var isSuccessful: Bool {
        if case .success = self { true } else { false }
    }
}

struct PasscodeModel {
    
    enum State: String {
        case normal
        case pending
        case failure
    }
    
    var state: State = .normal
    var title: String?
    var progressIndicator: ProgressIndicator
    var handlers = Handlers()
    var passcode: [Int] = []
    let passcodeLength: Int
    var remainingAttempts: Int = 1


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
        
        enum indicatorState {
            case filled
            case toFill
            case empty
            case toClear
        }
        
        var state: State = .normal
        var indicatorStates: [indicatorState]
        
        init(_ length: Int) {
            self.indicatorStates = Array(repeating: .empty, count: length)
        }
        
        mutating func updateIndicatorStates(with value: Int) {
            self.indicatorStates = indicatorStates.enumerated().map{ index, state in
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
    }
}
