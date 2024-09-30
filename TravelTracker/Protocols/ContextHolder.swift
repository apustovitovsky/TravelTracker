//
//  Created by Алексей on 22.09.2024.
//

import UIKit
import RouteComposer

// MARK: - A protocol for a ViewController that checks for context matching.

protocol ContextHolder: ContextChecking {
    
    // The type of context used for checking. Must conform to `Equatable`.
    associatedtype C: Equatable
    
    // The current context the view controller is working with.
    var context: C { get }
}

// MARK: - Extension for a ContextCheckingViewController that checks for context matching.

extension ContextHolder {
    
    // Method to check if the given context matches the current one.
    func isTarget(for context: C) -> Bool {
        self.context == context
    }
}


