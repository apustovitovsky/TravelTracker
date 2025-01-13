//
//  Created by Алексей on 17.11.2024.
//

protocol Coordinator: AnyObject {
    
    associatedtype T
    
    var completion: Handler<T>? { get set }
    
    func start()
}
