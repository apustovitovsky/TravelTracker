

import Foundation


protocol KeychainServiceProtocol: AnyObject {
    func save(key: String, value: String)
    func load(key: String) -> String?
}

final class KeychainService: KeychainServiceProtocol {
    
    private var storage: [String: String] = ["PIN":"5555"]
    
    func save(key: String, value: String) {
        storage[key] = value
    }
    
    func load(key: String) -> String? {
        if let value = storage[key] {
            return value
        } else {
            return nil
        }
    }
}
