//
//  DetailScreenAssembler.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 11.06.2025.
//

import Foundation

final class DetalScreenAssembler {
	/// Сборка модуля детального экрана
	/// - Parameter viewModel: модель с главного экрана
	/// - Returns: viewController
	func assembly(with viewModel: Post) -> DetailScreenViewController {
		let viewController = DetailScreenViewController(viewModel: viewModel)
		let networkManager = NetworkManager()
		let presenter = DetailScreenPresenter(viewController: viewController)
		let interactor = DetailScreenInteractor(
			presenter: presenter,
			networkManager: networkManager
		)
		viewController.interactor = interactor

		return viewController
	}
}
