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
    var envoys: Int = 0 {
        didSet {
            print("number of envoys updated: \(oldValue) => \(self.envoys)")

            if self.envoys < 0 {
                print("envoys cannot be negativ - reseting")
                self.envoys = 0
                return
            }

            let delta = self.envoys - oldValue
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
            self.envoys = oldValue
        }
    }

    private let cityState: CityStateType
    private let quest: CityStateQuestType
    weak var delegate: CityStateViewModelDelegate?

    init(cityState: CityStateType, quest: CityStateQuestType) {

        self.cityState = cityState
        self.quest = quest

        self.name = cityState.name()
    }

    func cityStateImage() -> NSImage {

        return ImageCache.shared.image(for: self.cityState.iconTexture())
    }

    func suzerainImage() -> NSImage {

        return ImageCache.shared.image(for: self.cityState.suzerainTexture(active: true))
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
