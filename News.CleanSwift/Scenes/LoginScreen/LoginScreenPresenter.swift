//
//  LoginScreenPresenter.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import Foundation

protocol ILoginScreenPresenter {
	func presentPhoneMask(response: LoginScreen.PhoneMask.Response)
	func presentAuthResult(_ success: Bool, error: Error?)
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
		let formattedMask = response.phoneMask
			.replacingOccurrences(of: "X", with: "•") // Маска для отображения
		let viewModel = LoginScreen.PhoneMask.ViewModel(
			phoneMask: formattedMask,
			formattedPhone: response.formattedPhone
		)
		viewController?.displayPhoneMask(viewModel: viewModel)
	}

	func presentAuthResult(_ success: Bool, error: Error?) {
		let message = error?.localizedDescription
		viewController?.showAuthResult(success, errorMessage: message)
	}

	// MARK: - Private methods
}
