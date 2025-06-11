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
	private let initialSortType: SortScreen.SortType

	init(navigationController: UINavigationController, onSortSelected: @escaping (SortScreen.SortType) -> Void, initialSortType: SortScreen.SortType) {
		self.navigationController = navigationController
		self.onSortSelected = onSortSelected
		self.initialSortType = initialSortType
	}

	override func start() {
		let viewController = SortScreenAssembler().assembly(selectedType: initialSortType, onDismiss: onSortSelected)
		viewController.modalPresentationStyle = .custom
		viewController.transitioningDelegate = transitionDelegate
		navigationController.present(viewController, animated: true)
	}
}
