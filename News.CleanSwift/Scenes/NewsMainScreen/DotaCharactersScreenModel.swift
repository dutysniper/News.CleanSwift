//
//  NewsMainScreenModel.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 09.06.2025.
//

import Foundation

enum MainScreen {
	struct Response {
		let characters: [Post]
		let error: Error?
	}
	struct ViewModel {
		let posts: [Post]
		let errorMessage: String?
	}
}

struct Post: Decodable {
	let id: String
	let title: String
	let text: String
	let image: String
	let sort: Int
	let date: String

	var formattedDate: String {
		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

		guard let date = isoFormatter.date(from: self.date) else {
			return self.date
		}

		let outputFormatter = DateFormatter()
		outputFormatter.locale = Locale(identifier: "ru_RU")
		outputFormatter.dateFormat = "dd MMMM, HH:mm"

		return outputFormatter.string(from: date)
	}
}
