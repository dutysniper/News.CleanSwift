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
	func displayLoadingState(isLoading: Bool)
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
	private lazy var loadingIndicator = makeLoadingIndicator()
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
		showLoadingState()
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
		showLoadingState()
		interactor?.fetchCharacters()
//		charactersTableView.reloadData()
	}

	private func startAutoRefresh() {
		timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
			self?.fetchData()
		}
	}
	private func showLoadingState() {
		loadingIndicator.startAnimating()
		loadingIndicator.isHidden = false
		charactersTableView.isHidden = true
		sortButton.isHidden = true
	}

	private func hideLoadingState() {
		loadingIndicator.stopAnimating()
		loadingIndicator.isHidden = true
		charactersTableView.isHidden = false
		sortButton.isHidden = false
	}
}

//MARK: - IDotaCharactersScreenViewController

extension MainScreenViewController: IMainScreenViewController {
	func displayLoadingState(isLoading: Bool) {
		DispatchQueue.main.async { [weak self] in
			if isLoading {
				self?.showLoadingState()
			} else {
				self?.hideLoadingState()
			}
		}
	}
	
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

		DispatchQueue.main.async { [weak self] in
			self?.viewModel = viewModel
			switch viewModel.loadingState {
			case .loading:
				self?.showLoadingState()
			case .loaded:
				self?.hideLoadingState()
				self?.charactersTableView.reloadData()
			case .error(let message):
				self?.hideLoadingState()
				self?.showError(message)
			case .idle:
				break
			}

			self?.refreshControl.endRefreshing()
		}
	}

	private func showError(_ message: String) {
		let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)
	}
}

//MARK: - SetupUI

private extension MainScreenViewController {
	func setupUI() {
		view.backgroundColor = .white
		title = "Dev Exam"
	}

	func makeLoadingIndicator() -> UIActivityIndicatorView {
		let indicator = UIActivityIndicatorView(style: .large)

		indicator.color = .gray
		indicator.translatesAutoresizingMaskIntoConstraints = false
		indicator.hidesWhenStopped = true
		view.addSubview(indicator)

		return indicator
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
		viewModel = nil
		charactersTableView.reloadData()
		fetchData()
	}
}

//MARK: - Layout

private extension MainScreenViewController {
	func layout() {
		NSLayoutConstraint.activate(
			[
			loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

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
		
		switch sortType {
		case .defaultByServer:
			return viewModel.posts.count
		case .byDate:
			return viewModel.postsWithSort.count
		}
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
