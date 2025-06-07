//
//  LoginScreenPresenter.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import Foundation

protocol ILoginScreenPresenter {
	func presentPhoneMask(_ mask: String)
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

	func presentPhoneMask(_ mask: String) {
		viewController?.updatePhoneMask(mask)
	}

	func presentAuthResult(_ success: Bool, error: Error?) {
		let message = error?.localizedDescription
		viewController?.showAuthResult(success, errorMessage: message)
	}

	// MARK: - Private methods
}
