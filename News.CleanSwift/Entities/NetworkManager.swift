//
//  NetworkManager.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 07.06.2025.
//
import UIKit
import Alamofire

protocol INetworkManager {
	func fetchPhoneMask(completion: @escaping (Result<String, Error>) -> Void)
	func login(phone: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
	func fetchChars(completion: @escaping (Result<[Post], Error>) -> Void)
	func loadImage(from urlString: String, completion: @escaping (Data?) -> Void)
}

final class NetworkManager: INetworkManager {
	private let baseURL = "http://dev-exam.l-tech.ru/api/v1"

	func fetchPhoneMask(completion: @escaping (Result<String, Error>) -> Void) {
		AF.request("\(baseURL)/phone_masks")
			.validate()
			.responseDecodable(of: PhoneMaskResponse.self) { response in
				switch response.result {
				case .success(let data):
					completion(.success(data.phoneMask))
				case .failure(let error):
					completion(.failure(error))
				}
			}
	}

	func login(phone: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
		let parameters: [String: String] = [
			"phone": phone,
			"password": password
		]

		let headers: HTTPHeaders = [
			"Content-Type": "application/x-www-form-urlencoded",
			"Accept": "application/json"
		]

		AF.request("\(baseURL)/auth",
				   method: .post,
				   parameters: parameters,
				   encoder: URLEncodedFormParameterEncoder(destination: .httpBody),
				   headers: headers)
		.validate()
		.responseDecodable(of: AuthResponse.self) { response in

			switch response.result {
			case .success(let data):
				completion(.success(data.success))
			case .failure(let error):
				print("Login error: \(error.localizedDescription)")
				if let data = response.data {
					print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
				}

				if let statusCode = response.response?.statusCode {
					let customError = NSError(
						domain: "",
						code: statusCode,
						userInfo: [NSLocalizedDescriptionKey: self.errorMessage(for: statusCode)])
					completion(.failure(customError))
				} else {
					completion(.failure(error))
				}
			}
		}
	}

	func fetchChars(completion: @escaping (Result<[Post], Error>) -> Void) {
		AF.request("\(baseURL)/posts")
			.validate()
			.responseDecodable(of: [Post].self) { response in
				switch response.result {
				case .success(let chars):
					completion(.success(chars))
				case .failure(let error):
					completion(.failure(error))
					print(error)
				}
			}
	}

	func loadImage(from urlString: String, completion: @escaping (Data?) -> Void) {
		let baseURL = "http://dev-exam.l-tech.ru"
		guard let url = URL(string: baseURL + urlString) else {
			completion(nil)
			return
		}

		AF.request(url).responseData { response in
			switch response.result {
			case .success(let data):
				completion(data)
			case .failure(let error):
				print("Ошибка загрузки изображения: \(error.localizedDescription)")
				completion(nil)
			}
		}
	}

	private func errorMessage(for statusCode: Int) -> String {
		switch statusCode {
			case 400: return "Неверный запрос"
			case 401: return "Неверный телефон или пароль"
			default: return "Ошибка сервера"
		}
	}
}

// MARK: - Response Models
private struct PhoneMaskResponse: Decodable {
	let phoneMask: String
}
private struct AuthResponse: Decodable {
	let success: Bool
}

