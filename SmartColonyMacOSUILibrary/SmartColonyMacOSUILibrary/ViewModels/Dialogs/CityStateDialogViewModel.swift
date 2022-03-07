//
//  CityStateDialogViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 07.03.22.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

class CityStateDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var cityStateName: String

    @Published
    var typeName: String

    @Published
    var suzerainName: String

    @Published
    var envoysSentName: String

    @Published
    var influencedByName: String

    @Published
    var questsName: String

    // @Published
    // var envoyEffectViewModels: [EnvoyEffectViewModel]

    private var cityState: CityStateType = .akkad

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "TXT_KEY_CITY_STATE_TITLE".localized()
        self.cityStateName = "-"
        self.typeName = "-"
        self.suzerainName = "-"
        self.envoysSentName = "0"
        self.influencedByName = "0"
        self.questsName = "0"
    }

    func update(for cityRef: AbstractCity?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard let city = cityRef else {
            fatalError("cant get city")
        }

        guard let cityStatePlayer = city.player else {
            fatalError("cant get player")
        }

        var numberOfQuests = 0

        for loopPlayer in gameModel.players {

            if loopPlayer.isBarbarian() || loopPlayer.isFreeCity() || loopPlayer.isCityState() {
                continue
            }

            if cityStatePlayer.quest(for: loopPlayer.leader) != nil {
                numberOfQuests += 1
            }
        }

        guard case .cityState(type: let cityStateType) = cityStatePlayer.leader else {
            fatalError("not a city state")
        }

        self.cityState = cityStateType

        self.cityStateName = city.name.localized()

        // report
        self.typeName = cityStateType.category().name().localized()
        self.suzerainName = cityStatePlayer.suzerain()?.name().localized() ?? "None"
        self.envoysSentName = "\(humanPlayer.envoysAssigned(to: cityStateType))"
        self.influencedByName = "\(gameModel.countMajorCivilizationsMet(with: cityState))"
        self.questsName = "\(numberOfQuests)"
    }

    func cityStateImage() -> NSImage {

        return ImageCache.shared.image(for: self.cityState.iconTexture())
    }
}

extension CityStateDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
