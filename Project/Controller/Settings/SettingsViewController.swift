//
//  SettingsViewController.swift
//  Full
//
//  Created by dev on 11/3/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import Eureka
import Proximiio

class SettingsViewController: FormViewController {

    let optionsKey = [
        "Vision impairment",
        "Hearing impairment",
        "Neurodiverse",
        "Ambulant disabled",
        "Wheelchair users",
        "settings_guidance_disability_none"
    ]

    private func save() {
        let side = (self.form.rowBy(tag: "settings_accessibility_ui_side") as? SegmentedRow<String>)?.value ?? "right"

        let whichSide = "settings_right".localized() == side.localized() ? Settings.Side.right : Settings.Side.left
        Settings.shared.accessibilityUISide = whichSide

        Settings.shared.vibrationEnabled = (self.form.rowBy(tag: "settings_accessibility_vibrate") as? SwitchRow)?.value ?? false

        // Route
        Settings.shared.avoidStairs = (self.form.rowBy(tag: "settings_route_avoid_stairs") as? SwitchRow)?.value ?? false
        Settings.shared.avoidEscalator = (self.form.rowBy(tag: "settings_route_avoid_esclator") as? SwitchRow)?.value ?? false
        Settings.shared.avoidElevator = (self.form.rowBy(tag: "settings_route_avoid_elevator") as? SwitchRow)?.value ?? false
        Settings.shared.avoidRevolvingDoors = (self.form.rowBy(tag: "settings_route_avoid_revolving_doors") as? SwitchRow)?.value ?? false
        Settings.shared.accessibleRoute = (self.form.rowBy(tag: "settings_route_acessible") as? SwitchRow)?.value ?? false

        // Guidance
        Settings.shared.guidanceEnabled = (self.form.rowBy(tag: "settings_voice_guidance") as? SwitchRow)?.value ?? false

        let localizedOptions = self.optionsKey.map({ item -> String in
            return item.localized()
        })
        let selectedMeta = (self.form.rowBy(tag: "settings_accessibility_disabilities") as? PushRow<String>)?.value ?? localizedOptions[localizedOptions.count - 1]

        let index = localizedOptions.firstIndex(of: selectedMeta) ?? localizedOptions.count - 1
        Settings.shared.accessibilityDisabilities = index

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // UI setup
        SwitchRow.defaultCellSetup = { cell, row in row.cell.textLabel?.font = .preferredFont(forTextStyle: .headline)}
        LabelRow.defaultCellSetup = { cell, row in row.cell.textLabel?.font = .preferredFont(forTextStyle: .headline)}
        SegmentedRow<String>.defaultCellSetup = { cell, row in row.cell.textLabel?.font = .preferredFont(forTextStyle: .body)}
        PushRow<String>.defaultCellSetup = { cell, row in
            row.cell.textLabel?.font = .preferredFont(forTextStyle: .headline)
            ButtonRow.defaultCellSetup = { cell, row in
                row.cell.contentView.backgroundColor = Theme.blueDarker.value
                cell.tintColor = Theme.white.value
            }
        }

        title = "settings_title".localized()

        view.tintColor = Theme.background(.dark).value

        // force tint for the whole form
        self.view.tintColor = Theme.background(.dark).value

        form
            +++ ButtonRow {
                $0.title = "settings_save".localized()
            }.onCellSelection({ [weak self] _, _ in
                self?.save()
                self?.dismiss(animated: true)
            })
            // Display Options
            +++ Section { section in
                var header = HeaderFooterView<UITextView>(.class)
                header.height = { 40.0 }
                header.onSetupView = { view, _ in
                    view.text = "settings_display_mode".localized()
                    view.textColor = Theme.background(.dark).value
                    view.font = .preferredFont(forTextStyle: .title1)
                    view.backgroundColor = .clear
                    view.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
                    view.isEditable = false
                    view.isSelectable = false
                }
                section.header = header
            }
            <<< LabelRow {
                $0.title="settings_navigation_type".localized()
            }
            <<< SegmentedRow<String>("settings_navigation_type") {
                $0.title = ""
                $0.options = ["settings_navigation_compass".localized(), "settings_navigation_heading".localized()]
                $0.value = Settings.shared.navigationType == .heading ? "settings_navigation_compass".localized() : "settings_navigation_heading".localized()
                $0.onChange { row in
                    if row.value == "settings_navigation_compass".localized() {
                        Settings.shared.navigationType = .heading
                    } else {
                        Settings.shared.navigationType = .path
                    }
                }
            }

            // Route
            +++ Section { section in
                var header = HeaderFooterView<UITextView>(.class)
                header.height = { 30.0 }
                header.onSetupView = { view, _ in
                    view.text = "settings_route_options".localized()
                    view.textColor = Theme.background(.dark).value
                    view.font = .preferredFont(forTextStyle: .title1)
                    view.backgroundColor = .clear
                    view.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
                    view.isEditable = false
                    view.isSelectable = false
                }
                section.header = header
            }
            <<< SwitchRow("settings_route_avoid_stairs") {
                $0.title = "settings_avoid_stairs".localized()
                $0.value = Settings.shared.avoidStairs
            }

            <<< SwitchRow("settings_route_avoid_revolving_doors") {
                $0.title = "settings_avoid_revolving_doors".localized()
                $0.value = Settings.shared.avoidRevolvingDoors
            }
            <<< SwitchRow("settings_route_acessible") {
                $0.title = "settings_use_acessible_routes".localized()
                $0.value = Settings.shared.accessibleRoute
            }
            <<< SegmentedRow<String>("settings_route_units") {
                $0.title = "settings_distance".localized()
                $0.options = ["settings_distance_steps".localized(), "settings_distance_meters".localized()]
                $0.value = Settings.shared.routeDistanceUnits == .steps ? "settings_distance_steps".localized() : "settings_distance_meters".localized()
                $0.onChange { row in
                    if row.value == "settings_distance_steps".localized() {
                        Settings.shared.routeDistanceUnits = .steps
                    } else {
                        Settings.shared.routeDistanceUnits = .meters
                    }
                }
            }

            // Voice guidance
            +++ Section(header: "settings_voice_guidance", footer: "") { section in
                var header = HeaderFooterView<UITextView>(.class)
                header.height = { 30.0 }
                header.onSetupView = { view, _ in
                    view.text = "settings_voice_notification".localized()
                    view.textColor = Theme.background(.dark).value
                    view.font = .preferredFont(forTextStyle: .title1)
                    view.backgroundColor = .clear
                    view.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
                    view.isEditable = false
                    view.isSelectable = false
                }
                section.header = header
            }
            <<< SwitchRow("settings_voice_guidance") {
                $0.title = "settings_voice_guidance".localized()
                $0.value = Settings.shared.guidanceEnabled
            }
            <<< SwitchRow("settings_voice_guidance_confirm") {
                $0.title = "settings_voice_confirm".localized()
                $0.value = Settings.shared.voiceGuidanceConfirm
                $0.hidden = Condition.function(["settings_voice_guidance"], { form in
                    return !((form.rowBy(tag: "settings_voice_guidance") as? SwitchRow)?.value ?? false)
                })
                $0.onChange { row in
                    let newValue = row.value ?? false
                    Settings.shared.voiceGuidanceConfirm = newValue
                }
            }
            <<< SwitchRow("settings_voice_guidance_speak_decision") {
                $0.title = "settings_voice_speak_decision".localized()
                $0.value = Settings.shared.voiceGuidanceSpeakDecision
                $0.hidden = Condition.function(["settings_voice_guidance"], { form in
                    return !((form.rowBy(tag: "settings_voice_guidance") as? SwitchRow)?.value ?? false)
                })
                $0.onChange { row in
                    let newValue = row.value ?? false
                    Settings.shared.voiceGuidanceSpeakDecision = newValue
                }
            }
            <<< SwitchRow("settings_voice_guidance_speak_hazard_warning") {
                $0.title = "settings_voice_speak_hazard".localized()
                $0.value = Settings.shared.voiceGuidanceSpeakWarning
                $0.hidden = Condition.function(["settings_voice_guidance"], { form in
                    return !((form.rowBy(tag: "settings_voice_guidance") as? SwitchRow)?.value ?? false)
                })
                $0.onChange { row in
                    let newValue = row.value ?? false
                    Settings.shared.voiceGuidanceSpeakWarning = newValue
                }
            }
            <<< SwitchRow("settings_voice_guidance_speak_landmark") {
                $0.title = "settings_voice_speak_landmark".localized()
                $0.value = Settings.shared.voiceGuidanceSpeakLandmark
                $0.hidden = Condition.function(["settings_voice_guidance"], { form in
                    return !((form.rowBy(tag: "settings_voice_guidance") as? SwitchRow)?.value ?? false)
                })
                $0.onChange { row in
                    let newValue = row.value ?? false
                    Settings.shared.voiceGuidanceSpeakLandmark = newValue
                }
            }
            <<< SwitchRow("settings_voice_guidance_speak_segment") {
                $0.title = "settings_voice_speak_segment".localized()
                $0.value = Settings.shared.voiceGuidanceSpeakSegment
                $0.hidden = Condition.function(["settings_voice_guidance"], { form in
                    return !((form.rowBy(tag: "settings_voice_guidance") as? SwitchRow)?.value ?? false)
                })
                $0.onChange { row in
                    let newValue = row.value ?? false
                    Settings.shared.voiceGuidanceSpeakSegment = newValue
                }
            }

            <<< SwitchRow("settings_voice_guidance_confirm_trip") {
                $0.title = "settings_voice_confirm_trip".localized()
                $0.value = Settings.shared.voiceGuidanceConfirmTrip
                $0.hidden = Condition.function(["settings_voice_guidance"], { form in
                    return !((form.rowBy(tag: "settings_voice_guidance") as? SwitchRow)?.value ?? false)
                })
                $0.onChange { row in
                    let newValue = row.value ?? false
                    Settings.shared.voiceGuidanceConfirmTrip = newValue
                }
            }
//            <<< PushRow<String>("settings_voice_guidance_confirm_trip_distance") {
//                $0.title = "settings_voice_confirm_trip_every".localized()
//                $0.options = [
//                    "settings_voice_10_meter".localized(),
//                    "settings_voice_15_meter".localized(),
//                    "settings_voice_20_meter".localized(),
//                    "settings_voice_25_meter".localized()
//                ]
//                $0.value = $0.options?[Settings.shared.voiceGuidanceConfirmTripDistance].localized()
//                $0.hidden = Condition.function(["settings_voice_guidance_confirm_trip"], { form in
//                    return !((form.rowBy(tag: "settings_voice_guidance_confirm_trip") as? SwitchRow)?.value ?? false)
//                })
//                $0.onChange { row in
//                    var index  = 0
//                    row.options?.enumerated().forEach({ (offset, element) in
//                        if element == row.value {
//                            index = offset
//                        }
//                    })
//
//                    Settings.shared.voiceGuidanceConfirmTripDistance = index
//                }
//            }

            // UI accessibility
            +++ Section { section in
                var header = HeaderFooterView<UITextView>(.class)
                header.height = { 30.0 }
                header.onSetupView = { view, _ in
                    view.text = "settings_accessitibility".localized()
                    view.textColor = Theme.background(.dark).value
                    view.font = .preferredFont(forTextStyle: .title1)
                    view.backgroundColor = .clear
                    view.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
                    view.isEditable = false
                    view.isSelectable = false
                }
                section.header = header
            }
            <<< SwitchRow("settings_accessibility_vibrate") {
                $0.title = "settings_vibrate".localized()
                $0.value = Settings.shared.vibrationEnabled
            }
            <<< SegmentedRow<String>("settings_accessibility_ui_side") {
                $0.title = "settings_hand_mode".localized()
                $0.options = ["settings_left".localized(), "settings_right".localized()]
                $0.value = Settings.shared.accessibilityUISide == .right ? "settings_right".localized() : "settings_left".localized()
            }
            <<< PushRow<String>("settings_accessibility_disabilities") {

                $0.title = "settings_guidance_disability".localized()
                $0.options = optionsKey.map({ item -> String in
                    return item.localized()
                })

                let selectedIndex = Settings.shared.accessibilityDisabilities
                let selectedValues =  optionsKey[selectedIndex].localized()

                $0.value = selectedValues

                $0.disabled = false
            }

        for section in form.allSections {
            section.reload()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutSubviews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        save()
    }
}
