//
//  LoginScreenInteractor.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import Foundation

protocol ILoginScreenInteractor {
	func fetchPhoneMaskIfNeeded()
	func performLogin(phone: String, password: String)
	func formatPhoneNumber(_ phone: String) -> String
	func getNumberPrefix() -> String
}

final class LoginScreenInteractor: ILoginScreenInteractor {
	
	// MARK: - Public properties
	// MARK: - Dependencies
	var phoneNumberFormatter: IPhoneNumberFormatter?
	private var presenter: ILoginScreenPresenter?
	private var networkManager: INetworkManager?
	private var keychainManager: IKeychainManager?
	// MARK: - Private properties
	private var isMaskLoaded = false
	// MARK: - Initialization
	
	init(phoneNumberFormatter: IPhoneNumberFormatter?, presenter: ILoginScreenPresenter?, networkManager: INetworkManager?, keychainManager: IKeychainManager) {
		self.phoneNumberFormatter = phoneNumberFormatter
		self.presenter = presenter
		self.networkManager = networkManager
		self.keychainManager = keychainManager
	}
	
	// MARK: - Public methods
	
	func fetchPhoneMaskIfNeeded() {
		guard !isMaskLoaded else { return }
		
		if let savedPhone = keychainManager?.getCredentials()?.phone, !savedPhone.isEmpty {
			// Используем сохраненный номер без загрузки маски
			let response = LoginScreen.PhoneMask.Response(
				formattedPhone: savedPhone,
				shouldUpdateMask: false
			)
			presenter?.presentPhoneMask(response: response)
		} else {
			// Загружаем маску с сервера
			loadPhoneMask()
		}
	}
	
	private func loadPhoneMask() {
		networkManager?.fetchPhoneMask { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success(let mask):
					self?.phoneNumberFormatter = PhoneNumberFormatter(mask: mask)
					self?.isMaskLoaded = true
					
					let response = LoginScreen.PhoneMask.Response(
						formattedPhone: nil,
						shouldUpdateMask: true
					)
					self?.presenter?.presentPhoneMask(response: response)
					
				case .failure(let error):
					print("Failed to load phone mask: \(error)")
					// Используем маску по умолчанию
					self?.phoneNumberFormatter = PhoneNumberFormatter(mask: "+7 (XXX) XXX-XX-XX")
					self?.isMaskLoaded = true
					
					let response = LoginScreen.PhoneMask.Response(
						formattedPhone: nil,
						shouldUpdateMask: true
					)
					self?.presenter?.presentPhoneMask(response: response)
				}
			}
		}
	}
	
	func formatPhoneNumber(_ phone: String) -> String {
		guard let formatter = phoneNumberFormatter else {
			return phone
		}

		// Если текст пустой, возвращаем префикс
		if phone.isEmpty {
			return formatter.prefix
		}

		// Форматируем номер
		let formatted = phoneNumberFormatter?.formatNumber(from: phone) ?? phone
		print("[INTERACTOR] Форматирование номера: '\(phone)' -> '\(formatted)'")
		return formatted
	}

	func performLogin(phone: String, password: String) {
		let cleanPhone = phoneNumberFormatter?.cleanNumber(from: phone) ?? phone
		networkManager?.login(phone: cleanPhone, password: password) { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success(let success):
					if success {
						self?.keychainManager?.saveCredentials(phone: phone, password: password)
					}
					self?.presenter?.presentAuthResult(success)
				case .failure(let error):
					self?.presenter?.presentAuthError(error.localizedDescription)
				}
			}
		}
	}
	
	func getNumberPrefix() -> String {
		let prefix = phoneNumberFormatter?.prefix ?? ""
		print("[INTERACTOR] Запрошен префикс номера: '\(prefix)'")
		return prefix
	}
	// MARK: - Private methods

}
