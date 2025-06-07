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
	func formatPhoneNumber(_ phone: String) -> String
	func cleanPhoneNumber(_ phone: String) -> String 
}

final class LoginScreenInteractor: ILoginScreenInteractor {
	
	// MARK: - Public properties
	// MARK: - Dependencies
	private var phoneNumberFormatter: IPhoneNumberFormatter?
	private var presenter: ILoginScreenPresenter?
	private var networkManager: INetworkManager?
	private var keychainManager: IKeychainManager?

	// MARK: - Private properties
	// MARK: - Initialization

	init(phoneNumberFormatter: IPhoneNumberFormatter?, presenter: ILoginScreenPresenter?, networkManager: INetworkManager?, keychainManager: IKeychainManager) {
		self.phoneNumberFormatter = phoneNumberFormatter
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
					let formatter = PhoneNumberFormatter(mask: mask)
					self?.phoneNumberFormatter = formatter

					// Форматируем текущий номер если есть
					let currentPhone = self?.keychainManager?.getCredentials()?.phone
					let formattedPhone = currentPhone.map { formatter.formattedNumber(from: $0) }

					let response = LoginScreen.PhoneMask.Response(
						phoneMask: mask,
						formattedPhone: formattedPhone
					)
					self?.presenter?.presentPhoneMask(response: response)

				case .failure(let error):
					print("Phone mask error: \(error.localizedDescription)")
					// Используем маску по умолчанию
					let response = LoginScreen.PhoneMask.Response(
						phoneMask: "+7 (XXX) XXX-XX-XX",
						formattedPhone: "+7"
					)
					self?.presenter?.presentPhoneMask(response: response)
				}
			}
		}
	}

	func formatPhoneNumber(_ phone: String) -> String {
		return phoneNumberFormatter?.formattedNumber(from: phone) ?? phone
	}

	func cleanPhoneNumber(_ phone: String) -> String {
		return phoneNumberFormatter?.cleanPhoneNumber(from: phone) ?? phone
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
