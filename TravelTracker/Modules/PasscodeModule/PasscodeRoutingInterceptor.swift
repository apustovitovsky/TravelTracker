//
//  Created by Алексей on 30.01.2025.
//

import UIKit
import RouteComposer

var isLoggedIn: Bool = false

final class PasscodeRoutingInterceptor<Context>: RoutingInterceptor {

    typealias Context = Context
    
    func perform(with context: Context, completion: @escaping (RouteComposer.RoutingResult) -> Void) {
        guard !isLoggedIn else {
            completion(.success)
            return
        }
        
        try? DefaultRouter().navigate(to: AppConfiguration.passcodeScreen, with: nil) { routingResult in
            guard routingResult.isSuccessful,
                  let viewController = ClassFinder<PasscodeViewController, Any?>().getViewController() else {
                completion(.failure(RoutingError.compositionFailed(.init("LoginViewController was not found."))))
                return
            }
            viewController.presenter.completion = { validationResult in
                switch validationResult {
                case .success:
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

