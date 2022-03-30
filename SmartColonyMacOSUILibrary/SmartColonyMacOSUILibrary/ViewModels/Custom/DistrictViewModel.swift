//
//  DistrictViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol DistrictViewModelDelegate: AnyObject {

    func clicked(on districtType: DistrictType, at index: Int, in gameModel: GameModel?)
}

class DistrictViewModel: QueueViewModel, ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    let districtType: DistrictType
    let turns: Int
    let index: Int
    let showYields: Bool

    var active: Bool

    @Published
    var toolTip: NSAttributedString

    weak var delegate: DistrictViewModelDelegate?

    init(districtType: DistrictType, turns: Int = -1, active: Bool, showYields: Bool = false, at index: Int = -1) {

        self.districtType = districtType
        self.turns = active ? -1 : turns
        self.active = active
        self.showYields = showYields
        self.index = index

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: districtType.name().localized() + "\n\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let tokenizer = LabelTokenizer()
        let effects = tokenizer.bulletPointList(
            from: districtType.effects(),
            with: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(effects)

        self.toolTip = toolTipText

        super.init(queueType: .district)
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.districtType.iconTexture())
    }

    func title() -> String {

        return self.districtType.name()
    }

    func turnsText() -> String {

        if self.showYields {
            return ""
        }

        if self.active {
            return ""
        }

        return "\(self.turns)"
    }

    func turnsIcon() -> NSImage {

        if self.active {
            return Globals.Icons.checkmark
        }

        return Globals.Icons.turns
    }

    func yieldValueViewModel() -> [YieldValueViewModel] {

        if !self.showYields {
            return []
        }

        return [] // FIXME
    }

    func fontColor() -> Color {

        if self.active {
            return .white
        } else {
            return Color(Globals.Colors.districtActive)
        }
    }

    func background() -> NSImage {

        if self.active {
            return ImageCache.shared.image(for: "grid9-button-district-active")
        } else {
            return ImageCache.shared.image(for: "grid9-button-district")
        }
    }

    func clicked() {

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        self.delegate?.clicked(on: self.districtType, at: self.index, in: gameModel)
    }
}
