//
//  NewsMainScreenPresenter.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 09.06.2025.
//

import Foundation

protocol IMainScreenPresenter {
	func presentCharacters(response: MainScreen.Response)
}

final class MainScreenPresenter: IMainScreenPresenter {
	// MARK: - Public properties
	// MARK: - Dependencies

	private weak var viewController: IMainScreenViewController?

	// MARK: - Private properties
	// MARK: - Initialization

	init(viewController: IMainScreenViewController?) {
		self.viewController = viewController
	}

	// MARK: - Public methods

	func presentCharacters(response: MainScreen.Response) {
		let viewModel = MainScreen.ViewModel(
			chars: response.characters,
			errorMessage: response.error?.localizedDescription
		)
		viewController?.displayCharacters(viewModel: viewModel)
		print(viewModel.chars.first)
	}

	// MARK: - Private methods
}
