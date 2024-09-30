import UIKit
import RouteComposer

struct HomeContextTransformer: ContextTransformer {

    // MARK: Associated types

    /// Type of source context
    typealias SourceContext = PinEntryModel

    /// Type of target context
    typealias TargetContext = ScreenDefinition

    // MARK: Methods to implement

    func transform(_ context: SourceContext) throws -> TargetContext {
        return .home
    }

}

struct NilContextTransformer<Context>: ContextTransformer {
    func transform(_ context: Context) throws -> Context {
        return context
    }
}


// MARK: - ApplicationConfiguration

enum ApplicationConfiguration {

    static let tabBarScreen = StepAssembly(
        finder: NilFinder(),
        factory: CompleteFactoryAssembly(
            factory: TabBarControllerFactory()
        )
        .with(home)
        .with(profile)
        .with(settings, adapting: InlineContextTransformer{ _ in })
        .assemble()
    )
    .using(GeneralAction.replaceRoot())
    .from(GeneralStep.root())
    .assemble()


    private static let home = CompleteFactoryAssembly(
        factory: NavigationControllerFactory { navController in
            navController.tabBarItem.title = "Home"
            navController.tabBarItem.image = .init(systemName: "bitcoinsign.circle")
        }
    )
    .with(PinEntryFactory())
    .assemble()
    
    private static let profile = CompleteFactoryAssembly(
        factory: NavigationControllerFactory { navController in
            navController.tabBarItem.title = "Profile"
            navController.tabBarItem.image = .init(systemName: "person")
        }
    )
    .with(PinEntryFactory())
    .assemble()
    
    private static let settings = CompleteFactoryAssembly(
        factory: NavigationControllerFactory { navController in
            navController.tabBarItem.title = "Settings"
            navController.tabBarItem.image = .init(systemName: "gear")
        }
    )
    .with(PinFactory())
    .assemble()
    
    static var stepToHome = StepAssembly(
        finder: ClassFinder<PinEntryViewController, PinEntryModel>(),
        factory: NilFactory())
        .from(tabBarScreen)
        .assemble()
}

