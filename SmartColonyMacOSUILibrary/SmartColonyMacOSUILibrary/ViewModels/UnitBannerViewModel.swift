//
//  UnitBannerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 09.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class UnitBannerViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var unitHealthValue: CGFloat = 0.0

    @Published
    var showBanner: Bool = false

    @Published
    var commands: [Command] = []

    private var selectedUnit: AbstractUnit?

    weak var delegate: GameViewModelDelegate?

    init(selectedUnit: AbstractUnit? = nil) {

        self.selectedUnit = selectedUnit
    }

#if DEBUG
    init(selectedUnit: AbstractUnit? = nil, commands: [Command], in gameModel: GameModel?) {

        self.selectedUnit = selectedUnit
        self.commands = commands
        self.gameEnvironment.assign(game: gameModel)
        self.showBanner = true

        if let selectedUnit = self.selectedUnit {
            self.unitHealthValue = CGFloat(selectedUnit.healthPoints()) / 100.0
        }
    }
#endif

    public func unitName() -> String {

        if let selectedUnit = self.selectedUnit {
            return selectedUnit.name()
        } else {
            return ""
        }
    }

    public func unitTypeImage() -> NSImage {

        if let selectedUnit = self.selectedUnit {
            return selectedUnit.type.iconTexture()
        } else {
            return NSImage()
        }
    }

    public func unitMoves() -> String {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        if let selectedUnit = self.selectedUnit {

            if selectedUnit.type == .trader {
                return "15 land route range"
            }

            return "\(selectedUnit.moves()) / \(selectedUnit.maxMoves(in: gameModel)) moves"
        }

        return ""
    }

    public func unitHealth() -> String {

        if let selectedUnit = self.selectedUnit {

            if selectedUnit.type == .trader {

                guard let techs = self.selectedUnit?.player?.techs else {
                    fatalError("cant get player techs")
                }

                if techs.has(tech: .celestialNavigation) {
                    return "30 sea route range"
                }
            }

            return "\(selectedUnit.healthPoints()) health"
        }

        return ""
    }

    public func unitCharges() -> String {

        if let selectedUnit = self.selectedUnit {

            if selectedUnit.type.buildCharges() > 0 {
                return "\(selectedUnit.buildCharges()) charges"
            }
        }

        return ""
    }

    func listImage() -> NSImage {

        return ImageCache.shared.image(for: "command-button-list")
    }

    func listClicked() {

        print("open unit list")
        self.delegate?.showUnitListDialog()
    }

    func commandImage(at index: Int) -> NSImage {

        if 0 <= index && index < self.commands.count {

            let command = self.commands[index]
            return ImageCache.shared.image(for: command.type.buttonTexture())
        }

        return NSImage(size: NSSize(width: 32, height: 32))
    }

    func commandClicked(at index: Int) {

        if 0 <= index && index < self.commands.count {

            let command = self.commands[index]
            print("commandClicked(at: \(command.title()))")
            self.handle(command: command)
        }
    }

    func handle(command: Command) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        switch command.type {

        case .found:
            self.delegate?.showCityNameDialog()

        case .buildFarm:
            if let selectedUnit = self.selectedUnit {
                let farmBuildMission = UnitMission(type: .build, buildType: .farm, at: selectedUnit.location)
                selectedUnit.push(mission: farmBuildMission, in: gameModel)
            }

        case .buildMine:
            if let selectedUnit = self.selectedUnit {
                let mineBuildMission = UnitMission(type: .build, buildType: .mine, at: selectedUnit.location)
                selectedUnit.push(mission: mineBuildMission, in: gameModel)
            }

        case .buildCamp:
            if let selectedUnit = self.selectedUnit {
                let campBuildMission = UnitMission(type: .build, buildType: .camp, at: selectedUnit.location)
                selectedUnit.push(mission: campBuildMission, in: gameModel)
            }

        case .buildPasture:
            if let selectedUnit = self.selectedUnit {
                let pastureBuildMission = UnitMission(type: .build, buildType: .pasture, at: selectedUnit.location)
                selectedUnit.push(mission: pastureBuildMission, in: gameModel)
            }

        case .buildQuarry:
            if let selectedUnit = self.selectedUnit {
                let quarryBuildMission = UnitMission(type: .build, buildType: .quarry, at: selectedUnit.location)
                selectedUnit.push(mission: quarryBuildMission, in: gameModel)
            }
        case .buildFishingBoats:
            if let selectedUnit = self.selectedUnit {
                let fishingBuildMission = UnitMission(type: .build, buildType: .fishingBoats, at: selectedUnit.location)
                selectedUnit.push(mission: fishingBuildMission, in: gameModel)
            }

        case .pillage:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.doPillage(in: gameModel)
            }

        case .fortify:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.doFortify(in: gameModel)
            }

        case .hold:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.set(activityType: .hold, in: gameModel)
                //selectedUnit.finishMoves()
            }

        case .garrison:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.doGarrison(in: gameModel)
            }

        case .disband:
            if let selectedUnit = self.selectedUnit {

                gameModel.userInterface?.askToDisband(unit: selectedUnit, completion: { (disband) in
                    if disband {
                        selectedUnit.doKill(delayed: false, by: nil, in: gameModel)
                    }
                })
            }

        case .cancelOrder:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.doCancelOrder()
            }

        case .automateExploration:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.automate(with: .explore)
            }
        case .automateBuild:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.automate(with: .build)
            }
        case .establishTradeRoute:
            if let selectedUnit = self.selectedUnit {

                guard let originCity = gameModel.city(at: selectedUnit.origin) else {
                    return // origin city does not exist anymore ?
                }

                let cities = selectedUnit.possibleTradeRouteTargets(in: gameModel)

                gameModel.userInterface?.askForCity(start: originCity, of: cities, completion: { (target) in

                    if let targetCity = target {
                        if !selectedUnit.doEstablishTradeRoute(to: targetCity, in: gameModel) {
                            print("could not establish a trade route to \(targetCity.name)")
                        }
                    }
                })
            }

        case .attack:

            if let selectedUnit = self.selectedUnit {

                // we need a target here
                self.delegate?.showMeleeTargets(of: selectedUnit)
            }

        case .rangedAttack:

            if let selectedUnit = self.selectedUnit {

                // we need a target here
                self.delegate?.showRangedTargets(of: selectedUnit)
            }

        case .cancelAttack:

            self.delegate?.cancelAttacks()

            if let selectedUnit = self.selectedUnit {
                // update commands
                let commands = selectedUnit.commands(in: gameModel)
                self.commands = commands
            }
        }
    }

    func selectedUnitChanged(to unit: AbstractUnit?, commands: [Command], in gameModel: GameModel?) {

        self.selectedUnit = unit
        self.commands = commands

        if let selectedUnit = self.selectedUnit {
            self.unitHealthValue = CGFloat(selectedUnit.healthPoints()) / 100.0
        }
    }
}
