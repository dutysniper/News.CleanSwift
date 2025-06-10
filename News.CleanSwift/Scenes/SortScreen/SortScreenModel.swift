//
//  SortScreenModel.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 10.06.2025.
//

import Foundation

enum SortScreen {
	enum SortType {
		case defaultByServer
		case byDate
	}
	enum SelectSort {
		struct Request {
			let sortType: SortType
		}
		struct Response {
			let selectedType: SortType
		}
		struct ViewModel {
			let selectedType: SortType
		}
	}
}
