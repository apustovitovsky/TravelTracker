//
//  Created by Алексей on 08.10.2024.
//

import Foundation


// MARK: - PinSetupFlowProtocol

protocol PinFlowProtocol: AnyObject {
    associatedtype Result
    
    var handler: Handler<Result>? { get set }
    // TODO: Implement completion + handler
    /// var completion: Action? { get set }
    func start() -> Handler<String>
}
