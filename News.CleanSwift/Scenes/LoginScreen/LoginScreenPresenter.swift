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
	func presentAuthError(_ message: String)
}

final class LoginScreenPresenter: ILoginScreenPresenter {

	// MARK: - Public properties
	// MARK: - Dependencies

	private weak var viewController: ILoginScreenViewController?

	// MARK: - Private properties
	// MARK: - Initialization

	init(viewController: ILoginScreenViewController?) {
		self.viewController = viewController
	}

	// MARK: - Lifecycle
	// MARK: - Public methods

	func presentPhoneMask(response: LoginScreen.PhoneMask.Response) {
		let viewModel = LoginScreen.PhoneMask.ViewModel(phoneMask: response.phoneMask
		)

		viewController?.setPhoneMask(viewModel: viewModel)
	}

	func presentAuthResult(_ success: Bool, errorMessage: String? = nil) {
		viewController?.showAuthResult(success, errorMessage: errorMessage)
	}

	func presentAuthError(_ message: String) {
		viewController?.showAuthError(message)
	}

	// MARK: - Private methods
}
