//
//  LoginScreenPresenter.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import Foundation

protocol ILoginScreenPresenter {
	func presentPhoneMask(response: LoginScreen.PhoneMask.Response)
	func presentAuthResult(_ success: Bool)
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
		if response.shouldUpdateMask {
			viewController?.updatePhoneMask()
		}
		if let phone = response.formattedPhone {
			viewController?.setPhoneNumber(phone)
		}
	}

	func presentAuthResult(_ success: Bool) {
		viewController?.showAuthResult(success)
	}

	func presentAuthError(_ message: String) {
		viewController?.showAuthError(message)
	}

	// MARK: - Private methods
}
