//
//  PhoneNumberFormatter.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 07.06.2025.
//

import Foundation

protocol IPhoneNumberFormatter {
	func formatNumber(from phone: String) -> String
	func cleanNumber(from formattedPhone: String) -> String
	var prefix: String { get }
}

final class PhoneNumberFormatter: IPhoneNumberFormatter {
	private let maskAfterPrefix: String
	private var mask: String
	var prefix: String
	
	init(mask: String) {
		self.mask = mask
		self.prefix = Self.extractPrefix(from: mask)
		self.maskAfterPrefix = String(mask.dropFirst(prefix.count))
	}

	func updateMask(_ newMask: String) {
		self.mask = newMask
		self.prefix = Self.extractPrefix(from: newMask)
	}

	func formatNumber(from phone: String) -> String {
		// Получаем только цифры
		let cleanPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

		// Если номер начинается с префикса, используем его, иначе добавляем
		let phoneDigits: String
		if cleanPhone.hasPrefix(prefix.filter { $0.isNumber }) {
			phoneDigits = cleanPhone
		} else {
			phoneDigits = prefix.filter { $0.isNumber } + cleanPhone
		}

		// Форматируем согласно маске
		var result = prefix
		var digitIndex = phoneDigits.index(phoneDigits.startIndex, offsetBy: prefix.filter { $0.isNumber }.count)

		for maskChar in maskAfterPrefix {
			guard digitIndex < phoneDigits.endIndex else { break }

			if maskChar == "X" || maskChar == "Х" {
				result.append(phoneDigits[digitIndex])
				digitIndex = phoneDigits.index(after: digitIndex)
			} else {
				result.append(maskChar)
			}
		}

		return result
	}

	func cleanNumber(from formattedPhone: String) -> String {
		return formattedPhone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
	}

	private static func extractPrefix(from mask: String) -> String {
		var result = ""
		for char in mask {
			if char == "X" || char == "Х" { break }
			result.append(char)
		}
		return result
	}
}
