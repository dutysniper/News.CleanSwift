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
	func updateMask(_ newMask: String)
	var prefix: String { get }
	var mask: String { get }
}

final class PhoneNumberFormatter: IPhoneNumberFormatter {
	private var maskAfterPrefix: String
	var mask: String
	var prefix: String

	init(mask: String) {
		self.mask = mask
		self.prefix = Self.extractPrefix(from: mask)
		self.maskAfterPrefix = String(mask.dropFirst(prefix.count))
	}

	func updateMask(_ newMask: String) {
		self.mask = newMask
		self.prefix = Self.extractPrefix(from: newMask)
		self.maskAfterPrefix = String(newMask.dropFirst(prefix.count))
	}

	func formatNumber(from phone: String) -> String {
		// Получаем только цифры из входящего номера
		let cleanPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

		// Получаем цифры префикса
		let prefixDigits = prefix.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

		// Если номер короче префикса, возвращаем префикс
		if cleanPhone.count <= prefixDigits.count {
			return prefix
		}

		// Берем цифры после префикса
		let phoneAfterPrefix = String(cleanPhone.dropFirst(prefixDigits.count))

		// Начинаем с префикса
		var result = prefix
		var digitIndex = 0

		// Форматируем цифры после префикса согласно маске
		for maskChar in maskAfterPrefix {
			guard digitIndex < phoneAfterPrefix.count else { break }

			if maskChar == "X" || maskChar == "Х" {
				let char = phoneAfterPrefix[phoneAfterPrefix.index(phoneAfterPrefix.startIndex, offsetBy: digitIndex)]
				result.append(char)
				digitIndex += 1
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
