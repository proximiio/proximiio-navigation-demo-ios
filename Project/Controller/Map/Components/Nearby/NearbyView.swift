//
//  NearbyView.swift
//  Full
//
//  Created by dev on 10/6/20.
//  Copyright © 2020 dev. All rights reserved.
//
import Foundation
import SnapKit
import Closures
import Proximiio
import AlignedCollectionViewFlowLayout
import Combine

let nearbyTypes = [
    NearBy(
        itemName: "amenity-bathroom".localized(),
        itemIcon: "amenity-bathroom",
        itemAmenityId: "c1eaab1a-3f02-4491-a515-af8d628f74fb:20b56e81-a640-4d59-aaab-9cdbe2b353d1"),
    NearBy(
        itemName: "amenity-cafe".localized(),
        itemIcon: "amenity-cafe",
        itemAmenityId: "c1eaab1a-3f02-4491-a515-af8d628f74fb:109c0242-6346-4333-b6a9-8315841a82a9"),
    NearBy(
        itemName: "amenity-parking".localized(),
        itemIcon: "amenity-parking",
        itemAmenityId: "c1eaab1a-3f02-4491-a515-af8d628f74fb:9da478a4-b0ce-47ba-8b44-32a4b31150a8"),
    NearBy(
        itemName: "amenity-exits".localized(),
        itemIcon: "amenity-exits",
        itemAmenityId: "c1eaab1a-3f02-4491-a515-af8d628f74fb:b2b59e42-de48-442c-b591-a5f8fbc5031d"),
    NearBy(
        itemName: "amenity-meeting-rooms".localized(),
        itemIcon: "amenity-meeting-rooms",
        itemAmenityId: "c1eaab1a-3f02-4491-a515-af8d628f74fb:65a02cc9-2c78-4ace-8105-5cf5b27f4a6e")
]

class NearbyView: UIView {
    // MARK: - UI Constants
    static let heightLabelExplore = CGFloat(16)
    static let heightCollapsed = CGFloat(81)
    
    // MARK: - Public var
    public var action = PassthroughSubject<Action, Never>()
    
    // MARK: - Private var
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.register(NearByCollectionViewCell.self,
                            forCellWithReuseIdentifier: NearByCollectionViewCell.reuseId)
        
        collection.contentInsetAdjustmentBehavior = .always
        collection.contentInset = UIEdgeInsets(
            top: 20,
            left: 10,
            bottom: 10,
            right: 10)
        
        collection.dataSource = self
        collection.delegate = self
        
        return collection
    }()
    private var gesturesActive = true
    
    private lazy var labelExplore: UILabel = {
        let label = UILabel()
        label.text = "explore_near_by".localized()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = Theme.white.value
        label.numberOfLines = 1
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
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.height.equalTo(94)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(labelExplore)
        labelExplore.snp.makeConstraints {
            $0.bottom.equalTo(collection.snp.top).offset(10)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(16)
            $0.height.equalTo(NearbyView.heightLabelExplore)
        }
        labelExplore.translatesAutoresizingMaskIntoConstraints = false
        
    }
}

// MARK: - Collection Data Source
extension NearbyView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearbyTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = nearbyTypes[indexPath.row]
        
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: NearByCollectionViewCell.reuseId,
                for: indexPath) as? NearByCollectionViewCell
        cell?.setup(item)
        return cell ?? NearByCollectionViewCell()
    }
}

// MARK: - Collection Delegate
extension NearbyView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? NearByCollectionViewCell
        else { return }
        
        if let amenity = cell.nearby {
            if amenity.itemAmenityId != nil {
                self.action.send(.filter(amenity))
            }
        }
    }
}

// MARK: - Action
extension NearbyView {
    enum Action {
        case filter(NearBy)
    }
}
