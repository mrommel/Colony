//
//  CityStateViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 28.02.22.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol CityStateViewModelDelegate: AnyObject {

    func assignEnvoy(to cityState: CityStateType) -> Bool
    func unassignEnvoy(from cityState: CityStateType) -> Bool
    func center(on cityState: CityStateType)
}

class CityStateViewModel: ObservableObject {

    @Published
    var name: String

    @Published
    var suzerainName: String

    @Published
    var envoys: Int = 0 {
        didSet {
            print("number of envoys updated: \(oldValue) => \(self.envoys)")

            if envoys < 0 {
                print("envoys cannot be negativ - reseting")
                envoys = 0
                return
            }

            let delta = envoys - oldValue
            if let delegate = self.delegate {
                if delta == 1 {
                    if delegate.assignEnvoy(to: self.cityState) {
                        // success
                        print("envoy assigned to \(self.cityState)")
                        return
                    }
                } else if delta == -1 {
                    if delegate.unassignEnvoy(from: self.cityState) {
                        // success
                        print("envoy unassigned from \(self.cityState)")
                        return
                    }
                }
            }

            // reset
            print("envoys cannot be set - reseting to \(oldValue)")
            envoys = oldValue
        }
    }

    private let cityState: CityStateType
    private let questType: CityStateQuestType
    weak var delegate: CityStateViewModelDelegate?

    init(cityState: CityStateType, suzerainName: String, quest questType: CityStateQuestType, envoys: Int) {

        self.cityState = cityState
        self.questType = questType
        self.envoys = envoys

        self.name = cityState.name().localized()
        self.suzerainName = suzerainName
    }

    func cityStateImage() -> NSImage {

        return ImageCache.shared.image(for: self.cityState.iconTexture())
    }

    func questHintImage() -> NSImage {

        if self.questType == .none {
            return NSImage()
        }

        return ImageCache.shared.image(for: "hint")
    }

    func questHintToolTip() -> String {

        if self.questType == .none {
            return ""
        }

        return self.questType.summary()
    }

    func bonusImage1() -> NSImage {

        let active = self.envoys >= 1
        let texture = ImageCache.shared.image(for: self.cityState.envoysTexture())
        return texture.tint(with: active ? self.cityState.category().color() : .gray)
    }

    func bonusText1() -> String {

        return self.cityState.bonus(for: .first)
    }

    func bonusImage3() -> NSImage {

        let active = self.envoys >= 3
        let texture = ImageCache.shared.image(for: self.cityState.envoysTexture())
        return texture.tint(with: active ? self.cityState.category().color() : .gray)
    }

    func bonusText3() -> String {

        return self.cityState.bonus(for: .third)
    }

    func bonusImage6() -> NSImage {

        let active = self.envoys >= 6
        let texture = ImageCache.shared.image(for: self.cityState.envoysTexture())
        return texture.tint(with: active ? self.cityState.category().color() : .gray)
    }

    func bonusText6() -> String {

        return self.cityState.bonus(for: .sixth)
    }

    func suzerainImage() -> NSImage {

        return ImageCache.shared.image(for: self.cityState.suzerainTexture(active: true))
    }

    func suzerainText() -> String {

        return self.cityState.bonus(for: .suzerain)
    }

    func jumpToImage() -> NSImage {

        return ImageCache.shared.image(for: "jump-to")
    }

    func centerClicked() {

        self.delegate?.center(on: self.cityState)
    }
}

extension CityStateViewModel: Hashable {

    static func == (lhs: CityStateViewModel, rhs: CityStateViewModel) -> Bool {

        return lhs.cityState == rhs.cityState
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.cityState)
    }
}
