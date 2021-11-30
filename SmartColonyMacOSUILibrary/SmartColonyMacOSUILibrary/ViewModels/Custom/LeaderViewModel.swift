//
//  LeaderViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol LeaderViewModelDelegate: AnyObject {

    func clicked(on leaderType: LeaderType)
}

class LeaderViewModel: ObservableObject {

    let id: UUID = UUID()

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var show: Bool

    @Published
    var toolTip: NSAttributedString

    let leaderType: LeaderType

    weak var delegate: LeaderViewModelDelegate?

    init(leaderType: LeaderType) {

        self.leaderType = leaderType
        self.show = false
        self.toolTip = NSMutableAttributedString()

        // all properties initilized
    }

    // update tooltip
    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        guard let player = gameModel.player(for: leaderType) else {
            fatalError("cant get player for \(leaderType)")
        }

        guard let government = player.government else {
            fatalError("cant get government")
        }

        guard let religion = player.religion else {
            fatalError("cant get religion")
        }

        let tooltipText = NSMutableAttributedString()

        let leaderName = NSAttributedString(
            string: self.leaderType.name(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        tooltipText.append(leaderName)

        // empire
        let empireName = NSAttributedString(
            string: "\n\(self.leaderType.civilization().name()) Empire",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(empireName)

        // government
        let governmentName = NSAttributedString(
            string: "\nGovernment: \(government.currentGovernment()?.name() ?? "-")",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(governmentName)

        // religion
        let religionName = NSAttributedString(
            string: "\nReligion: \(religion.currentReligion().name())",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(religionName)

        // cities / population
        let cities = gameModel.cities(of: player)
        let numCities = cities.count
        let numPopulation = cities.map { $0?.population() ?? 0 }.reduce(0, +)
        let citiesName = NSAttributedString(
            string: "\nCities: \(numCities) Population: \(numPopulation)",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(citiesName)

        let line = NSAttributedString(
            string: "\n-------------",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(line)

        // Score
        // diplomatic favor
        // gold
        // science per turn
        // # techs researched
        // culture per turn
        // tourism per turn
        // faith per turn
        // military strength
        let militaryStrength = gameModel.humanPlayer()?.diplomacyAI?.militaryStrength(of: player).name() ?? "-"
        let militaryStrengthName = NSAttributedString(
            string: "\nMilitary Strength: \(militaryStrength)",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(militaryStrengthName)

        let line2 = NSAttributedString(
            string: "\n-------------",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(line2)

        // strategic
        // luxuries

        self.toolTip = tooltipText
    }

    func badgeImage() -> NSImage {

        return ImageCache.shared.image(for: "leader-bagde")
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.leaderType.iconTexture())
    }

    func clicked() {

        self.delegate?.clicked(on: self.leaderType)
    }
}

extension LeaderViewModel: Hashable {

    static func == (lhs: LeaderViewModel, rhs: LeaderViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
