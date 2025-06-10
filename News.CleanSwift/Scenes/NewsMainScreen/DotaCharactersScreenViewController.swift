//
//  NewsMainScreenViewController.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 09.06.2025.
//

import UIKit

protocol IMainScreenViewController: AnyObject {
	func displayCharacters(viewModel: MainScreen.ViewModel)
}

final class MainScreenViewController: UIViewController {

	// MARK: - Public properties

	// MARK: - Dependencies

	var interactor:  MainScreenInteractor?

	// MARK: - Private properties

	private lazy var charactersTableView = makeTableView()
	private lazy var refreshControl = makeRefreshControl()
	private var viewModel: MainScreen.ViewModel?

	// MARK: - Initialization

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		print("viewDidLoad")
		super.viewDidLoad()
		setupUI()
		fetchData()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}
	// MARK: - Public methods

	// MARK: - Private methods

	private func fetchData() {
		interactor?.fetchCharacters()
	}
}

//MARK: - IDotaCharactersScreenViewController

extension MainScreenViewController: IMainScreenViewController {
	func displayCharacters(viewModel: MainScreen.ViewModel) {
		self.viewModel = viewModel
		self.charactersTableView.reloadData()
	}
}

//MARK: - SetupUI

private extension MainScreenViewController {
	func setupUI() {
		view.backgroundColor = .white
		title = "Dev Exam"
	}

	func makeRefreshControl() -> UIRefreshControl {
		let refreshControl = UIRefreshControl()
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .refresh,
			target: self,
			action: #selector(refreshData)
		)
		refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

		return refreshControl
	}

	func makeTableView() -> UITableView {
		let tableView = UITableView()
		tableView.register(
			DotaCharactersTableViewCell.self,
			forCellReuseIdentifier:DotaCharactersTableViewCell.reuseIdentifier
		)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 200
		tableView.refreshControl = refreshControl

		tableView.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(tableView)
		tableView.frame = view.bounds

		return tableView
	}

	@objc func refreshData() {

	}
}

//MARK: - Layout

private extension MainScreenViewController {
	func layout() {
		NSLayoutConstraint.activate(
			[
			charactersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
			charactersTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			charactersTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
			charactersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		]
		)
	}
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let viewModel = viewModel else { return 0 }
		return viewModel.posts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: DotaCharactersTableViewCell.reuseIdentifier,
			for: indexPath
		) as? DotaCharactersTableViewCell else {
			return UITableViewCell()
		}

		guard let viewModel = viewModel else { return UITableViewCell() }
		cell.configure(with: viewModel.posts[indexPath.row])

		return cell
	}
}
