import Foundation

struct SomePinModel {
    enum State {
        case enterPin
        case wrongPin
        case setupPin
        case resetPin
    }
    
    enum Result {
        case success
        case failure
    }
    
    var state: State
}

public protocol ContextTransformer {
    associatedtype SourceContext
    associatedtype TargetContext
    
    func transform(_ context: SourceContext) throws -> TargetContext
}

struct PinEntryToSetupTransformer: ContextTransformer {
    func transform(_ context: SomePinModel.Result) throws -> SomePinModel.State {
        return context == .success ? .setupPin : .wrongPin
    }
}

struct PinEntryToResetTransformer: ContextTransformer {
    func transform(_ context: SomePinModel.Result) throws -> SomePinModel.State {
        return context == .success ? .resetPin : .wrongPin
    }
}

public struct AnyContextTransformer<SourceContext, TargetContext>: ContextTransformer {
    
    private let _transform: (SourceContext) throws -> TargetContext
    
    public init<T: ContextTransformer>(_ transformer: T) where T.SourceContext == SourceContext, T.TargetContext == TargetContext {
        self._transform = transformer.transform
    }
    
    public func transform(_ context: SourceContext) throws -> TargetContext {
        return try _transform(context)
    }
}


struct PinEntryStep {
    var transformer: AnyContextTransformer<SomePinModel.Result, SomePinModel.State>
    
    init<T: ContextTransformer>(transformer: T) where T.SourceContext == SomePinModel.Result, T.TargetContext == SomePinModel.State {
        self.transformer = AnyContextTransformer(transformer)
    }
    
    func next(_ pin: String, completion: (SomePinModel.State) -> Void = { _ in }) throws {
        let result: SomePinModel.Result = (pin == "123") ? .success : .failure
        try completion(transformer.transform(result))
    }
}

// Пример использования
func ff() {
    let step1 = PinEntryStep(transformer: PinEntryToSetupTransformer())
    let step2 = PinEntryStep(transformer: PinEntryToResetTransformer())

    do {
        try step1.next("123") { context in
            print(context)  // Output: setupPin
        }
        
        try step2.next("456") { context in
            print(context)  // Output: wrongPin
        }
    } catch {
        print("Error: \(error)")
    }
}


