//
//  NewsMainScreenAssembler.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 09.06.2025.
//

import UIKit


final class DotaCharactersScreenAssembler {
	/// Сборка модуля авторизации
	/// - Parameter loginResultClosure: замыкание оповещающие о результате авторизации
	/// - Returns: viewController
	func assembly() -> MainScreenViewController {
		let viewController = MainScreenViewController()
		let networkManager = NetworkManager()
		let presenter = MainScreenPresenter(viewController: viewController)
		let interactor = MainScreenInteractor(
			presenter: presenter,
			networkManager: networkManager
		)

		viewController.interactor = interactor

		return viewController
	}
}

