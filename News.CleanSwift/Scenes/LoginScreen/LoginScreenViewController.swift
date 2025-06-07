//
//  ViewController.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import UIKit

// MARK: - Protocols
protocol ILoginScreenViewController: AnyObject {
	func updatePhoneMask(_ mask: String)
	func showAuthResult(_ success: Bool, errorMessage: String?)
}

// MARK: - View Controller
final class LoginScreenViewController: UIViewController {

	// MARK: - UI Elements
	private let eyeButton = EyeButton()
	private lazy var companyLogo = makeImageView()
	private lazy var enterLabel = makeLabel(with: "Вход в аккаунт")
	private lazy var phoneLabel = makeLabel(with: "Телефон")
	private lazy var passwordLabel = makeLabel(with: "Пароль")
	private lazy var phoneTextField = makeTextField()
	private lazy var passwordTextField = makeSecureTextField()
	private lazy var loginButton = makeButton()


	// MARK: - Initialization

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Dependencies
	var interactor: ILoginScreenInteractor?

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		interactor?.fetchPhoneMask()
	}
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupConstraints()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		phoneTextField.becomeFirstResponder()
	}

	// MARK: - Actions
	@objc private func loginButtonTapped() {
		guard let phone = phoneTextField.text, !phone.isEmpty,
			  let password = passwordTextField.text, !password.isEmpty else {
			showAlert(message: "Заполните все поля")
			return
		}
		interactor?.performLogin(phone: phone, password: password)
	}

	@objc private func togglePasswordVisibility() {
		passwordTextField.isSecureTextEntry.toggle()
		let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
		eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
	}
}

// MARK: - ILoginScreenViewController
extension LoginScreenViewController: ILoginScreenViewController {
	func updatePhoneMask(_ mask: String) {
		phoneTextField.placeholder = mask
	}

	func showAuthResult(_ success: Bool, errorMessage: String?) {
		if success {
			print("success")
		} else {
			showAlert(message: errorMessage ?? "Ошибка авторизации")
		}
	}
}

// MARK: - SetupUI
private extension LoginScreenViewController {
	func setupUI() {
		view.backgroundColor = .white

		phoneTextField.keyboardType = .phonePad
		passwordTextField.rightViewMode = .always
		eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
		loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

		[companyLogo, enterLabel, phoneLabel, phoneTextField,
		 passwordLabel, passwordTextField, loginButton].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
	}

	func makeImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "logo")
		imageView.contentMode = .scaleAspectFit
		return imageView
	}

	func makeLabel(with text: String) -> UILabel {
		let label = UILabel()
		label.text = text
		label.textColor = .black
		label.font = text == "Вход в аккаунт"
		? .systemFont(ofSize: 20, weight: .semibold)
		: .systemFont(ofSize: 17, weight: .medium)
		return label
	}

	func makeTextField() -> UITextField {
		let textField = UITextField()
		textField.backgroundColor  = .white
		textField.keyboardAppearance = .light
		textField.clearButtonMode = .always
		if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
			let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
			clearButton.setImage(templateImage, for: .normal)
			clearButton.tintColor = .lightGray

		}
		textField.borderStyle = .roundedRect
		textField.layer.borderWidth = 1
		textField.layer.borderColor = UIColor.lightGray.cgColor
		textField.layer.cornerRadius = 16
		textField.textColor = .black

		if #available(iOS 12.0, *) {
			textField.textContentType = .oneTimeCode
		} else {
			textField.textContentType = .init(rawValue: "")
		}

		return textField
	}

	func makeSecureTextField() -> UITextField {
		let textField = UITextField()
		textField.keyboardAppearance = .light
		let attributedPlaceholder = NSAttributedString(string: "Введите пароль", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
		textField.attributedPlaceholder = attributedPlaceholder
		textField.isSecureTextEntry = true
		textField.autocapitalizationType = .none
		textField.backgroundColor  = .white
		textField.textColor = .black
		textField.borderStyle = .roundedRect
		textField.layer.borderWidth = 1
		textField.layer.borderColor = UIColor.lightGray.cgColor
		textField.layer.cornerRadius = 16
		let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
		rightViewContainer.addSubview(eyeButton)

		textField.rightView = rightViewContainer
		textField.rightViewMode = .always

		if #available(iOS 12.0, *) {
			textField.textContentType = .oneTimeCode
		} else {
			textField.textContentType = .init(rawValue: "")
		}
		

		return textField
	}

	func makeButton() -> UIButton {
		let button = UIButton()
		button.setTitle("Войти", for: .normal)
		button.backgroundColor = UIColor(red: 185/255.0, green: 212/255.0, blue: 249/255.0, alpha: 1.0)
		button.layer.cornerRadius = 16
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
		return button
	}

	func showAlert(message: String) {
		let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)
	}
}

//MARK: - Layout
private extension LoginScreenViewController {
	func setupConstraints() {
		NSLayoutConstraint.activate(
			[
			companyLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			companyLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			companyLogo.widthAnchor.constraint(equalToConstant: 130),
			companyLogo.heightAnchor.constraint(equalToConstant: 28),

			enterLabel.topAnchor.constraint(equalTo: companyLogo.bottomAnchor, constant: 24),
			enterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

			phoneLabel.topAnchor.constraint(equalTo: enterLabel.bottomAnchor, constant: 32),
			phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

			phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
			phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			phoneTextField.heightAnchor.constraint(equalToConstant: 45),

			passwordLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 16),
			passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

			passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
			passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			passwordTextField.heightAnchor.constraint(equalToConstant: 45),

			loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
			loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			loginButton.heightAnchor.constraint(equalToConstant: 60)
		]
		)
	}
}

