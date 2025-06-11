//
//  LoginScreenInteractor.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import Foundation

protocol ILoginScreenInteractor {
	func loadPhoneMask()
	func performLogin(phone: String, password: String)
}

final class LoginScreenInteractor: ILoginScreenInteractor {
	
	// MARK: - Public properties

	// MARK: - Dependencies
	private var presenter: ILoginScreenPresenter?
	private var networkManager: INetworkManager?
	private var keychainManager: IKeychainManager?

	// MARK: - Private properties

	private var isMaskLoaded = false

	// MARK: - Initialization
	
	init(presenter: ILoginScreenPresenter?, networkManager: INetworkManager?, keychainManager: IKeychainManager) {
		self.presenter = presenter
		self.networkManager = networkManager
		self.keychainManager = keychainManager
	}
	
	// MARK: - Public methods

	func loadPhoneMask() {
		networkManager?.fetchPhoneMask { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success(let mask):
					let response = LoginScreen.PhoneMask.Response(phoneMask: mask)
					self?.presenter?.presentPhoneMask(response: response)


				case .failure(let error):
					print("Failed to load phone mask: \(error)")
					// Используем маску по умолчанию
				}
			}
		}
	}


	func performLogin(phone: String, password: String) {
//		let cleanPhone = phoneNumberFormatter?.cleanNumber(from: phone) ?? phone
//
//		networkManager?.login(phone: cleanPhone, password: password) { [weak self] result in
//			DispatchQueue.main.async {
//				switch result {
//				case .success(let success):
//					if success {
//						// Сохраняем данные в keychain при успешной авторизации
//						self?.keychainManager?.saveCredentials(phone: phone, password: password)
//					}
//					self?.presenter?.presentAuthResult(success, errorMessage: nil)
//				case .failure(let error):
//					self?.presenter?.presentAuthResult(false, errorMessage: error.localizedDescription)
//				}
//			}
//		}
	}
	// MARK: - Private methods
}
