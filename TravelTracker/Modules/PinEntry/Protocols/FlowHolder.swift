//
//  Created by Алексей on 09.10.2024.
//

// MARK: - Flow

protocol Flow: AnyObject {
    associatedtype Context
    
    var completion: Handler<Context>? { get set }
    func start() -> Handler<String>
}

// MARK: - FlowHolder

protocol FlowHolder {
    associatedtype F: Flow
    
    var flow: F { get set }
}
