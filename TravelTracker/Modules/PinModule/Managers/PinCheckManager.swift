import Foundation


final class PinCheckManager: PinManagerProtocol {

    private enum Status: String {
        case enterPincode = "Enter PIN"
        case wrongPincode = "Wrong PIN"
    }
    
    private var keychainManager: KeychainManagerProtocol
    private var status: Status = .enterPincode
    
    var prompt: String {
        status.rawValue
    }
    
    init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }
    
    func setPin(_ pin: String, completion: @escaping (PinManagerResult) -> Void) {
        let result = keychainManager.load(key: "PIN")

        switch result {
        case .success(let storedPin):
            if pin == storedPin {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    completion(.success)
                }
            } else {
                status = .wrongPincode
            }
        default:
            completion(.failure)
        }
    }
}
