//
//  DetailScreenInteractor.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 11.06.2025.
//

import Foundation

protocol IDetailScreenInteractor {
	func fetchImage(with request: DetailScreen.Request)
}

final class DetailScreenInteractor: IDetailScreenInteractor {
	// MARK: - Public properties
	// MARK: - Dependencies

	private var presenter: IDetailScreenPresenter?
	private var networkManager: INetworkManager?

	// MARK: - Private properties
	// MARK: - Initialization

	init(presenter: IDetailScreenPresenter, networkManager: INetworkManager?) {
		self.presenter = presenter
		self.networkManager = networkManager
	}
}

//MARK: - IDetailScreenInteractor
extension DetailScreenInteractor {
	func fetchImage(with request: DetailScreen.Request) {
		networkManager?.loadImage(from: request.url) { [weak self] data in
			let response = DetailScreen.Response(data: data)
			self?.presenter?.presentImage(from: response)
		}
	}
}
