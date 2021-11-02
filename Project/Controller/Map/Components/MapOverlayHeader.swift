//
//  MapSearchButtonView.swift
// Full
//
//  Created by dev on 11/4/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SnapKit
import Closures
import ProximiioMapbox
import Proximiio
import Combine
import DropDown

// helper to move data accross multiple view with all the info about update (texts and adata)
typealias PIORouteUpdateDataPackage = (PIORouteUpdateType, String?, String?, PIORouteUpdateData?)

class MapOverlayHeader: UIView {
    private var subscriptions = Set<AnyCancellable>()
    public var action = PassthroughSubject<Action, Never>()
    
    // MARK: - Constants
    static let buttonSize = CGFloat(44)
    static let largeButtonSize = CGFloat(66)
    
    // MARK: - Public variable
    public var trackingUser = true {
        didSet {
            buttonTracking.imageView?.tintColor = trackingUser ? Theme.blueDarker.value : Theme.white.value
        }
    }
    
    // @Published public var currentFloor = 0
    public var currentFloor = 0
    private var _floorsCached = [ProximiioFloor]()
    var floors: [ProximiioFloor] {
        let floor = Proximiio.sharedInstance()?.currentFloor()
        
        if _floorsCached.isEmpty || self.floor != floor {
            
            _floorsCached = (Proximiio.sharedInstance()?.floors() ?? []).filter { (flr) -> Bool in
                flr.placeId == floor?.placeId
            }.sorted { (floor, floor2) -> Bool in
                floor2.level.intValue > floor.level.intValue
            }
        }
        return _floorsCached
    }
    
    internal var floor: ProximiioFloor? {
        if let floor = Proximiio.sharedInstance()?.currentFloor() {
            return floor
        }
        return nil
    }

    public var location: ProximiioLocation? {
        didSet {
            guard let location = location else { return }
            // swiftlint:disable line_length
            labelDebug.text = "Pos: \(location.coordinate.latitude),\(location.coordinate.longitude)\nAccuracy: h\(location.horizontalAccuracy) - v\(location.verticalAccuracy)\nSource:\(location.sourceType)"
        }
    }
    
    // MARK: - Private variable
    // side buttons (support auto switch of the side according user defaults)
    private lazy var buttonTracking: UIButton = {
        let buttonTracking = UIButton()
        buttonTracking.setImage(UIImage(named: "menu-compass"), for: .normal)
        buttonTracking.backgroundColor = Theme.mapButton(.background).value
        buttonTracking.onTap {
            self.action.send(.compass)
        }
        buttonTracking.layer.cornerRadius = 20.0
        buttonTracking.clipsToBounds = true
        return buttonTracking
    }()
    private lazy var buttonCenter: UIButton = {
        let buttonCenter = UIButton()
        buttonCenter.setImage(UIImage(named: "menu-location"), for: .normal)
        buttonCenter.backgroundColor = Theme.mapButton(.background).value
        buttonCenter.onTap {
            self.action.send(.center)
        }
        buttonCenter.layer.cornerRadius = 20.0
        buttonCenter.clipsToBounds = true
        return buttonCenter
    }()
    
    private var isFloorDropdownOpen = false {
        didSet {
            floorResizeIcon.image = UIImage(named: isFloorDropdownOpen ? "floor-down" : "floor-up")
        }
    }
    private lazy var floorResizeIcon: UIImageView = {
        let image = UIImageView(image: UIImage(named: "floor-down"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    private lazy var buttonFloor: UIButton = {
        let buttonFloor = UIButton(type: .custom)
        buttonFloor.titleLabel?.font = .preferredFont(forTextStyle: .body)
        buttonFloor.setTitleColor(Theme.blueDarker.value, for: .normal)
        buttonFloor.backgroundColor = Theme.floorDropdown(.background).value
        buttonFloor.contentHorizontalAlignment = .left
        buttonFloor.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        buttonFloor.addSubview(floorResizeIcon)
        floorResizeIcon.snp.makeConstraints {
            $0.width.equalTo(16)
            $0.height.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(12)
        }
        //
        buttonFloor.onTap { [weak self] in
            self?.isFloorDropdownOpen = true
            self?.dropdown.show()
        }
        
        buttonFloor.layer.cornerRadius = 20.0
        buttonFloor.clipsToBounds = true
        
        return buttonFloor
    }()
    
    private lazy var dropdown: DropDown = {
        let dropdown = DropDown()
        dropdown.anchorView = buttonFloor
        dropdown.direction = .bottom
        dropdown.offsetFromWindowBottom = 200
        dropdown.backgroundColor = Theme.blueDarker.value
        dropdown.textColor = Theme.floorDropdown(.text).value
    
        DropDown.appearance().setupCornerRadius(20)
        
        populateFloorList()
        dropdown.selectionAction = { [unowned self] (index: Int, _: String) in
            self.action.send(.floor(self.floors[index]))
            self.isFloorDropdownOpen = false
        }
        
        if floor == nil {
            let ground = floors.firstIndex { (floor) -> Bool in
                return floor.level == 0
            }
            dropdown.selectRow(at: ground)
        }
        
        return dropdown
        
    }()
    
    // search box
    private lazy var searchView: SearchView = {
        let search = SearchView()
        return search
    }()

    private lazy var labelDebug: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = Theme.black.value
        label.numberOfLines = 0
        label.backgroundColor = .lightGray
        return label
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
    
    public func updateSettings() {
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // force cleanup
        subviews.forEach { $0.removeFromSuperview() }
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .top
        addSubview(verticalStack)
        verticalStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let actualSize = MapOverlayHeader.buttonSize
        let iconMargin = CGFloat(15)

        // add spacer
        verticalStack.addArrangedSubview(UIView.spacer(of: 10))

        verticalStack.addArrangedSubview(labelDebug)
        labelDebug.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(16)
        }
        labelDebug.translatesAutoresizingMaskIntoConstraints = false
        
        // add spacer
        verticalStack.addArrangedSubview(UIView.spacer(of: 10))
        
        // prepare the stack to keep the UI for custom searchbar and menu
        searchView = SearchView()
        verticalStack.addArrangedSubview(searchView)
        searchView.delegate = self
        searchView.snp.makeConstraints {
            $0.height.equalTo(Size.searchHeight.value).priority(.required)
            $0.left.equalToSuperview().inset(iconMargin)
            $0.right.equalToSuperview().inset(iconMargin)
        }
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        // add spacer
        verticalStack.addArrangedSubview(UIView.spacer(of: 10))
        
        setFloorDropdownTitle(floor: floor)
        verticalStack.addArrangedSubview(buttonFloor)
        buttonFloor.snp.makeConstraints {
            switch Settings.shared.accessibilityUISide {
            case .right:
                $0.right.equalToSuperview().inset(iconMargin)
            case .left:
                $0.left.equalToSuperview().inset(iconMargin)
            }
            
            $0.width.equalTo(searchView.snp.width).dividedBy(2)
            $0.height.equalTo(Size.floorHeight.value).priority(.required)
        }
        buttonFloor.translatesAutoresizingMaskIntoConstraints = false
    
        // add spacer
        verticalStack.addArrangedSubview(UIView.spacer(of: 10))
        
        // tracking button
        verticalStack.addArrangedSubview(buttonTracking)
        buttonTracking.snp.makeConstraints { (make) in
            // manage UI orientation
            switch Settings.shared.accessibilityUISide {
            case .left:
                make.left.equalToSuperview().inset(iconMargin)
                make.right.equalToSuperview().inset(UIScreen.main.bounds.width - actualSize - iconMargin)
            case .right:
                make.right.equalToSuperview().inset(iconMargin)
                make.left.equalToSuperview().inset(UIScreen.main.bounds.width - actualSize - iconMargin)
            }
            
            make.height.equalTo(actualSize).multipliedBy(1.0).priority(.required)
            make.width.equalTo(actualSize).multipliedBy(1.0).priority(.required)
        }
        
        buttonTracking.translatesAutoresizingMaskIntoConstraints = false
        
        // add spacer
        verticalStack.addArrangedSubview(UIView.spacer(of: 10))
        
        // center button
        verticalStack.addArrangedSubview(buttonCenter)
        buttonCenter.snp.makeConstraints { (make) in
            // manage UI orientation
            switch Settings.shared.accessibilityUISide {
            case .left:
                make.left.equalToSuperview().inset(iconMargin)
                make.right.equalToSuperview().inset(UIScreen.main.bounds.width - actualSize - iconMargin)
            case .right:
                make.right.equalToSuperview().inset(iconMargin)
                make.left.equalToSuperview().inset(UIScreen.main.bounds.width - actualSize - iconMargin)
            }
            
            make.height.equalTo(actualSize).multipliedBy(1.0).priority(.required)
            make.width.equalTo(actualSize).multipliedBy(1.0).priority(.required)
        }
        
        buttonCenter.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStack.addArrangedSubview(UIView())
        
    }
}

// MARK: - Floor list
extension MapOverlayHeader {
    func populateFloorList() {
        DispatchQueue.main.async {
            self.dropdown.dataSource = self.floors.map({ (floor) -> String in
                return self.generateLocalizedFloor(floor)
            })
        }
    }
    
    func setFloorDropdownTitle(floor: ProximiioFloor?) {
        DispatchQueue.main.async {
            self.buttonFloor.setTitle(self.generateLocalizedFloor(floor), for: .normal)
        }
    }
    
    private func generateLocalizedFloor(_ floor: ProximiioFloor?) -> String {
        var level = floor?.level?.intValue ?? 0
        if level >= 0 {
            level += 1
        }
        let floorText = "floor_\(level)".localized()
//        return floorText
        return floor?.name ?? floorText
    }
}

// MARK: - SearchViewDelegate
extension MapOverlayHeader: SearchViewDelegate {
    func didTapSearchField() {
        openSearchField()
    }
}

// MARK: - Allow touches to pass
extension MapOverlayHeader {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event) {
            return self.subviews.contains(view) ? nil : view
        }
        return nil
    }
}

// MARK: - Helpers
extension MapOverlayHeader {
    private func openSearchField(text: String? = nil, category: NearBy? = nil) {
        let searchViewController = SearchViewController()
        searchViewController.modalPresentationStyle = .fullScreen
        searchViewController
            .action
            .sink { [weak self] action in
                switch action {
                case .card(let feature):
                    self?.action.send(.select(feature))
                    
                }
            }.store(in: &subscriptions)
        
        if let text = text {
            searchViewController.viewModel.filter = text
        }
        
        if let category = category {
            searchViewController.viewModel.category = [category]
        }
        
        action.send(.search(text, category))
    }
}

// MARK: - Action
extension MapOverlayHeader {
    enum Action {
        case center
        case compass
        case select(ProximiioGeoJSON)
        case search(String?, NearBy?)
        case floor(ProximiioFloor)
    }
}
