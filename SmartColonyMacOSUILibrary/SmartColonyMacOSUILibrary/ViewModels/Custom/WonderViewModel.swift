//
//  WonderViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol WonderViewModelDelegate: AnyObject {

    func clicked(on wonderType: WonderType, at index: Int, in gameModel: GameModel?)
}

class WonderViewModel: QueueViewModel, ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    let wonderType: WonderType
    let turns: Int
    let index: Int
    let showYields: Bool

    weak var delegate: WonderViewModelDelegate?

    init(wonderType: WonderType, turns: Int, showYields: Bool = false, at index: Int = -1) {

        self.wonderType = wonderType
        self.turns = turns
        self.showYields = showYields
        self.index = index

        super.init(queueType: .wonder)
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.wonderType.iconTexture())
    }

    func title() -> String {

        return self.wonderType.name().localized()
    }

    func turnsText() -> String {

        if self.showYields {
            return ""
        }

        return "\(self.turns)"
    }

    func turnsIcon() -> NSImage {

        return Globals.Icons.turns
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: "grid9-button-active")
    }

    func yieldValueViewModels() -> [YieldValueViewModel] {

        if !self.showYields {
            return []
        }

        let buildingYield = self.wonderType.yields()
        var models: [YieldValueViewModel] = []

        for yieldType in YieldType.all {

            let yieldValue = buildingYield.value(of: yieldType)
            if yieldValue > 0 {
                models.append(YieldValueViewModel(yieldType: yieldType, initial: yieldValue, type: .onlyValue, withBackground: false))
            }
        }

        return models
    }

    func clicked() {

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        self.delegate?.clicked(on: self.wonderType, at: self.index, in: gameModel)
    }
}

/*extension WonderViewModel: Hashable {
    
    static func == (lhs: WonderViewModel, rhs: WonderViewModel) -> Bool {
        
        return lhs.wonderType == rhs.wonderType
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.wonderType)
    }
}*/
