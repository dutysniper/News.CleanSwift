//
//  NewsMainScreenAssembler.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 09.06.2025.
//

import UIKit


final class MainScreenAssembler {
	/// Сборка модуля авторизации
	/// - Parameter loginResultClosure: замыкание оповещающие о результате авторизации
	/// - Returns: viewController
	func assembly(sortClosure: @escaping SortClosure) -> MainScreenViewController {
		let viewController = MainScreenViewController()
		let networkManager = NetworkManager()
		let presenter = MainScreenPresenter(viewController: viewController, sortClosure: sortClosure)
		let interactor = MainScreenInteractor(
			presenter: presenter,
			networkManager: networkManager
		)

		viewController.interactor = interactor

		return viewController
	}
}

