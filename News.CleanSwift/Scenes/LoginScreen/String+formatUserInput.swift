//
//  String+formatUserInput.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 11.06.2025.
//

import Foundation

extension String {
	func applyPhoneMask(_ mask: String, replacementCharacter: Character = "Х") -> String {
		let pureNumber = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
		var result = ""
		var numberIndex = pureNumber.startIndex

		// 1. Находим префикс (все до первого replacementCharacter)
		let prefix = String(mask.prefix { $0 != replacementCharacter })
		result = prefix

		// 2. Вычисляем сколько цифр уже в префиксе (например, в "+7" - это 1 цифра)
		let prefixDigitsCount = prefix.components(separatedBy: CharacterSet.decimalDigits.inverted)
			.joined()
			.count

		// 3. Пропускаем цифры, которые уже есть в префиксе
		let numberAfterPrefix = String(pureNumber.dropFirst(prefixDigitsCount))
		numberIndex = numberAfterPrefix.startIndex

		// 4. Берем только часть маски после префикса
		let maskAfterPrefix = String(mask.dropFirst(prefix.count))

		// 5. Применяем оставшуюся маску к оставшимся цифрам
		for maskChar in maskAfterPrefix {
			guard numberIndex < numberAfterPrefix.endIndex else { break }

			if maskChar == replacementCharacter {
				result.append(numberAfterPrefix[numberIndex])
				numberIndex = numberAfterPrefix.index(after: numberIndex)
			} else {
				result.append(maskChar)
			}
		}

		return result
	}
}
