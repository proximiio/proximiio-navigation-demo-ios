//
//  SearchViewController.swift
// Full
//
//  Created by dev on 11/6/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SnapKit
import ProximiioMapLibre
import Proximiio
import Combine

class SearchViewController: UIViewController {
    
    public var action = PassthroughSubject<Action, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    private lazy var dataSource = SearchDataSource()

    public lazy var viewModel: SearchViewModel = {
        let viewModel = SearchViewModel()
        viewModel.$pois
           .receive(on: DispatchQueue.main)
           .sink { [weak self] list in
            self?.dataSource.setList(list, filter: viewModel.filter)
                self?.table.reloadData()
           }
           .store(in: &subscriptions)
        return viewModel
    }()

    private lazy var table: UITableView = {
        let table = UITableView()
        table.backgroundColor = Theme.background(.light).value
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 44
        
        table.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        table.register(SearchCellNoResult.self, forCellReuseIdentifier: SearchCellNoResult.identifier)

        table.dataSource = dataSource
        table.delegate = self
        return table
    }()

    private let stack = UIStackView()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.tintColor = Theme.background(.dark).value
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        return searchBar
    }()
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        let closeIcon = UIImage(named: "close")
        button.setImage(closeIcon?.withTintColor(Theme.text(.light).value), for: .normal)
        button.isHidden = false
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.minimumScaleFactor = 0.5
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.backgroundColor = Theme.background(.dark).value
        button.setTitleColor(Theme.text(.light).value, for: .normal)
        button.tintColor = Theme.text(.light).value
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "search_explore".localized()

        // subscribers
        setupSubscribers()

        // force background
        view.backgroundColor = .white

        // search box
        view.addSubview(stack)
        stack.axis = .horizontal
        stack.spacing = 10
        stack.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }

        stack.addArrangedSubview(categoryButton)
        stack.addArrangedSubview(searchBar)
        categoryButton.isHidden = true
        categoryButton.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
            $0.width.equalToSuperview().dividedBy(6)
        }
        
        view.addSubview(table)

        table.snp.makeConstraints {
            $0.top.equalTo(stack.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        table.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Subscriptions
extension SearchViewController {
    fileprivate func setupSubscribers() {
        setupKeyboardSubscriber()
        setupCategorySubscriber()
        setupSearchBarSubscriber()
    }

    fileprivate func setupCategorySubscriber() {
        viewModel
            .$category
            .receive(on: DispatchQueue.main)
            .sink { value in
                if let category = value.first {
                    self.categoryButton.isHidden = false
                    self.categoryButton.setImage(UIImage(named: category.itemIcon), for: .normal)
                    self.categoryButton.setTitle("x ", for: .normal)
                    if let amenityId = category.itemAmenityId {
                        self.categoryButton.backgroundColor = Theme.amenity(amenityId).value
                    }
                } else {
                    self.categoryButton.isHidden = true
                }
            }
            .store(in: &subscriptions)

        // handle category button
        categoryButton
            .publisher(for: .touchUpInside)
            .sink { _ in
                self.viewModel.category = []
            }
            .store(in: &subscriptions)
    }

    fileprivate func setupKeyboardSubscriber() {
        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .receive(on: DispatchQueue.main)
            .compactMap {
                $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { $0.height }
            .sink { [weak self] keyboardHeight in
                self?.table.snp.updateConstraints {
                    guard let bottom = self?.view.safeAreaLayoutGuide.snp.bottomMargin else { return }
                    $0.bottom.equalTo(bottom).inset(keyboardHeight)
                }
            }
            .store(in: &subscriptions)

        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.table.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin).inset(0)
                }
            }
            .store(in: &subscriptions)
    }

    fileprivate func setupSearchBarSubscriber() {
        NotificationCenter
            .default
            .publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .compactMap {
                ($0.object as? UISearchTextField)?.text
            }
            .removeDuplicates()
            .sink { text in
                self.viewModel.filter = text
            }
            .store(in: &subscriptions)
    }
}

// MARK: Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            indexPath.section == 1,
            let cell = table.cellForRow(at: indexPath) as? SearchCell,
            let feature = cell.feature
            else { return }

        self.navigationController?.popToRootViewController(animated: true)
        self.action.send(.card(feature))
    }
}

// MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}

// MARK: - Action
extension SearchViewController {
    enum Action {
        case card(ProximiioGeoJSON)
    }
}
