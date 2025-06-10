//
//  SortScreenViewController.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 10.06.2025.
//

import UIKit

protocol ISortScreenViewController: AnyObject {
	func displaySelectedSort(viewModel: SortScreen.SelectSort.ViewModel)
}

final class SortScreenViewController: UIViewController {
	// MARK: - Public properties
	// MARK: - Dependencies

	var interactor: ISortScreenInteractor?

	private let sortOptions = [
		("По умолчанию", SortScreen.SortType.defaultByServer),
		("По дате", SortScreen.SortType.byDate)
	]

	private var selectedType: SortScreen.SortType

	private var onDismiss: ((SortScreen.SortType) -> Void)?


	// MARK: - Private properties
	private lazy var sortLabel: UILabel = {
		let label = UILabel()
		label.text = "Сортировка"
		label.textColor = .black
		label.font = .systemFont(ofSize: 14, weight: .semibold)
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var sortTableView = makeTableView()

	private var panGestureRecognizer: UIPanGestureRecognizer!
	private var initialTouchPoint: CGPoint = .zero

	// MARK: - Initialization

	init(selectedType: SortScreen.SortType, onDismiss: @escaping (SortScreen.SortType) -> Void) {
		self.selectedType = selectedType
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupUI()
		setupPanGesture()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}
	// MARK: - Public methods
	// MARK: - Private methods

	@objc private func defaultSortTapped() {
		interactor?.selectSort(request: SortScreen.SelectSort.Request(sortType: SortScreen.SortType.defaultByServer))
	}

	@objc private func byDatelSortTapped() {
		interactor?.selectSort(request: SortScreen.SelectSort.Request(sortType: SortScreen.SortType.byDate))
	}

	private func setupPanGesture() {
		panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
		view.addGestureRecognizer(panGestureRecognizer)
	}

	@objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
		dismiss(animated: true)
	}
}

//MARK: - ISortScreenViewController

extension SortScreenViewController: ISortScreenViewController {
	func displaySelectedSort(viewModel: SortScreen.SelectSort.ViewModel) {
		onDismiss?(viewModel.selectedType)
		dismiss(animated: true)
	}
}

//MARK: - SetupUI

extension SortScreenViewController {
	func setupUI() {
		view.addSubview(sortLabel)
		view.addSubview(sortTableView)
	}

	private func makeTableView() -> UITableView {
		let tableView = UITableView()
		tableView.register(SortTableViewCell.self, forCellReuseIdentifier: SortTableViewCell.reuseIdentifier)
		tableView.rowHeight = 44 // Фиксированная высота ячейки
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}
}

//MARK: - Layout

private extension SortScreenViewController {
	func layout() {
		NSLayoutConstraint.activate(
			[
				sortLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
				sortLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
				sortLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

				sortTableView.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: 16),
				sortTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				sortTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				sortTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			]
		)
	}
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SortScreenViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: SortTableViewCell.reuseIdentifier,
			for: indexPath
		) as? SortTableViewCell else {
			return UITableViewCell()
		}

		let (title, type) = sortOptions[indexPath.row]
		cell.configure(with: title, isSelected: type == selectedType)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedType = sortOptions[indexPath.row].1
		tableView.reloadData()

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.onDismiss?(self.selectedType)
			self.dismiss(animated: true)
		}
	}
}
