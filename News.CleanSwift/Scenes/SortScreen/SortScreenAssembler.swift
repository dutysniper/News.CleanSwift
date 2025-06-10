//
//  SortScreenAssembler.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 10.06.2025.
//

import UIKit

final class SortScreenAssembler {
	func assembly(
		selectedType: SortScreen.SortType,
		onDismiss: @escaping (SortScreen.SortType) -> Void
	) -> SortScreenViewController {
		let viewController = SortScreenViewController(
			selectedType: selectedType,
			onDismiss: onDismiss
		)
		let interactor = SortScreenInteractor()
		let presenter = SortScreenPresenter(viewController: viewController)

		viewController.interactor = interactor
		interactor.presenter = presenter

		return viewController
	}
}
