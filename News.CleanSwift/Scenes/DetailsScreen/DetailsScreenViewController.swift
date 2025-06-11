//
//  DetailsScreenViewController.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 11.06.2025.
//

import UIKit

protocol IDetailScreenViewController: AnyObject {
	func setImage(with data: Data)
}

final class DetailScreenViewController: UIViewController {
	// MARK: - Public properties
	let viewModel: Post
	// MARK: - Dependencies
	
	var interactor: IDetailScreenInteractor?

	// MARK: - Private properties

	private lazy var dateLabel = makeLabel(with: viewModel.formattedDate)
	private lazy var titleLabel = makeLabel(with: viewModel.title)
	private lazy var imageView = makeImageView()
	private lazy var postDetailLabel = makeLabel(with: viewModel.text)

	// MARK: - Initialization

	init(viewModel: Post) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle
	// MARK: - Public methods
	// MARK: - Private methods

    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}
}

//MARK: - SetupUI
private extension DetailScreenViewController {
	func setupUI() {
		view.backgroundColor = .white
		interactor?.fetchImage(with: DetailScreen.Request(url: viewModel.image))

		[dateLabel, titleLabel, imageView, postDetailLabel].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
	}

	func makeLabel(with string: String) -> UILabel {
		let label = UILabel()
		label.text = string

		switch string {
		case viewModel.formattedDate:
			label.font = UIFont.systemFont(ofSize: 12)
			label.textColor = .gray
		case viewModel.title:
			label.font = UIFont.boldSystemFont(ofSize: 16)
			label.numberOfLines = 0
			label.textColor = .black
		default:
			label.font = UIFont.systemFont(ofSize: 14)
			label.numberOfLines = 0
			label.textColor = .black
		}
		return label
	}

	func makeImageView() -> UIImageView {
		let imageView = UIImageView()
		
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true

		return imageView
	}
}

//MARK: Layout

private extension DetailScreenViewController {
	func layout() {
		NSLayoutConstraint.activate(
			[
				dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
				dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),

				titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
				titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
				titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

				imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
				imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
				imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
				imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
				imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.8),

				postDetailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
				postDetailLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
				postDetailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
				postDetailLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
			]
		)
	}
}

//MARK: - IDetailScreenViewController

extension DetailScreenViewController: IDetailScreenViewController {
	func setImage(with data: Data) {
		imageView.image = UIImage(data: data)
	}
}
