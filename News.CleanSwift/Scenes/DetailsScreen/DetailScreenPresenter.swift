//
//  DetailScreenPresenter.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 11.06.2025.
//

import Foundation

protocol IDetailScreenPresenter {
	func presentImage(from response: DetailScreen.Response)
}

final class DetailScreenPresenter: IDetailScreenPresenter {
	// MARK: - Dependencies

	private weak var viewController: IDetailScreenViewController?

	// MARK: - Initialization

	init(viewController: IDetailScreenViewController?) {
		self.viewController = viewController
	}
	// MARK: - Public methods
	func presentImage(from response: DetailScreen.Response) {
		guard let data = response.data else { return }
		viewController?.setImage(with: data)
	}
}


