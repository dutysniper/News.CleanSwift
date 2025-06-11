//
//  NewsMainScreenModel.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 09.06.2025.
//

import Foundation

enum MainScreen {
	struct Response {
		struct Posts{
			let posts: [Post]
			let error: Error?
		}
		struct Sort {
			let isSortActive: Bool
		}

	}
	struct ViewModel {
		let posts: [Post]
		let errorMessage: String?
		var postsWithSort: [Post] {
			let posts = posts.sorted { post1, post2 in
				post1.date > post2.date
			}
			return posts
		}
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
