//
//  NewsMainScreenInteractor.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 09.06.2025.
//

import Foundation

protocol IMainScreenInteractor {
	func fetchCharacters()
	func apply(sort: SortScreen.SortType)
	func openSortWindow()
	func openDetailWindow(with viewModel: Post)
}

final class MainScreenInteractor: IMainScreenInteractor {
	// MARK: - Public properties
	// MARK: - Dependencies

	private var presenter: IMainScreenPresenter?
	private var networkManager: INetworkManager?
	// MARK: - Private properties
	// MARK: - Initialization

	init(presenter: IMainScreenPresenter?, networkManager: INetworkManager?) {
		self.presenter = presenter
		self.networkManager = networkManager
	}

	// MARK: - Public methods
	func fetchCharacters() {
		presenter?.presentCharacters(
			response: MainScreen.Response.Posts(
				posts: [],
				error: nil,
				isLoading: true
			)
		)

		networkManager?.fetchChars(completion: { [weak self] result in
			switch result {
			case .success(let posts):
				self?.presenter?.presentCharacters(
					response: MainScreen.Response.Posts(
						posts: posts.sorted { $0.sort < $1.sort },
						error: nil,
						isLoading: false
					)
				)
			case .failure(let error):
				print("failure")
				self?.presenter?.presentCharacters(
					response: MainScreen.Response.Posts(
						posts: [],
						error: error,
						isLoading: false
					)
				)
			}
		})
	}

	func openSortWindow() {
		print("interactor: openSortWindow")
		presenter?.presentSortWindow(response: MainScreen.Response.Sort(isSortActive: true))
	}

	func openDetailWindow(with viewModel: Post) {
		presenter?.presentDetailScreen(response: viewModel)
	}
	func apply(sort: SortScreen.SortType) {
		presenter?.presentSortPosts(sort: sort)
	}
	// MARK: - Private methods
}
