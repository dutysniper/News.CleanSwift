//
//  NetworkManager.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 07.06.2025.
//
import Foundation
import Alamofire

protocol INetworkManager {
	func getPhoneMask(completion: @escaping (Result<String, Error>) -> Void)
	func login(phone: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

final class NetworkManager: INetworkManager {
	private let baseURL = "http://dev-exam.l-tech.ru/api/v1"

	func getPhoneMask(completion: @escaping (Result<String, Error>) -> Void) {
		AF.request("\(baseURL)/phone_masks")
			.validate()
			.responseDecodable(of: PhoneMaskResponse.self) { response in
				switch response.result {
				case .success(let data):
					print("success fetch phone mask")
					print("mask: \(data.phoneMask)")
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
			print("Response: \(response)")

			switch response.result {
			case .success(let data):
				print("Login success: \(data.success)")
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

