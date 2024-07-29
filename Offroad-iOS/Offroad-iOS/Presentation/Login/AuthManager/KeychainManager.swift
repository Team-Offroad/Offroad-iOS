//
//  KeychainManager.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/30/24.
//

import Foundation

import Security

final class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() {}
    
    func saveAccessToken(token: String) {
        guard let tokenData = token.data(using: .utf8) else { return }
        save(key: "accessToken", data: tokenData)
    }

    func saveRefreshToken(token: String) {
        guard let tokenData = token.data(using: .utf8) else { return }
        save(key: "refreshToken", data: tokenData)
    }
    
    func loadAccessToken() -> String? {
        guard let tokenData = read(key: "accessToken") else { return nil }
        return String(data: tokenData, encoding: .utf8)
    }

    func loadRefreshToken() -> String? {
        guard let tokenData = read(key: "refreshToken") else { return nil }
        return String(data: tokenData, encoding: .utf8)
    }
    
    func deleteAccessToken() {
        delete(key: "accessToken")
    }

    func deleteRefreshToken() {
        delete(key: "refreshToken")
    }
    
    func saveUserName(name: String) {
        guard let nameData = name.data(using: .utf8) else { return }
        save(key: "userName", data: nameData)
    }
    
    func loadUserName() -> String? {
        guard let nameData = read(key: "userName") else { return nil }
        return String(data: nameData, encoding: .utf8)
    }
    
    func saveUserEmail(email: String) {
        guard let emailData = email.data(using: .utf8) else { return }
        save(key: "userEmail", data: emailData)
    }
    
    func loadUserEmail() -> String? {
        guard let emailData = read(key: "userEmail") else { return nil }
        return String(data: emailData, encoding: .utf8)
    }
    
    func saveUserId(id: String) {
        guard let idData = id.data(using: .utf8) else { return }
        save(key: "userId", data: idData)
    }
    
    func checkLoginHistory() -> Bool {
        guard read(key: "userId") != nil else { return false }
        return true
    }
    
    private func save(key: String, data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            print("Error: \(status)")
            return
        }
    }
    
    private func read(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            print("Error: \(status)")
            return nil
        }
        
        return result as? Data
    }
    
    private func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            print("Error: \(status)")
            return
        }
    }
}
