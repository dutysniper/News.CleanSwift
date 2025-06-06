//
//  ViewController.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import UIKit

protocol ILoginScreenViewController: AnyObject {}

final class LoginScreenViewController: UIViewController {

	// MARK: - Public properties
	// MARK: - Dependencies

	var interactor: ILoginScreenInteractor?
	
	// MARK: - Private properties

	// MARK: - Initialization

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .yellow
		
	}

	// MARK: - Public methods
	// MARK: - Private methods
}

//MARK: - ILoginScreenViewController
extension LoginScreenViewController: ILoginScreenViewController {

}
