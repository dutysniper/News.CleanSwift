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
		let viewController = LoginScreenAssembler().assembly()
		navigationController.pushViewController(viewController, animated: true)
	}
}
