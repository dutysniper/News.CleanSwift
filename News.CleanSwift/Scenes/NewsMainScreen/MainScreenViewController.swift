//
//  NewsMainScreenViewController.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 09.06.2025.
//

import UIKit

protocol IMainScreenViewController: AnyObject {
	func displayCharacters(viewModel: MainScreen.ViewModel)
	func toggleSortType(sortType: SortScreen.SortType)
}

final class MainScreenViewController: UIViewController {

	// MARK: - Public properties

	var sortType = SortScreen.SortType.defaultByServer

	// MARK: - Dependencies

	var interactor:  MainScreenInteractor?

	// MARK: - Private properties

	private lazy var charactersTableView = makeTableView()
	private lazy var refreshControl = makeRefreshControl()
	private lazy var sortButton = makeButton()
	private var viewModel: MainScreen.ViewModel?
	private var timer: Timer?

	// MARK: - Initialization

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		timer?.invalidate()
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		print("viewDidLoad")
		super.viewDidLoad()
		setupUI()
		fetchData()
		startAutoRefresh()
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

	private func startAutoRefresh() {
		timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
			self?.fetchData()
		}
	}
}

//MARK: - IDotaCharactersScreenViewController

extension MainScreenViewController: IMainScreenViewController {
	func toggleSortType(sortType: SortScreen.SortType) {
		if self.sortType != sortType {
			self.sortType = sortType
			switch sortType {
			case .defaultByServer:
				sortButton.setTitle("По умолчанию ▼", for: .normal)
			case .byDate:
				sortButton.setTitle("По дате ▼", for: .normal)
			}
		}
		charactersTableView.reloadData()
	}
	
	func displayCharacters(viewModel: MainScreen.ViewModel) {
		self.viewModel = viewModel
		self.charactersTableView.reloadData()
		refreshControl.endRefreshing()
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
			PostsTableViewCell.self,
			forCellReuseIdentifier:PostsTableViewCell.reuseIdentifier
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

	func makeButton() -> UIButton {
		let button = UIButton()
		button.setTitle("По умолчанию ▼", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.addTarget(self, action: #selector(openSortScreen), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(button)

		return button
	}

	@objc func openSortScreen() {
		interactor?.openSortWindow()
	}

	@objc func refreshData() {
		fetchData()
	}
}

//MARK: - Layout

private extension MainScreenViewController {
	func layout() {
		NSLayoutConstraint.activate(
			[
			sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			sortButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),


			charactersTableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 16),
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
			withIdentifier: PostsTableViewCell.reuseIdentifier,
			for: indexPath
		) as? PostsTableViewCell else {
			return UITableViewCell()
		}

		guard let viewModel = viewModel else { return UITableViewCell() }
		
		switch sortType {
		case .defaultByServer:
			cell.configure(with: viewModel.posts[indexPath.row])
		case .byDate:
			cell.configure(with: viewModel.postsWithSort[indexPath.row])
		}
		return cell
	}
}
