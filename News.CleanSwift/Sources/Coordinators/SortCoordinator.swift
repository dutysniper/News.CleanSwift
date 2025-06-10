//
//  SortCoordinator.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 10.06.2025.
//

import UIKit

final class SortCoordinator: BaseCoordinator {
	private let navigationController: UINavigationController
	private let onSortSelected: (SortScreen.SortType) -> Void
	private let transitionDelegate = BottomSheetTransitionDelegate()

	init(
		navigationController: UINavigationController,
		onSortSelected: @escaping (SortScreen.SortType) -> Void
	) {
		self.navigationController = navigationController
		self.onSortSelected = onSortSelected
	}

	override func start() {
		let viewController = SortScreenAssembler().assembly(selectedType: SortScreen.SortType.defaultByServer, onDismiss: onSortSelected)
		viewController.modalPresentationStyle = .custom
		viewController.transitioningDelegate = transitionDelegate

		navigationController.present(viewController, animated: true)
	}
}
