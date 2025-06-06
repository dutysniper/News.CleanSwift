//
//  LoginScreenInteractor.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import Foundation

protocol ILoginScreenInteractor {

}

final class LoginScreenInteractor: ILoginScreenInteractor {
	
	// MARK: - Public properties
	// MARK: - Dependencies

	private var presenter: ILoginScreenPresenter?

	// MARK: - Private properties
	// MARK: - Initialization

	init(presenter: ILoginScreenPresenter?) {
		self.presenter = presenter
	}

	// MARK: - Public methods
	// MARK: - Private methods

}
