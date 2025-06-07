//
//  PhoneNumberFormatter.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 07.06.2025.
//

import Foundation

protocol IPhoneNumberFormatter {
	func formattedNumber(from phone: String) -> String
	func cleanPhoneNumber(from formattedPhone: String) -> String
}

final class PhoneNumberFormatter: IPhoneNumberFormatter {
	private var mask: String

	init(mask: String) {
		self.mask = mask
	}

	func formattedNumber(from phone: String) -> String {
		let cleanPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
		var result = ""
		var index = cleanPhone.startIndex

		for ch in mask {
			guard index < cleanPhone.endIndex else { break }
			if ch == "X" || ch == "Х" { 
				result.append(cleanPhone[index])
				index = cleanPhone.index(after: index)
			} else {
				result.append(ch)
			}
		}

		return result
	}

	func cleanPhoneNumber(from formattedPhone: String) -> String {
		return formattedPhone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
	}
}
