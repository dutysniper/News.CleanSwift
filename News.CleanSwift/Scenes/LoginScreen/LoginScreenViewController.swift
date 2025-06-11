//
//  ViewController.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import UIKit

// MARK: - Protocols
protocol ILoginScreenViewController: AnyObject {
	func fetchMask()
	func showAuthResult(_ success: Bool, errorMessage: String?)
	func showAuthError()
	func setPhoneMask(viewModel: LoginScreen.PhoneMask.ViewModel)
	func setSavedData(phone: String, password: String)
}

// MARK: - View Controller
final class LoginScreenViewController: UIViewController {

	// MARK: - UI Elements
	private let eyeButton = EyeButton()
	private lazy var companyLogo = makeImageView()
	private lazy var enterLabel = makeLabel(with: "Вход в аккаунт")
	private lazy var phoneLabel = makeLabel(with: "Телефон")
	private lazy var passwordLabel = makeLabel(with: "Пароль")
	private lazy var errorLabel = makeLabel(with: "Неверный пароль")
	private lazy var phoneTextField = makeTextField()
	private lazy var passwordTextField = makeSecureTextField()
	private lazy var loginButton = makeButton()

	private var isInitialLoad = true
	private var phoneMask = ""


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
		fetchMask()

		// Загружаем сохраненные данные если есть
		loadSavedCredentials()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupConstraints()

	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		phoneTextField.becomeFirstResponder()
	}

	private func loadSavedCredentials() {

	}
	private func updateLoginButtonState() {
		let phoneNotEmpty = !(phoneTextField.text?.isEmpty ?? true)
		let passwordNotEmpty = !(passwordTextField.text?.isEmpty ?? true)

		UIView.animate(withDuration: 0.3) {
			self.loginButton.alpha = (phoneNotEmpty && passwordNotEmpty) ? 1.0 : 0.5
			self.loginButton.isEnabled = (phoneNotEmpty && passwordNotEmpty)
			self.loginButton.backgroundColor = .blue
		}
	}

	// MARK: - Actions
	@objc private func loginButtonTapped() {
		guard let phone = phoneTextField.text, !phone.isEmpty,
			  let password = passwordTextField.text, !password.isEmpty else {
			showAlert(message: "Заполните все поля")
			return
		}
		interactor?.performLogin(phone: phone.digitsOnly(), password: password)
	}

	@objc private func togglePasswordVisibility() {
		passwordTextField.isSecureTextEntry.toggle()
		let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
		eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
	}

	@objc private func textFieldDidChange(_ textField: UITextField) {
		updateLoginButtonState()
	}
}

// MARK: - ILoginScreenViewController
extension LoginScreenViewController: ILoginScreenViewController {

	func setSavedData(phone: String, password: String) {
		phoneTextField.text = phone
		passwordTextField.text = password
	}

	func fetchMask() {
		interactor?.loadPhoneMask()
	}
	
	func showAuthError() {
		print("Auth error")
		errorLabel.isHidden.toggle()
		passwordTextField.layer.borderColor = .init(red: 1, green: 0, blue: 0, alpha: 1)

		DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
			self?.errorLabel.isHidden = true
			self?.passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
		}
	}

	func showAuthResult(_ success: Bool, errorMessage: String?) {
		if success {
			print("success")
		} else {
			showAlert(message: errorMessage ?? "Ошибка авторизации")
		}
	}
	func setPhoneMask(viewModel: LoginScreen.PhoneMask.ViewModel) {
		phoneMask = viewModel.phoneMask
		print(phoneMask)
	}
	private func format(with mask: String, phone: String) -> String {
		let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
		var result = ""
		var index = numbers.startIndex

		for ch in mask where index < numbers.endIndex {
			if ch == "X" || ch == "Х" {
				result.append(numbers[index])

				index = numbers.index(after: index)

			} else {
				result.append(ch)
			}
		}
		return result
	}
}

// MARK: - SetupUI
private extension LoginScreenViewController {
	func setupUI() {
		view.backgroundColor = .white

		phoneTextField.keyboardType = .numberPad
		passwordTextField.rightViewMode = .always
		eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
		loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
		phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

		phoneTextField.delegate = self
		passwordTextField.delegate = self

		[companyLogo, enterLabel, phoneLabel, phoneTextField,
		 passwordLabel, passwordTextField, loginButton, errorLabel].forEach {
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
		switch text {
		case "Вход в аккаунт":
			label.font = .systemFont(ofSize: 20, weight: .semibold)
			label.textColor = .black
		case "Неверный пароль":
			label.font = .systemFont(ofSize: 14, weight: .light)
			label.textColor = .red
			label.isHidden = true
		default:
			label.font = .systemFont(ofSize: 17, weight: .medium)
			label.textColor = .black
		}
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

		textField.layer.borderWidth = 1
		textField.layer.borderColor = UIColor.lightGray.cgColor
		textField.layer.cornerRadius = 16
		textField.textColor = .black

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
		button.backgroundColor = .blue
		button.alpha = 0.5
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

			errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4),

			loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
			loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			loginButton.heightAnchor.constraint(equalToConstant: 60)
		]
		)
	}
}

extension LoginScreenViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard textField == phoneTextField else { return true }

		let currentText = textField.text ?? ""
		var newText = currentText

		if range.length > 0 {
			let start = currentText.index(currentText.startIndex, offsetBy: range.location)
			let end = currentText.index(start, offsetBy: range.length)
			newText = currentText.replacingCharacters(in: start..<end, with: "")
		} else {
			let digits = string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
			let start = currentText.index(currentText.startIndex, offsetBy: range.location)
			newText = currentText.replacingCharacters(in: start..<start, with: digits)
		}

		let formattedText = newText.applyPhoneMask(phoneMask)
		textField.text = formattedText

		DispatchQueue.main.async {
			if let newPosition = textField.position(from: textField.endOfDocument, offset: 0) {
				textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
			}
		}

		return false
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		updateLoginButtonState()

	func textFieldDidEndEditing(_ textField: UITextField) {

		}
	}
}
