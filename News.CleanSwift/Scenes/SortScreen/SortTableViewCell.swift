//
//  SortTableViewCell.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 10.06.2025.
//

import UIKit

import UIKit

final class SortTableViewCell: UITableViewCell {
	static let reuseIdentifier = "SortTableViewCell"

	// MARK: - UI Elements
	private let sortNameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
		label.textColor = .black
		return label
	}()

	private let checkmarkImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = .systemBlue
		imageView.image = UIImage(systemName: "checkmark")
		imageView.isHidden = true
		return imageView
	}()

	// MARK: - Lifecycle
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Configuration
	func configure(with title: String, isSelected: Bool) {
		contentView.backgroundColor = .white
		sortNameLabel.text = title
		checkmarkImageView.isHidden = !isSelected
		accessoryType = .none 
	}

	// MARK: - UI Setup
	private func setupUI() {
		selectionStyle = .none
		contentView.addSubview(sortNameLabel)
		contentView.addSubview(checkmarkImageView)

		sortNameLabel.translatesAutoresizingMaskIntoConstraints = false
		checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			sortNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			sortNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

			checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
			checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
		])
	}
}
