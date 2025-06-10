//
//  NewsMainScreenInteractor.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 09.06.2025.
//

import Foundation

protocol IMainScreenInteractor {
	func fetchCharacters()
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
		networkManager?.fetchChars(completion: { [weak self] result in
			switch result {
			case .success(let characters):
				print(characters.first?.date)
				print(characters.first?.formattedDate)
				self?.presenter?.presentCharacters(
					response: MainScreen.Response(
						characters: characters.sorted { $0.sort < $1.sort },
						error: nil)
				)
			case .failure(let error):
				print("failure")
				self?.presenter?.presentCharacters(
					response: MainScreen.Response(
						characters: [],
						error: error)
				)
			}
		})
	}
	// MARK: - Private methods
}
