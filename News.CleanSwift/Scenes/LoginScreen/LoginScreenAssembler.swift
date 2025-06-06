//
//  LoginScreenAssembler.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import UIKit

protocol ILoginScreenAssembler {

}

final class LoginScreenAssembler: ILoginScreenAssembler {
	/// Сборка модуля авторизации
	/// - Parameter loginResultClosure: замыкание оповещающие о результате авторизации
	/// - Returns: viewController
	func assembly() -> LoginScreenViewController {
		let viewController = LoginScreenViewController()
		let presenter = LoginScreenPresenter(viewController: viewController)
		let interactor = LoginScreenInteractor(presenter: presenter)

		viewController.interactor = interactor

		return viewController
	}
}
