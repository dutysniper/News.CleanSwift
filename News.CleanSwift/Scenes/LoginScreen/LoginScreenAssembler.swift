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
		let phoneNumberFormatter = PhoneNumberFormatter(mask: "+7 (XXX) XXX-XX-XX")
		let viewController = LoginScreenViewController()
		let networkManager = NetworkManager()
		let keychainManger = KeychainManager()
		let presenter = LoginScreenPresenter(viewController: viewController)
		let interactor = LoginScreenInteractor(
			phoneNumberFormatter: phoneNumberFormatter,
			presenter: presenter,
			networkManager: networkManager,
			keychainManager: keychainManger
		)

		viewController.interactor = interactor

		return viewController
	}
}
