//
//  DotaCharactersTableViewCell.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 09.06.2025.
//

import UIKit
import Alamofire

final class PostsTableViewCell: UITableViewCell {
	static let reuseIdentifier = "PostTableViewCell"

	private let postImageView = UIImageView()
	private let titleLabel = UILabel()
	private let dateLabel = UILabel()
	private let phraseLabel = UILabel()


	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with character: Post) {
		titleLabel.text = character.title
		phraseLabel.text = character.text
		dateLabel.text = character.formattedDate
		loadImage(from: character.image)
	}

	private func loadImage(from string: String) {
		let baseURL = "http://dev-exam.l-tech.ru"
		guard let url = URL(string: baseURL + string) else { return }

		URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
			if let data = data, let image = UIImage(data: data) {
				DispatchQueue.main.async {
					self?.postImageView.image = image
				}
			}
		}.resume()
	}

	private func setupViews() {
		[postImageView, titleLabel, dateLabel, phraseLabel].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview($0)
		}

		postImageView.contentMode = .scaleAspectFit
		postImageView.clipsToBounds = true

		titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
		titleLabel.numberOfLines = 0

		dateLabel.font = UIFont.systemFont(ofSize: 12)
		dateLabel.textColor = .gray

		phraseLabel.font = UIFont.systemFont(ofSize: 14)
		phraseLabel.numberOfLines = 3

		NSLayoutConstraint.activate([
			postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			postImageView.widthAnchor.constraint(equalToConstant: 60),
			postImageView.heightAnchor.constraint(equalToConstant: 60),

			titleLabel.topAnchor.constraint(equalTo: postImageView.topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: 12),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

			phraseLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
			phraseLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			phraseLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

			dateLabel.topAnchor.constraint(equalTo: phraseLabel.bottomAnchor, constant: 8),
			dateLabel.leadingAnchor.constraint(equalTo: phraseLabel.leadingAnchor),
			dateLabel.trailingAnchor.constraint(equalTo: phraseLabel.trailingAnchor),
			dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
		])
	}
}
