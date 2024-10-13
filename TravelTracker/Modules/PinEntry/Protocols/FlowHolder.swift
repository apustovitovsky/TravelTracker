//
//  Created by Алексей on 09.10.2024.
//

// MARK: - Flow

protocol Flow: AnyObject {
    associatedtype Context
    
    var completion: Handler<Context>? { get set }
    func start()
}

// MARK: - PinCodeFlow

protocol PinCodeFlow: Flow {
    var handler: Handler<String>? { get set }
}




