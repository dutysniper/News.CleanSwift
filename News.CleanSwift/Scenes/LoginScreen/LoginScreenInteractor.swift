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

	// MARK: - Dependencies
	private var presenter: ILoginScreenPresenter?
	private var networkManager: INetworkManager?
	private var keychainManager: IKeychainManager?

	// MARK: - Initialization
	
	init(presenter: ILoginScreenPresenter?, networkManager: INetworkManager?, keychainManager: IKeychainManager) {
		self.presenter = presenter
		self.networkManager = networkManager
		self.keychainManager = keychainManager
	}
	
	// MARK: - Public methods

	func loadPhoneMask() {
		guard let loginData = keychainManager?.getCredentials() else {
			networkManager?.fetchPhoneMask { [weak self] result in
				DispatchQueue.main.async {
					switch result {
					case .success(let mask):
						let response = LoginScreen.PhoneMask.Response(phoneMask: mask)
						self?.presenter?.presentPhoneMask(response: response)


					case .failure(let error):
						print("Failed to load phone mask: \(error)")
					}
				}
			}
			return
		}
		presenter?.presentKeychainData(phone: loginData.phone, password: loginData.password)
	}


	func performLogin(phone: String, password: String) {
		networkManager?.login(phone: phone, password: password) { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success(let success):
					if success {
						self?.keychainManager?.saveCredentials(phone: phone, password: password)
					}
					self?.presenter?.presentAuthResult(success, errorMessage: nil)
				case .failure(let error):
					self?.presenter?.presentAuthResult(false, errorMessage: error.localizedDescription)
				}
			}
		}
	}
}
