//
//  NewsMainScreenPresenter.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 09.06.2025.
//

import Foundation

protocol IMainScreenPresenter {
	func presentPosts(response: MainScreen.Response.Posts)
	func presentSortWindow(response: MainScreen.Response.Sort)
	func presentSortPosts(sort: SortScreen.SortType)
	func presentDetailScreen(response: Post)
}

typealias SortClosure = () -> Bool
typealias DetailClosure = (_ viewModel: Post) -> ()

final class MainScreenPresenter: IMainScreenPresenter {
	// MARK: - Dependencies

	private weak var viewController: IMainScreenViewController?
	private var sortClosure: SortClosure?
	private var detailClosure: DetailClosure?

	// MARK: - Initialization

	init(viewController: IMainScreenViewController?, sortClosure: SortClosure?, detailClosure: DetailClosure?) {
		self.viewController = viewController
		self.sortClosure = sortClosure
		self.detailClosure = detailClosure
	}

	// MARK: - Public methods

	func presentPosts(response: MainScreen.Response.Posts) {
		let loadingState: MainScreen.LoadingState

		if response.isLoading {
			loadingState = .loading
		} else if let error = response.error {
			loadingState = .error(error.localizedDescription)
		} else {
			loadingState = .loaded
		}

		let viewModel = MainScreen.ViewModel(
			posts: response.posts,
			loadingState: loadingState,
			errorMessage: response.error?.localizedDescription
		)
		DispatchQueue.main.async { [weak self] in
			self?.viewController?.displayPosts(viewModel: viewModel)
		}
	}
	func presentSortWindow(response: MainScreen.Response.Sort) {
		sortClosure?()
	}

	func presentDetailScreen(response: Post) {
		detailClosure?(response)
	}

	func presentSortPosts(sort: SortScreen.SortType) {
		
		viewController?.toggleSortType(sortType: sort)
	}
}
