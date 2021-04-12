//
//  SearchViewModel.swift
//  Full
//
//  Created by dev on 12/22/20.
//  Copyright © 2020 dev. All rights reserved.
//

import Combine
import Foundation
import Proximiio
import ProximiioMapbox

class SearchViewModel {
    @Published public var pois = PIODatabase.sharedInstance().poisAndLevelChanger()

    @Published public var filter: String?
    private var filterPublisher: AnyCancellable?

    @Published public var category = [NearBy]()
    private var categoryPublisher: AnyCancellable?

    init() {
        filterPublisher = $filter
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .sink { [weak self] value in
                self?.pois = self?.poiBy(filter: value, category: self?.category.first) ?? []
            }

        categoryPublisher = $category.sink { [weak self] value in
            self?.pois = self?.poiBy(filter: self?.filter, category: value.first) ?? []
        }
    }
}

// MARK: - Filtering
extension SearchViewModel {
    private func poiBy(filter: String?, category: NearBy?) -> [ProximiioGeoJSON] {
        return PIODatabase.sharedInstance().features(
            search: filter ?? "",
            category?.itemAmenityId ?? "",
            userLocation: UserLocation.shared.coordinate,
            filter: DemoFilter())
    }
}
