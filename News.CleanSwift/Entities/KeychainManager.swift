//
//  KeychainManager.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 07.06.2025.
//

import Foundation

protocol IKeychainManager {
	func saveCredentials(phone: String, password: String)
	func getCredentials() -> (phone: String, password: String)?
}

final class KeychainManager: IKeychainManager {
	private let service = "com.your.app.login"

	func saveCredentials(phone: String, password: String) {
		save(phone, key: "phone")
		save(password, key: "password")
	}

	func getCredentials() -> (phone: String, password: String)? {
		guard let phone = get(key: "phone"),
			  let password = get(key: "password") else {
			return nil
		}
		return (phone, password)
	}

	private func save(_ value: String, key: String) {
		let query = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrService: service,
			kSecAttrAccount: key,
			kSecValueData: value.data(using: .utf8)!
		] as CFDictionary

		SecItemDelete(query)
		SecItemAdd(query, nil)
	}

	private func get(key: String) -> String? {
		let query = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrService: service,
			kSecAttrAccount: key,
			kSecReturnData: kCFBooleanTrue!,
			kSecMatchLimit: kSecMatchLimitOne
		] as CFDictionary

		var result: AnyObject?
		SecItemCopyMatching(query, &result)

		guard let data = result as? Data else { return nil }
		return String(data: data, encoding: .utf8)
	}
}
