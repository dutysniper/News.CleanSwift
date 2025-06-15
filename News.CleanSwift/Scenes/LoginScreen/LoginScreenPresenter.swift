//
//  LoginScreenPresenter.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import Foundation

protocol ILoginScreenPresenter {
	func presentPhoneMask(response: LoginScreen.PhoneMask.Response)
	func presentAuthResult(_ success: Bool, errorMessage: String?)
	func presentKeychainData(phone: String, password: String)
}

typealias LoginClosure = () -> ()

final class LoginScreenPresenter: ILoginScreenPresenter {

	// MARK: - Public properties
	// MARK: - Dependencies

	private weak var viewController: ILoginScreenViewController?

	// MARK: - Private properties
	private var loginClosure: LoginClosure?
	// MARK: - Initialization

	init(viewController: ILoginScreenViewController?, loginClosure: LoginClosure?) {
		self.viewController = viewController
		self.loginClosure = loginClosure
	}

	// MARK: - Lifecycle
	// MARK: - Public methods

	func presentPhoneMask(response: LoginScreen.PhoneMask.Response) {
		let viewModel = LoginScreen.PhoneMask.ViewModel(phoneMask: response.phoneMask
		)

		viewController?.setPhoneMask(viewModel: viewModel)
	}

	func presentAuthResult(_ success: Bool, errorMessage: String? = nil) {
		switch success {
		case true:
			print("success")
			loginClosure?()
		case false:
			viewController?.showAuthError()
		}
	}

	func presentKeychainData(phone: String, password: String) {
		viewController?.setSavedData(phone: phone, password: password)
	}
}
