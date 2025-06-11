//
//  NewsMainScreenPresenter.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 09.06.2025.
//

import Foundation

protocol IMainScreenPresenter {
	func presentCharacters(response: MainScreen.Response.Posts)
	func presentSortWindow(response: MainScreen.Response.Sort)
	func presentSortPosts(sort: SortScreen.SortType)
}

typealias SortClosure = () -> Bool

final class MainScreenPresenter: IMainScreenPresenter {
	// MARK: - Public properties
	// MARK: - Dependencies

	private weak var viewController: IMainScreenViewController?
	private var sortClosure: SortClosure?

	// MARK: - Private properties
	// MARK: - Initialization

	init(viewController: IMainScreenViewController?, sortClosure: SortClosure?) {
		self.viewController = viewController
		self.sortClosure = sortClosure
	}

	// MARK: - Public methods

	func presentCharacters(response: MainScreen.Response.Posts) {
		let viewModel = MainScreen.ViewModel(
			posts: response.posts,
			errorMessage: response.error?.localizedDescription
		)
		viewController?.displayCharacters(viewModel: viewModel)
	}
	func presentSortWindow(response: MainScreen.Response.Sort) {
		sortClosure?()
	}

	func presentSortPosts(sort: SortScreen.SortType) {
		
		viewController?.toggleSortType(sortType: sort)
	}

	// MARK: - Private methods
}
