//
//  MainCoordinator.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import UIKit


final class MainCoordinator: BaseCoordinator {

	// MARK: - Dependencies

	private let navigationController: UINavigationController

	// MARK: - Initialization

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	// MARK: - Internal methods

	override func start() {
		showLoginScreen()
	}

	func showLoginScreen() {
		let viewController = LoginScreenAssembler().assembly(loginClosure: showMainScreen)
		navigationController.pushViewController(viewController, animated: true)
	}

	func showMainScreen() {
		let viewController = MainScreenAssembler().assembly(sortClosure: showSortWindow(), detailClosure: showDetailScreen(with:))
		navigationController.pushViewController(viewController, animated: true)
	}

	func showDetailScreen(with viewModel: Post) {
		let viewController = DetalScreenAssembler().assembly(with: viewModel)
		navigationController.pushViewController(viewController, animated: true)
	}

	func showSortWindow() -> SortClosure {
		return { [weak self] in
			self?.showSortScreen()
			return true
		}
	}

	func showSortScreen() {
		guard let mainVC = navigationController.viewControllers.last as? MainScreenViewController else { return }

		let coordinator = SortCoordinator(
			navigationController: navigationController,
			onSortSelected: { [weak self] sortType in
				self?.handleSortSelection(sortType)
				if let coordinator = self?.childCoordinators.first(where: { $0 is SortCoordinator }) {
					self?.removeDependency(coordinator)
				}
			},
			initialSortType: mainVC.sortType
		)
		addDependency(coordinator)
		coordinator.start()
	}


	private func handleSortSelection(_ sortType: SortScreen.SortType) {
		guard let mainVC = navigationController.viewControllers.last as? MainScreenViewController else { return }
		mainVC.interactor?.apply(sort: sortType)
	}
}
