//
//  UserDefaultsManager.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 17/06/2025.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    
    func store(_ value: Any, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func storeObject<T: Codable>(object: T?, forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(object)
            UserDefaultsManager.shared.store(data, forKey: key)
        } catch {
            print("Unable to encode object (\(error))")
        }
    }
    
    func retrieve(forKey key: String) -> Any? {
        return userDefaults.value(forKey: key)
    }
    
    func retrieveObject<T: Codable>(objectType: T.Type, forKey key: String) -> T? {
        if let data = UserDefaultsManager.shared.retrieve(forKey: key) as? Data {
            do {
                let decoder = JSONDecoder()
                let decodedObject = try decoder.decode(T.self, from: data)
                return decodedObject
            } catch {
                print("Unable to decode object (\(error))")
            }
        }
        return nil
    }
    
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    func removeAll() {
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
    }
}
