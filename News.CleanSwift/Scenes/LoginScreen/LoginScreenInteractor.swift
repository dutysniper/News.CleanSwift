//
//  LoginScreenInteractor.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import Foundation

protocol ILoginScreenInteractor {
	func fetchPhoneMask()
	func performLogin(phone: String, password: String)
}

final class LoginScreenInteractor: ILoginScreenInteractor {
	
	// MARK: - Public properties
	// MARK: - Dependencies

	private var presenter: ILoginScreenPresenter?
	private var networkManager: INetworkManager?
	private var keychainManager: IKeychainManager?

	// MARK: - Private properties
	// MARK: - Initialization

	init(presenter: ILoginScreenPresenter?, networkManager: INetworkManager?, keychainManager: IKeychainManager) {
		self.presenter = presenter
		self.networkManager = networkManager
		self.keychainManager = keychainManager
	}

	// MARK: - Public methods

	func fetchPhoneMask() {
		networkManager?.getPhoneMask { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success(let mask):
					self?.presenter?.presentPhoneMask(mask)
				case .failure(let error):
					print("Phone mask error: \(error.localizedDescription)")
					// Можно показать маску по умолчанию
					self?.presenter?.presentPhoneMask("+7 (XXX) XXX-XX-XX")
				}
			}
		}
	}

	func performLogin(phone: String, password: String) {
		networkManager?.login(phone: phone, password: password) { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success(let success):
					if success {
						self?.keychainManager?.saveCredentials(phone: phone, password: password)
					}
					self?.presenter?.presentAuthResult(success, error: success ? nil : NSError(domain: "", code: 401, userInfo: nil))
				case .failure(let error):
					self?.presenter?.presentAuthResult(false, error: error)
				}
			}
		}
	}

	// MARK: - Private methods

}
