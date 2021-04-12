//
//  Settings.swift
// Full
//
//  Created by dev on 11/3/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit

class Settings {
    // MARK: - Init
    static let shared = Settings()
    private init() {}

    // MARK: - Enums
    enum Side: String {
        case left, right
    }

    enum DistanceUnit: String {
        case steps, meters
    }

    enum NavigationType: Int {
        case heading, path
    }

    enum Disability: String {
        case vision, hearing, neurodiverse, ambulant, wheelchair, none
    }

    // MARK: - Keys
    private let accessibilityUISideKey = "Demo_settings_accessibility_uiside"
    private let accessibilityCallForHelp = "Demo_settings_accessibility_callforhelp_button"
    private let accessibilityCallForHelpKey = "Demo_settings_accessibility_call_for_help"
    private let guidanceStatusKey = "Demo_settings_guidance_status"
    private let feedbackVibration = "Demo_settings_feedback_vibration_status"
    private let routeAvoidStairsKey = "Demo_settings_route_avoid_stairs"
    private let routeAvoidElevetorKey = "Demo_settings_route_avoid_elevator"
    private let routeAvoidEscalatorKey = "Demo_settings_route_avoid_escalator"
    private let routeAvoidBarrierKey = "Demo_settings_route_avoid_barrier"
    private let routeAvoidRampsKey = "Demo_settings_route_avoid_ramps"
    private let routeAvoidRevolvingDoorsKey = "Demo_settings_route_avoid_revolving_doors"
    private let routeAvoidTicketGatesKey = "Demo_settings_route_avoid_ticket_gates"
    private let routeAccessibleKey = "Demo_settings_route_accessible"
    private let navigationTypeKey = "Demo_settings_navigation_type"

    private let routeDistanceUnitsKey = "Demo_settings_route_distance_unit"
    private let voiceGuidanceKey = "Demo_settings_voice_guidance"
    private let voiceDuringCallKey = "Demo_settings_voice_during_call"
    private let voiceSpeakReassuranceDistanceKey = "Demo_settings_voice_speak_reassurance_distance"

    private let voiceGuidanceConfirmKey = "Demo_settings_voice_guidance_confirm"
    private let voiceGuidanceDecisionKey = "Demo_settings_voice_guidance_speak_decision"
    private let voiceGuidanceHazardKey = "Demo_settings_voice_guidance_speak_hazard"
    private let voiceGuidanceLandmarkKey = "Demo_settings_voice_guidance_speak_landmark"
    private let voiceGuidanceSegmentKey = "Demo_settings_voice_guidance_speak_segment"
    private let voiceGuidanceWarningKey = "Demo_settings_voice_guidance_speak_warning"

    private let voiceGuidanceConfirmTripKey = ""
    private let voiceGuidanceConfirmTripDistanceKey = ""

    private let shakyHandsKey = "Demo_shaky_hands"
    private let accDisablities = "Demo_acc_disabilities"

    // MARK: - Helpers

    // app locale
    var locale: String { return Locale.current.languageCode ?? "en" }

    // handles current UI orientation
    var accessibilityUISide: Side {
        get {
            if let value = UserDefaults.standard.object(forKey: accessibilityUISideKey) as? String {

                if let test = Side(rawValue: value) {
                    return test
                }

                if value == "settings_left".localized() {
                    return .left
                } else {
                    return .right
                }
            }
            return .right
        }
        set(value) {
            UserDefaults.standard.set(value.rawValue, forKey: accessibilityUISideKey)
        }
    }

    var accessibilityDisabilities: Int {
        get {
            return UserDefaults.standard.value(forKey: accDisablities) as? Int ?? 5
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: accDisablities)
        }
    }

    // MARK: - Feedback & vibration
    // handles vibrate status for notification
    var vibrationEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: guidanceStatusKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: guidanceStatusKey)
        }
    }

    // MARK: - Guidance
    // handles guidance status
    var guidanceEnabled: Bool {
        get {
            return UserDefaults.standard.value(forKey: guidanceStatusKey) as? Bool ?? true
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: guidanceStatusKey)
        }

    }

    // MARK: - Avoid
    // handles avoid escalator
    var avoidEscalator: Bool {
        get {
            return UserDefaults.standard.bool(forKey: routeAvoidEscalatorKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: routeAvoidEscalatorKey)
        }
    }

    // handles avoid evalator
    var avoidElevator: Bool {
        get {
            return UserDefaults.standard.bool(forKey: routeAvoidElevetorKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: routeAvoidElevetorKey)
        }
    }

    // handles avoid stairs
    var avoidStairs: Bool {
        get {
            return UserDefaults.standard.bool(forKey: routeAvoidStairsKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: routeAvoidStairsKey)
        }
    }

    // handles avoid barriers
    var avoidBarriers: Bool {
        get {
            return UserDefaults.standard.bool(forKey: routeAvoidBarrierKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: routeAvoidBarrierKey)
        }
    }

    // handles avoid ramps
    var avoidRamps: Bool {
        get {
            return UserDefaults.standard.bool(forKey: routeAvoidRampsKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: routeAvoidRampsKey)
        }
    }

    // handles avoid revolving doors
    var avoidRevolvingDoors: Bool {
        get {
            return UserDefaults.standard.bool(forKey: routeAvoidRevolvingDoorsKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: routeAvoidRevolvingDoorsKey)
        }
    }

    // handles avoid ticket gates
    var avoidTicketGates: Bool {
        get {
            return UserDefaults.standard.bool(forKey: routeAvoidTicketGatesKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: routeAvoidTicketGatesKey)
        }
    }

    var accessibleRoute: Bool {
        get {
            return UserDefaults.standard.bool(forKey: routeAccessibleKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: routeAccessibleKey)
        }
    }

    var routeDistanceUnits: DistanceUnit {
        get {
            if let value = UserDefaults.standard.object(forKey: routeDistanceUnitsKey) as? String {
                if value == "steps" {
                    return .steps
                } else {
                    return .meters
                }
            }
            return .meters
        }
        set(value) {
            UserDefaults.standard.set(value.rawValue, forKey: routeDistanceUnitsKey)
        }
    }

    var navigationType: NavigationType {
        get {
            if let value = UserDefaults.standard.object(forKey: navigationTypeKey) as? Int {
                if value == 0 {
                    return .heading
                } else {
                    return .path
                }
            }
            return .heading
        }
        set(value) {
            UserDefaults.standard.set(value.rawValue, forKey: navigationTypeKey)
        }
    }

    var callForHelp: Bool {
        get {
            return UserDefaults.standard.bool(forKey: accessibilityCallForHelpKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: accessibilityCallForHelpKey)
        }
    }

    // MARK: - Guidance
    var voiceGuidance: Bool {
        get {
            return UserDefaults.standard.bool(forKey: voiceGuidanceKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: voiceGuidanceKey)
        }
    }

    var voiceGuidanceDuringCall: Bool {
        get {
            return UserDefaults.standard.bool(forKey: voiceDuringCallKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: voiceDuringCallKey)
        }
    }

    var voiceGuidanceConfirm: Bool {
        get {
            return UserDefaults.standard.bool(forKey: voiceGuidanceConfirmKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: voiceGuidanceConfirmKey)
        }
    }

    var voiceGuidanceSpeakDecision: Bool {
        get {
            return UserDefaults.standard.bool(forKey: voiceGuidanceDecisionKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: voiceGuidanceDecisionKey)
        }
    }

    var voiceGuidanceSpeakWarning: Bool {
        get {
            return UserDefaults.standard.bool(forKey: voiceGuidanceWarningKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: voiceGuidanceWarningKey)
        }
    }

    var voiceGuidanceSpeakLandmark: Bool {
        get {
            return UserDefaults.standard.bool(forKey: voiceGuidanceLandmarkKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: voiceGuidanceLandmarkKey)
        }
    }

    var voiceGuidanceSpeakSegment: Bool {
        get {
            return UserDefaults.standard.bool(forKey: voiceGuidanceSegmentKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: voiceGuidanceSegmentKey)
        }
    }

    var voiceSpeakReassuranceDistance: Int {
        get {
            return UserDefaults.standard.integer(forKey: voiceSpeakReassuranceDistanceKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: voiceSpeakReassuranceDistanceKey)
        }
    }

    var voiceGuidanceConfirmTrip: Bool {
        get {
            return UserDefaults.standard.bool(forKey: voiceGuidanceConfirmTripKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: voiceGuidanceConfirmTripKey)
        }
    }

    var voiceGuidanceConfirmTripDistance: Int {
        get {
            return UserDefaults.standard.integer(forKey: voiceGuidanceConfirmTripDistanceKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: voiceGuidanceConfirmTripDistanceKey)
        }
    }

    // MARK: -
    var shakyHands: Bool {
        get {
            return UserDefaults.standard.bool(forKey: shakyHandsKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: shakyHandsKey)
            closeApp()
        }
    }

}

// MARK: - functions
extension Settings {

    func closeApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              exit(0)
             }
        }
    }
}
