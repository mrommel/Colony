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
    var command0ViewModel: UnitCommandViewModel

    @Published
    var command1ViewModel: UnitCommandViewModel

    @Published
    var command2ViewModel: UnitCommandViewModel

    @Published
    var command3ViewModel: UnitCommandViewModel

    @Published
    var command4ViewModel: UnitCommandViewModel

    @Published
    var command5ViewModel: UnitCommandViewModel

    @Published
    var promotionViewModels: [PromotionViewModel] = []

    private var selectedUnit: AbstractUnit?
    private var unitImage: NSImage

    weak var delegate: GameViewModelDelegate?

    // MARK: constructors

    init(selectedUnit: AbstractUnit? = nil) {

        self.selectedUnit = selectedUnit

        self.command0ViewModel = UnitCommandViewModel()
        self.command1ViewModel = UnitCommandViewModel()
        self.command2ViewModel = UnitCommandViewModel()
        self.command3ViewModel = UnitCommandViewModel()
        self.command4ViewModel = UnitCommandViewModel()
        self.command5ViewModel = UnitCommandViewModel()

        if let selectedUnit = selectedUnit {
            self.unitImage = ImageCache.shared.image(for: selectedUnit.type.portraitTexture())
        } else {
            self.unitImage = NSImage()
        }

        self.command0ViewModel.delegate = self
        self.command1ViewModel.delegate = self
        self.command2ViewModel.delegate = self
        self.command3ViewModel.delegate = self
        self.command4ViewModel.delegate = self
        self.command5ViewModel.delegate = self
    }

#if DEBUG
    init(selectedUnit: AbstractUnit? = nil, commands: [Command], in gameModel: GameModel?) {

        self.selectedUnit = selectedUnit

        self.command0ViewModel = UnitCommandViewModel()
        self.command1ViewModel = UnitCommandViewModel()
        self.command2ViewModel = UnitCommandViewModel()
        self.command3ViewModel = UnitCommandViewModel()
        self.command4ViewModel = UnitCommandViewModel()
        self.command5ViewModel = UnitCommandViewModel()

        if let selectedUnit = selectedUnit {
            self.unitImage = selectedUnit.type.iconTexture()
        } else {
            self.unitImage = NSImage()
        }

        self.gameEnvironment.assign(game: gameModel)
        self.showBanner = true // for debug

        if let selectedUnit = self.selectedUnit {
            self.unitHealthValue = CGFloat(selectedUnit.healthPoints()) / 100.0
        }

        self.command0ViewModel.delegate = self
        self.command1ViewModel.delegate = self
        self.command2ViewModel.delegate = self
        self.command3ViewModel.delegate = self
        self.command4ViewModel.delegate = self
        self.command5ViewModel.delegate = self

        self.promotionViewModels = [
            PromotionViewModel(promotionType: .alpine, state: .gained),
            PromotionViewModel(promotionType: .battleCry, state: .gained),
            PromotionViewModel(promotionType: .tortoise, state: .gained)
        ]
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

        return self.unitImage
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

            if selectedUnit.isGreatPerson() {

                return selectedUnit.greatPersonName()
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

    // swiftlint:disable cyclomatic_complexity
    func handle(command: CommandType) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        switch command {

        case .none:
            // NOOP
            break

        case .rename:
            if let selectedUnit = self.selectedUnit {

                gameModel.userInterface?.askForInput(
                    title: "Rename",
                    summary: "Please provide a new Name:",
                    value: selectedUnit.name(),
                    confirm: "Rename",
                    cancel: "Cancel",
                    completion: { newValue in

                        selectedUnit.rename(to: newValue)
                    }
                )
            }

        case .found:
            if let selectedUnit = self.selectedUnit {

                guard let player = selectedUnit.player else {
                    fatalError("cant get unit player")
                }

                gameModel.userInterface?.askForInput(
                    title: "City Name",
                    summary: "Please provide a name:",
                    value: player.newCityName(in: gameModel),
                    confirm: "Found",
                    cancel: "Cancel",
                    completion: { newValue in

                        let location = selectedUnit.location
                        selectedUnit.doFound(with: newValue, in: gameModel)
                        gameModel.userInterface?.unselect()

                        if let city = gameModel.city(at: location) {
                            gameModel.userInterface?.showScreen(screenType: .city, city: city, other: nil, data: nil)
                        }
                    }
                )
            }

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

        case .buildPlantation:
            if let selectedUnit = self.selectedUnit {
                let plantationBuildMission = UnitMission(type: .build, buildType: .plantation, at: selectedUnit.location)
                selectedUnit.push(mission: plantationBuildMission, in: gameModel)
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

                gameModel.userInterface?.askForConfirmation(
                    title: "Disband",
                    question: "Do you really want to disband \(selectedUnit.name())?",
                    confirm: "Disband",
                    cancel: "Cancel",
                    completion: { disband in

                    if disband {
                        selectedUnit.doKill(delayed: false, by: nil, in: gameModel)
                    }
                })
            }

        case .cancelOrder:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.doCancelOrder()
            }
        case .upgrade:
            if let selectedUnit = self.selectedUnit {
                if let upgradeUnitType = selectedUnit.upgradeType() {
                    selectedUnit.doUpgrade(to: upgradeUnitType, in: gameModel)
                }
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

        case .foundReligion:
            if let selectedUnit = self.selectedUnit {

                guard let city = gameModel.city(at: selectedUnit.location) else {
                    fatalError("founding religion needs to take place in a city")
                }

                guard city.has(district: .holySite) else {
                    fatalError("founding religion needs to take place in a city with a holy district")
                }

                let possibleReligions: [ReligionType] = gameModel.availableReligions()
                let selectableItems: [SelectableItem] = possibleReligions.map { religionType in

                    return SelectableItem(
                        iconTexture: religionType.iconTexture(),
                        title: religionType.name(),
                        subtitle: "")
                }

                gameModel.userInterface?.askForSelection(title: "Found Religion", items: selectableItems, completion: { selectedIndex in

                    let religion = possibleReligions[selectedIndex]
                    print("### selected religion: \(religion) ###")

                    guard let playerReligion = self.selectedUnit?.player?.religion else {
                        fatalError("cant get player religion")
                    }

                    playerReligion.found(religion: religion, at: city, in: gameModel)

                    // first two beliefs still need to be selected
                    gameModel.userInterface?.showScreen(
                        screenType: .religion,
                        city: nil,
                        other: nil,
                        data: nil
                    )

                    // finally kill this great prophet
                    selectedUnit.doKill(delayed: true, by: nil, in: gameModel)
                })
            }

        case .activateGreatPerson:
            if let selectedUnit = self.selectedUnit {

                gameModel.userInterface?.askForConfirmation(
                    title: "Activate Great Person",
                    question: "Do you really want to activate \(selectedUnit.greatPerson.name())?",
                    confirm: "Activate",
                    cancel: "Cancel",
                    completion: { confirmed in

                        if confirmed {
                            selectedUnit.activateGreatPerson(in: gameModel)
                        }
                    })
            }

        case .transferToAnotherCity:
            if let selectedUnit = self.selectedUnit {

                guard let player = selectedUnit.player else {
                    fatalError("cant get player")
                }

                let possibleCities: [AbstractCity?] = gameModel.cities(of: player)
                let selectableItems: [SelectableItem] = possibleCities.map { cityRef in

                    guard let city = cityRef else {
                        fatalError("cant get city")
                    }

                    return SelectableItem(
                        iconTexture: nil,
                        title: city.name,
                        subtitle: "")
                }

                gameModel.userInterface?.askForSelection(
                    title: "Select City to transfer to",
                    items: selectableItems,
                    completion: { selectedIndex in

                        guard let selectedCity = possibleCities[selectedIndex] else {
                            fatalError("cant get city")
                        }

                        selectedUnit.origin = selectedCity.location
                        selectedUnit.doTransferToAnother(city: selectedCity, in: gameModel)
                        selectedUnit.finishMoves()
                    }
                )
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
                self.command0ViewModel.update(command: !commands.isEmpty ? commands[0].type : .none)
                self.command1ViewModel.update(command: commands.count > 1 ? commands[1].type : .none)
                self.command2ViewModel.update(command: commands.count > 2 ? commands[2].type : .none)
                self.command3ViewModel.update(command: commands.count > 3 ? commands[3].type : .none)
                self.command4ViewModel.update(command: commands.count > 4 ? commands[4].type : .none)
                self.command5ViewModel.update(command: commands.count > 5 ? commands[5].type : .none)
            }
        }
    }

    func selectedUnitChanged(to unit: AbstractUnit?, commands: [Command], in gameModel: GameModel?) {

        self.selectedUnit = unit

        self.command0ViewModel.update(command: !commands.isEmpty ? commands[0].type : .none)
        self.command1ViewModel.update(command: commands.count > 1 ? commands[1].type : .none)
        self.command2ViewModel.update(command: commands.count > 2 ? commands[2].type : .none)
        self.command3ViewModel.update(command: commands.count > 3 ? commands[3].type : .none)
        self.command4ViewModel.update(command: commands.count > 4 ? commands[4].type : .none)
        self.command5ViewModel.update(command: commands.count > 5 ? commands[5].type : .none)

        if let selectedUnit = self.selectedUnit {
            self.unitHealthValue = CGFloat(selectedUnit.healthPoints()) / 100.0
            self.unitImage = ImageCache.shared.image(for: selectedUnit.type.portraitTexture())
        }
    }
}
extension UnitBannerViewModel: UnitCommandViewModelDelegate {

    func clicked(on commandType: CommandType) {

        self.handle(command: commandType)
    }
}
