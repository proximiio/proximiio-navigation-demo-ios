//
//  PreviewRouteDataSource.swift
//  Full
//
//  Created by dev on 1/4/21.
//  Copyright © 2021 dev. All rights reserved.
//

import Combine
import Proximiio
import ProximiioMapbox
import UIKit

class PreviewRouteDataSource: NSObject {
    // MARK: - Public
    public var action = PassthroughSubject<Action, Never>()
    public var route: PIORoute? {
        didSet {
            instructions = route?.nodeList ?? []
        }
    }
    public var isFullView = false
    public var isShowTrip = false
    public var isViaParking = false
    public var waypoints: [PIOWaypoint] = []
    public var feature: ProximiioGeoJSON?

    // MARK: - Private
    private var instructions: [PIORouteNode] = []
}

// MARK: - Data source
extension PreviewRouteDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let hasOpening = (feature?.jsonValue?["properties"]["metadata"]["openHours"].string != nil) ? 1 :0
        let hasLink = (feature?.jsonValue?["properties"]["metadata"]["link"]["url"].string != nil) ? 1 : 0
        let hasImages = (feature?.images.isEmpty ?? false) ? 0 : 1
        let hasDescription = (feature?.jsonValue?["properties"]["metadata"]["description"][Locale.current.languageCode ?? "en"].string != nil) ? 1 : 0

        let hasDetails = (hasOpening == 1 || hasLink == 1 || hasImages == 1 || hasDescription == 1) ? 1 :0

        switch section {
        case 0:
            return isFullView ? hasImages : 0
        case 2:
            return isFullView ? 0 : hasDetails
        case 3:
            return isFullView ? hasDescription : 0
        case 4:
            return isFullView ? hasOpening : 0
        case 5:
            return isFullView ? hasLink : 0
        case 6:
            return isShowTrip ? instructions.count : 0
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {

        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCellGallery.identifier) as? PreviewCellGallery {
                cell.populate(images: feature?.images ?? [])
                return cell
            }

        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCellStats.identifier) as? PreviewCellStats {
                let distance = route?.nodeList.reduce(0.0) { (acc, feature) -> Double in
                    return acc + feature.distanceFromLastNode
                } ?? 0

                cell.populate(
                    name: feature?.getTitle(),
                    description: feature?.floorReadable,
                    distance: distance)
                cell.selectionStyle = .none
                return cell
            }

        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCellShowDetail.identifier) as? PreviewCellShowDetail {
                cell.buttonShoMoreDetail.onTap { [weak self] in
                    self?.action.send(.expand)
                }
                return cell
            }

        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCellDescription.identifier) as? PreviewCellDescription {
                cell.populate(
                    descr: feature?.jsonValue?["properties"]["metadata"]["description"][Locale.current.languageCode ?? "en"].stringValue ?? ""
                )
                return cell
            }

        case 4:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCellTimetable.identifier) as? PreviewCellTimetable {
                let weekDay = Date.todayDayOfWeek
                if let opening = feature?.jsonValue?["properties"]["metadata"]["openHours"]["\(weekDay)"][Locale.current.languageCode ?? "en"].string {
                    cell.textLabel?.text = opening
                }
                return cell
            }

        case 5:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCellLink.identifier) as? PreviewCellLink {
                cell.populate(link: feature?.jsonValue?["properties"]["metadata"]["link"])
                return cell
            }
        case 6:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCellDirection.identifier) as? PreviewCellDirection {
                if let node = instructions[optional: indexPath.row] {
                    cell.setup(step: node)
                }
                return cell
            }
        case 7:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCellTakeMe.identifier) as? PreviewCellTakeMe {
                cell.buttonTakeMeThere.onTap {
                    if let feature = self.feature, let route = self.route {
                        self.action.send(.start(feature, route))
                    }
                }
                return cell
            }
        case 8:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCellNearRoute.identifier) as? PreviewCellNearRoute {
                cell.buttonNearestParking.isSelected = isViaParking
                cell.buttonNearestParking.onTap {
                    guard let feature = self.feature else { return }
                    self.action.send(.parking(feature))
                }
                cell.buttonShowRoute.isSelected = isShowTrip
                cell.buttonShowRoute.onTap {
                    self.action.send(.showTrip)
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

// MARK: - Action
extension PreviewRouteDataSource {
    enum Action {
        case cancel
        case showTrip
        case parking(ProximiioGeoJSON)
        case start(ProximiioGeoJSON, PIORoute?)
        case expand
    }
}
