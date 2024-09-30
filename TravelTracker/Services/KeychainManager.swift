

import Foundation


protocol KeychainManagerProtocol: AnyObject {
    func save(key: String, value: String)
    func load(key: String) -> Result<String, Error>
}

final class KeychainManager: KeychainManagerProtocol {
    
    private var storage: [String: String] = ["PIN":"11111"]
    
    func save(key: String, value: String) {
        storage[key] = value
    }
    
    func load(key: String) -> Result<String, Error> {
        if let value = storage[key] {
            return .success(value)
        } else {
            return .failure(NSError())
        }
    }
}
