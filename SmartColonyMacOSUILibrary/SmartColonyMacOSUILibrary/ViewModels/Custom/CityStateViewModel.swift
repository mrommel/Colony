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
            // print("number of envoys updated: \(oldValue) => \(self.envoys)")

            if envoys < 0 {
                // print("envoys cannot be negativ - reseting")
                envoys = 0
                return
            }

            let delta = envoys - oldValue
            if let delegate = self.delegate {
                if delta == 1 {
                    if delegate.assignEnvoy(to: self.cityState) {
                        // success
                        // print("envoy assigned to \(self.cityState)")
                        return
                    }
                } else if delta == -1 {
                    if delegate.unassignEnvoy(from: self.cityState) {
                        // success
                        // print("envoy unassigned from \(self.cityState)")
                        return
                    }
                }
            }

            // reset
            // print("envoys cannot be set - reseting to \(oldValue)")
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
        self.suzerainName = suzerainName.localized()
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

    func questHintToolTip() -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "TXT_KEY_CITY_STATE_AVAILABLE_QUEST".localized(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let effectsText = NSMutableAttributedString(string: "")
        if self.questType != .none {

            let tokenizer = LabelTokenizer()

            effectsText.append(NSAttributedString(string: "\n\n"))
            effectsText.append(tokenizer.convert(text: self.questType.summary(), with: Globals.Attributs.tooltipContentAttributs))
        }

        toolTipText.append(effectsText)

        return toolTipText
    }

    func bonusImage1() -> NSImage {

        let active = self.envoys >= 1
        let texture = ImageCache.shared.image(for: self.cityState.envoysTexture())
        return texture.tint(with: active ? self.cityState.category().color() : .gray)
    }

    func bonusText1() -> NSAttributedString {

        let tokenizer = LabelTokenizer()
        return tokenizer.convert(
            text: self.cityState.bonus(for: .first).localized(),
            with: Globals.Attributs.tooltipContentAttributs
        )
    }

    func bonusImage3() -> NSImage {

        let active = self.envoys >= 3
        let texture = ImageCache.shared.image(for: self.cityState.envoysTexture())
        return texture.tint(with: active ? self.cityState.category().color() : .gray)
    }

    func bonusText3() -> NSAttributedString {

        let tokenizer = LabelTokenizer()
        return tokenizer.convert(
            text: self.cityState.bonus(for: .third).localized(),
            with: Globals.Attributs.tooltipContentAttributs
        )
    }

    func bonusImage6() -> NSImage {

        let active = self.envoys >= 6
        let texture = ImageCache.shared.image(for: self.cityState.envoysTexture())
        return texture.tint(with: active ? self.cityState.category().color() : .gray)
    }

    func bonusText6() -> NSAttributedString {

        let tokenizer = LabelTokenizer()
        return tokenizer.convert(
            text: self.cityState.bonus(for: .sixth).localized(),
            with: Globals.Attributs.tooltipContentAttributs
        )
    }

    func suzerainImage() -> NSImage {

        return ImageCache.shared.image(for: self.cityState.suzerainTexture(active: true))
    }

    func suzerainText() -> NSAttributedString {

        let tokenizer = LabelTokenizer()
        return tokenizer.convert(
            text: self.cityState.bonus(for: .suzerain).localized(),
            with: Globals.Attributs.tooltipContentAttributs
        )
    }

    func centerImage() -> NSImage {

        return ImageCache.shared.image(for: "jump-to")
    }

    func centerClicked() {

        self.delegate?.center(on: self.cityState)
    }

    func centerText() -> NSAttributedString {

        return NSAttributedString(
            string: "TXT_KEY_CITY_STATE_CENTER".localizedWithFormat(with: [self.cityState.name().localized()]),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
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
