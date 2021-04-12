//
//  Theme.swift
// Full
//
//  Created by dev on 11/3/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import Hex

enum ThemeObject {
    case text
    case background
    case icon
}

enum ThemeModal {
    case title
    case subtitle
    case distance
    case buttonTakeMe(_ what: ThemeObject)
    case buttonPark(_ what: ThemeObject)
    case butttonClose(_ what: ThemeObject)
    case buttonShowRoute(_ what: ThemeObject)
}

enum Theme {

    case green
    case yellow
    case blueDarker
    case blueMid
    case white
    case gray
    case black
    case red

    case modal(_ what: ThemeModal)
    case searchBar(_ what: ThemeObject)
    case mapButton(_ what: ThemeObject)
    case floorDropdown(_ what: ThemeObject)

    case amenity(_ identifier: String)

    case buttonStart
    case buttonShowTrip
    case buttonCancelRoute

    case backgroundNavigationHazard
    case backgroundNavigationCurrent
    case backgroundNavigationNext
    case collapseIcon
    
    case background(Tone)
    case text(Tone)
}

enum Tone {
    case light
    case dark
}

extension Theme {
    var value: UIColor {
        // swiftlint:disable implicit_getter
        get {
            switch self {

            case .green: return UIColor(hex: "9EEE92")
            case .yellow: return UIColor(hex: "E2CE19")
            case .blueDarker: return UIColor(hex: "004B8A")
            case .blueMid: return UIColor(hex: "4F86C3")
            case .white: return UIColor(hex: "FFFFFF")
            case .gray: return UIColor(hex: "000000").withAlphaComponent(0.2)
            case .black: return UIColor(hex: "000000")
            case .red: return UIColor(hex: "ED246C")
                
            case .text(let tone):
                switch tone {
                case .dark: return Theme.black.value
                case .light: return Theme.white.value
                }

            case .background(let tone):
                switch tone {
                case .dark: return Theme.black.value
                case .light: return Theme.white.value
                }
                
            case .searchBar(let what):
                switch what {
                case .text:
                    return Theme.blueDarker.value
                case .background:
                    return Theme.white.value
                default:
                    return Theme.white.value
                }

            case .floorDropdown(let what):
                switch what {
                case .icon:
                    return Theme.blueDarker.value
                case .background:
                    return Theme.green.value
                default:
                    return Theme.white.value
                }
                
            case .mapButton(let what):
                switch what {
                case .background:
                    return Theme.green.value
                default:
                    return Theme.blueDarker.value
                }

            case .modal(let object):
                switch object {
                case .title:
                    return Theme.blueDarker.value
                case .subtitle:
                    return Theme.black.value
                case .distance:
                    return Theme.blueDarker.value
                case .buttonTakeMe(let what):
                    switch what {
                    case .background:
                        return Theme.green.value
                    default:
                        return Theme.blueDarker.value

                    }
                case .buttonPark(let what):
                    switch what {
                    case .background:
                        return Theme.blueMid.value
                    default:
                        return Theme.white.value

                    }
                case .buttonShowRoute(let what):
                    switch what {
                    case .background:
                        return Theme.gray.value
                    default:
                        return Theme.blueDarker.value

                    }
                case .butttonClose(let what):
                    switch what {
                    case .background:
                        return Theme.red.value
                    default:
                        return Theme.white.value

                    }
                }

            case .amenity(let identifier):
                return getAmenityColor(identifier)

            case .buttonStart:
                return UIColor(hex: "2eb04c")
            case .buttonShowTrip:
                return UIColor(hex: "3ab3fc")
            case .buttonCancelRoute:
                return UIColor(hex: "f1144b")

            case .backgroundNavigationHazard:
                return UIColor(hex: "9C27B0")
            case .backgroundNavigationCurrent:
                return UIColor(hex: "673AB7")
            case .backgroundNavigationNext:
                return UIColor(hex: "9C27B0")
            case .collapseIcon:
                return UIColor(hex: "9C27B0")

            }
        }
    }
}

// MARK: - Amenity color
extension Theme {
    private func getAmenityColor(_ identifier: String) -> UIColor {
        switch identifier {
        // bathroom
        case "c1eaab1a-3f02-4491-a515-af8d628f74fb:20b56e81-a640-4d59-aaab-9cdbe2b353d1":
            return UIColor(hex: "005A87")
        // cafe
        case "c1eaab1a-3f02-4491-a515-af8d628f74fb:109c0242-6346-4333-b6a9-8315841a82a9":
            return UIColor(hex: "DB62B2")
        // parking
        case "c1eaab1a-3f02-4491-a515-af8d628f74fb:9da478a4-b0ce-47ba-8b44-32a4b31150a8":
            return UIColor(hex: "4F86C3")
        // exits
        case "c1eaab1a-3f02-4491-a515-af8d628f74fb:b2b59e42-de48-442c-b591-a5f8fbc5031d":
            return UIColor(hex: "8C62B6")
        // meeting rooms
        case "c1eaab1a-3f02-4491-a515-af8d628f74fb:65a02cc9-2c78-4ace-8105-5cf5b27f4a6e":
            return UIColor(hex: "71D9DE")
       
        default:
            return Theme.blueDarker.value
        }
    }
}
