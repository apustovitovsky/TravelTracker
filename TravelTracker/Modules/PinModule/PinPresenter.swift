import Foundation


protocol PinModuleOutput: AnyObject {
    var completion: ((Result<Bool, Error>) -> Void)? { get set }
}


protocol PinPresenterProtocol {
    func viewDidLoad()
    func getPinLength() -> Int
    func addDigitToPin(digit: Int)
    func removeLastDigitFromPin()
}


final class PinPresenter: PinModuleOutput {
    
    weak var view: PinViewProtocol?
    var completion: ((Result<Bool, Error>) -> Void)?
    private let pinManager: PinCodeManagerProtocol
    private let pinLength = 6
    private var pinCode: [Int] = []
    
    init(pinManager: PinCodeManagerProtocol) {
        self.pinManager = pinManager
    }
}


extension PinPresenter: PinPresenterProtocol {
    
    func viewDidLoad() {
        view?.updatePinPrompt(with: pinManager.prompt)
    }
    
    func getPinLength() -> Int {
        pinLength
    }
    
    func addDigitToPin(digit: Int) {
        guard pinCode.count < pinLength else { return }
        pinCode.append(digit)
        
        if pinCode.count >= pinLength {
            pinManager.setPin(pinCode.map { String($0) }.joined()) { [weak self] _ in
                print("completed")
                self?.completion?(.success(true))
            }
            pinCode.removeAll()
        }
        
        view?.updatePinPrompt(with: pinManager.prompt)
        view?.updatePinCircles(count: pinCode.count)
    }
    
    func removeLastDigitFromPin() {
        guard !pinCode.isEmpty else { return }
        pinCode.removeLast()
        view?.updatePinCircles(count: pinCode.count)
    }
}


