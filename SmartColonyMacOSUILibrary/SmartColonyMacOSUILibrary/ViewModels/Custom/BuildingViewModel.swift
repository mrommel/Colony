//
//  BuildingViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol BuildingViewModelDelegate: AnyObject {

    func clicked(on buildingType: BuildingType, at index: Int)
}

class BuildingViewModel: QueueViewModel, ObservableObject {

    let buildingType: BuildingType
    let turns: Int
    let index: Int
    let showYields: Bool

    var active: Bool

    @Published
    var toolTip: NSAttributedString

    weak var delegate: BuildingViewModelDelegate?

    init(buildingType: BuildingType, turns: Int, active: Bool = true, showYields: Bool = false, at index: Int = -1) {

        self.buildingType = buildingType
        self.turns = turns
        self.showYields = showYields
        self.index = index
        self.active = active

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: buildingType.name().localized() + "\n\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let tokenizer = LabelTokenizer()
        let effects = tokenizer.bulletPointList(
            from: buildingType.effects().map { $0.localized() },
            with: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(effects)

        self.toolTip = toolTipText

        super.init(queueType: .building)
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.buildingType.iconTexture())
    }

    func title() -> String {

        return self.buildingType.name()
    }

    func turnsText() -> String {

        if self.turns == -1 {
            return ""
        }

        return "\(self.turns)"
    }

    func turnsIcon() -> NSImage {

        if self.turns == -1 {
            return NSImage()
        }

        return Globals.Icons.turns
    }

    func background() -> NSImage {

        if self.active {
            return ImageCache.shared.image(for: "grid9-button-active")
        } else {
            return ImageCache.shared.image(for: "grid9-button-disabled")
        }
    }

    func yieldValueViewModels() -> [YieldValueViewModel] {

        if !self.showYields {
            return []
        }

        let buildingYield = self.buildingType.yields()
        var models: [YieldValueViewModel] = []

        for yieldType in YieldType.all {

            let yieldValue = buildingYield.value(of: yieldType)
            if yieldValue > 0.0 {
                models.append(YieldValueViewModel(yieldType: yieldType, initial: yieldValue, type: .onlyValue, withBackground: false))
            }
        }

        return models
    }

    func clicked() {

        self.delegate?.clicked(on: self.buildingType, at: self.index)
    }
}
