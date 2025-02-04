//
//  Created by Алексей on 29.01.2025.
//

import RouteComposer

enum AppConfiguration {
    
    static var profileScreen: DestinationStep<ProfileViewController, Any?> {
        StepAssembly(
            finder: ClassFinder<ProfileViewController, Any?>(),
            factory: ProfileModuleFactory())
            .adding(PasscodeRoutingInterceptor<Any?>())
        
        .using(GeneralAction.replaceRoot())
        .from(GeneralStep.root())
        .assemble()
    }
    
    static var passcodeScreen: DestinationStep<PasscodeViewController, Any?> {
        StepAssembly(
            finder: ClassFinder<PasscodeViewController, Any?>(),
            factory: PasscodeModuleFactory())
        
        .using(GeneralAction.presentModally())
        .from(GeneralStep.current())
        .assemble()
    }
}
