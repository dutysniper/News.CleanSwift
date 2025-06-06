//
//  LoginScreenModel.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import Foundation

enum LoginScreen {
	enum PhoneMask {
		struct Request {}
		struct Response {
			let phoneMask: String
		}
		struct ViewModel {
			let phoneMask: String
		}
	}

	enum Auth {
		struct Request {
			let phone: String
			let password: String
		}
		struct Response {
			let success: Bool
			let error: Error?
		}
		struct ViewModel {
			let success: Bool
			let errorMessage: String?
		}
	}

	enum AutoFill {
		struct Response {
			let phone: String?
			let password: String?
		}
		struct ViewModel {
			let phone: String?
			let password: String?
		}
	}
}
