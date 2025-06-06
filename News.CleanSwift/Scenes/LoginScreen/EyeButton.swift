//
//  EyeButton.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 06.06.2025.
//

import UIKit

// MARK: - EyeButton
final class EyeButton: UIButton {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		setImage(UIImage(systemName: "eye"), for: .normal)
		tintColor = .gray
		contentHorizontalAlignment = .center
	}
}
