//
//  LoginScreenPresenter.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import Foundation

protocol ILoginScreenPresenter {

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
	// MARK: - Private methods
}
