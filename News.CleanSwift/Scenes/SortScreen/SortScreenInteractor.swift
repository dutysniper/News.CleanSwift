//
//  SortScreenInteractor.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 10.06.2025.
//

import Foundation

protocol ISortScreenInteractor {
	func selectSort(request: SortScreen.SelectSort.Request)
}

final class SortScreenInteractor: ISortScreenInteractor {
	// MARK: - Dependencies
	var presenter: ISortScreenPresenter?

	// MARK: - Public methods
	func selectSort(request: SortScreen.SelectSort.Request) {
		let response = SortScreen.SelectSort.Response(selectedType: request.sortType)
		presenter?.presentSelectedSort(response: response)
	}
}
