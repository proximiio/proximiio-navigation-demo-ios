//
//  PreviewRoute.swift
// Full
//
//  Created by dev on 12/20/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SnapKit
import Proximiio
import ProximiioMapLibre
import Combine

class PreviewRoute: UIView {
    // public
    public var action = PassthroughSubject<Action, Never>()
    public lazy var viewModel: PreviewRouteViewModel = {
        let viewModel = PreviewRouteViewModel()
        viewModel.$route
            .receive(on: DispatchQueue.main)
            .sink { [weak self] route in
                self?.dataSource.route = route
                self?.table.reloadData()
                self?.action.send(.levelUpdate(route?.nodeList.first?.level ?? 0))
            }.store(in: &subscriptions)

        viewModel.$feature
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feature in
                self?.dataSource.feature = feature
                self?.table.reloadData()
            }.store(in: &subscriptions)
        
        viewModel.$isFullView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFullView in
                self?.dataSource.isFullView = isFullView
                self?.table.reloadData()
            }.store(in: &subscriptions)

        viewModel.$showTrip
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showTrip in
                self?.dataSource.isShowTrip = showTrip
                self?.table.reloadData()
            }.store(in: &subscriptions)
        
        return viewModel
    }()

    // private
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var dataSource: PreviewRouteDataSource = {
        let dataSource = PreviewRouteDataSource()
        dataSource.action
            .receive(on: DispatchQueue.main)
            .sink { action in
                switch action {
                case .expand:
                    self.table.isScrollEnabled = true
                    self.viewModel.isFullView = true
                    self.action.send(.expand)
                case .showTrip:
                    self.viewModel.showTrip = !self.viewModel.showTrip
                    self.table.isScrollEnabled = self.viewModel.showTrip
                case .cancel:
                    self.table.isScrollEnabled = false
                    self.action.send(.cancel)
                case .start(let feature, let route):
                    self.table.isScrollEnabled = false
                    self.action.send(.start(feature, route))
                default: break
                }
            }.store(in: &subscriptions)
        return dataSource
    }()

    private lazy var table: UITableView = {
        let table = UITableView()
        table.separatorColor = .clear
        table.backgroundColor = Theme.background(.light).value
        table.layer.cornerRadius = 20
        table.clipsToBounds = true

        table.dataSource = dataSource

        table.estimatedRowHeight = 22
        table.rowHeight = UITableView.automaticDimension
        
        table.isScrollEnabled = false

        // setup table
        table.register(PreviewCellStats.self, forCellReuseIdentifier: PreviewCellStats.identifier)
        table.register(PreviewCellShowDetail.self, forCellReuseIdentifier: PreviewCellShowDetail.identifier)
        table.register(PreviewCellGallery.self, forCellReuseIdentifier: PreviewCellGallery.identifier)
        table.register(PreviewCellDescription.self, forCellReuseIdentifier: PreviewCellDescription.identifier)
        table.register(PreviewCellTimetable.self, forCellReuseIdentifier: PreviewCellTimetable.identifier)
        table.register(PreviewCellLink.self, forCellReuseIdentifier: PreviewCellLink.identifier)
        table.register(PreviewCellDirection.self, forCellReuseIdentifier: PreviewCellDirection.identifier)
        table.register(PreviewCellTakeMe.self, forCellReuseIdentifier: PreviewCellTakeMe.identifier)
        table.register(PreviewCellNearRoute.self, forCellReuseIdentifier: PreviewCellNearRoute.identifier)

        return table
    }()
    
    public lazy var buttonClose: UIButtonWiderTap = {
        let button = UIButtonWiderTap(type: .custom)
        button.layer.cornerRadius = 22
        button.isHidden = true
        button.clipsToBounds = true
        button.backgroundColor = Theme.red.value
        button.setImage(UIImage(named: "modal-x"), for: .normal)
        button
            .publisher(for: .touchUpInside)
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.action.send(.cancel)
            }
            .store(in: &subscriptions)
        return button
    }()

    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        
        backgroundColor = .clear
        
        addSubview(table)
        table.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(22)
        }
        
        addSubview(buttonClose)
        buttonClose.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(44)
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().inset(8)
        }
    }
}

extension PreviewRoute {
    enum Action {
        case start(ProximiioGeoJSON?, PIORoute?)
        case cancel
        case expand
        case levelUpdate(Int)
    }
}

// MARK: Helpers
extension PreviewRoute {
    func reset() {
        viewModel.route = nil
        viewModel.showTrip = false
        viewModel.feature = nil
        viewModel.isFullView = false
        table.setContentOffset(.zero, animated: false)
        table.isScrollEnabled = false
    }
}
