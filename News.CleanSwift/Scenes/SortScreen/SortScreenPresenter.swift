//
//  SortScreenPresenter.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 10.06.2025.
//

import Foundation

protocol ISortScreenPresenter {
	func presentSelectedSort(response: SortScreen.SelectSort.Response)
}

final class SortScreenPresenter: ISortScreenPresenter {
	// MARK: - Dependencies
	weak var viewController: ISortScreenViewController?

	init(viewController: ISortScreenViewController?) {
		self.viewController = viewController
	}

	// MARK: - Public methods
	func presentSelectedSort(response: SortScreen.SelectSort.Response) {
		let viewModel = SortScreen.SelectSort.ViewModel(selectedType: response.selectedType)
		viewController?.displaySelectedSort(viewModel: viewModel)
	}
}
