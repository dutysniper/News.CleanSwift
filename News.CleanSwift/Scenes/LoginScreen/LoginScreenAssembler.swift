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
	func assembly(loginClosure: @escaping LoginClosure) -> LoginScreenViewController {
		let viewController = LoginScreenViewController()
		let networkManager = NetworkManager()
		let keychainManger = KeychainManager()
		let presenter = LoginScreenPresenter(viewController: viewController, loginClosure: loginClosure)
		let interactor = LoginScreenInteractor(
			presenter: presenter,
			networkManager: networkManager,
			keychainManager: keychainManger
		)

		viewController.interactor = interactor

		return viewController
	}
}
