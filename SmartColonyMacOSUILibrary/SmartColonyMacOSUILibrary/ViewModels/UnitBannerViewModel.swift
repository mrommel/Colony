//
//  UnitBannerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 09.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

// swiftlint:disable type_body_length
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
    var command6ViewModel: UnitCommandViewModel

    @Published
    var promotionViewModels: [PromotionViewModel] = []

    private var selectedUnit: AbstractUnit?
    private var unitImage: NSImage

    weak var delegate: GameViewModelDelegate?
    private let unitActionBackgroundQueue: DispatchQueue = DispatchQueue(
        label: "unitActionBackgroundQueue", qos: .background, attributes: .concurrent
    )

    // MARK: constructors

    init(selectedUnit: AbstractUnit? = nil) {

        self.selectedUnit = selectedUnit

        self.command0ViewModel = UnitCommandViewModel()
        self.command1ViewModel = UnitCommandViewModel()
        self.command2ViewModel = UnitCommandViewModel()
        self.command3ViewModel = UnitCommandViewModel()
        self.command4ViewModel = UnitCommandViewModel()
        self.command5ViewModel = UnitCommandViewModel()
        self.command6ViewModel = UnitCommandViewModel()

        if let selectedUnit = selectedUnit {
            self.unitImage = ImageCache.shared.image(for: selectedUnit.type.portraitTexture())
            self.promotionViewModels = selectedUnit.gainedPromotions()
                .map { PromotionViewModel(promotionType: $0, state: .gained) }
        } else {
            self.unitImage = NSImage()
            self.promotionViewModels = []
        }

        self.command0ViewModel.delegate = self
        self.command1ViewModel.delegate = self
        self.command2ViewModel.delegate = self
        self.command3ViewModel.delegate = self
        self.command4ViewModel.delegate = self
        self.command5ViewModel.delegate = self
        self.command6ViewModel.delegate = self
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
        self.command6ViewModel = UnitCommandViewModel()

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

        for index in 0...6 where commands.count > index {
            self.command0ViewModel.update(command: commands[index].type)
        }

        self.command0ViewModel.delegate = self
        self.command1ViewModel.delegate = self
        self.command2ViewModel.delegate = self
        self.command3ViewModel.delegate = self
        self.command4ViewModel.delegate = self
        self.command5ViewModel.delegate = self
        self.command6ViewModel.delegate = self

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
            print("cant get game")
            return ""
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
                    title: "TXT_KEY_RENAME".localized(),
                    summary: "Please provide a new Name:",
                    value: selectedUnit.name(),
                    confirm: "TXT_KEY_RENAME".localized(),
                    cancel: "TXT_KEY_CANCEL".localized(),
                    completion: { newValue in

                        self.unitActionBackgroundQueue.async {
                            selectedUnit.rename(to: newValue)
                        }
                    }
                )
            }

        case .found:
            if let selectedUnit = self.selectedUnit {

                guard let player = selectedUnit.player else {
                    fatalError("cant get unit player")
                }

                let cityName = player.newCityName(in: gameModel) // not localized !

                gameModel.userInterface?.askForInput(
                    title: "City Name",
                    summary: "Please provide a name:",
                    value: cityName.localized(),
                    confirm: "TXT_KEY_FOUND".localized(),
                    cancel: "TXT_KEY_CANCEL".localized(),
                    completion: { newValue in

                        let location = selectedUnit.location
                        self.unitActionBackgroundQueue.async {
                            selectedUnit.doFound(with: newValue, in: gameModel)

                            if cityName.localized() == newValue {
                                player.registerBuild(cityName: cityName)
                            }

                            DispatchQueue.main.async {
                                gameModel.userInterface?.unselect()

                                if let city = gameModel.city(at: location) {
                                    gameModel.userInterface?.showScreen(screenType: .city, city: city, other: nil, data: nil)
                                }
                            }
                        }
                    }
                )
            }

        case .buildFarm:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    let farmBuildMission = UnitMission(type: .build, buildType: .farm, at: selectedUnit.location)
                    selectedUnit.push(mission: farmBuildMission, in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .buildMine:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    let mineBuildMission = UnitMission(type: .build, buildType: .mine, at: selectedUnit.location)
                    selectedUnit.push(mission: mineBuildMission, in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .buildCamp:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    let campBuildMission = UnitMission(type: .build, buildType: .camp, at: selectedUnit.location)
                    selectedUnit.push(mission: campBuildMission, in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .buildPasture:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    let pastureBuildMission = UnitMission(type: .build, buildType: .pasture, at: selectedUnit.location)
                    selectedUnit.push(mission: pastureBuildMission, in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .buildQuarry:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    let quarryBuildMission = UnitMission(type: .build, buildType: .quarry, at: selectedUnit.location)
                    selectedUnit.push(mission: quarryBuildMission, in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .buildPlantation:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    let plantationBuildMission = UnitMission(type: .build, buildType: .plantation, at: selectedUnit.location)
                    selectedUnit.push(mission: plantationBuildMission, in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .buildFishingBoats:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    let fishingBuildMission = UnitMission(type: .build, buildType: .fishingBoats, at: selectedUnit.location)
                    selectedUnit.push(mission: fishingBuildMission, in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .removeFeature:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    selectedUnit.doRemoveFeature(in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .plantForest:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    selectedUnit.doPlantForest(in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .pillage:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    selectedUnit.doPillage(in: gameModel)
                }
            }

        case .fortify:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    selectedUnit.doFortify(in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .heal:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    selectedUnit.set(activityType: .heal, in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .hold:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    selectedUnit.set(activityType: .hold, in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .garrison:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    selectedUnit.doGarrison(in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
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
                        self.unitActionBackgroundQueue.async {
                            selectedUnit.doKill(delayed: false, by: nil, in: gameModel)

                            DispatchQueue.main.async {
                                gameModel.userInterface?.unselect()
                            }
                        }
                    }
                })
            }

        case .cancelOrder:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    selectedUnit.doCancelOrder(in: gameModel)
                }
            }
        case .upgrade:
            if let selectedUnit = self.selectedUnit {
                if let upgradeUnitType = selectedUnit.upgradeType() {
                    self.unitActionBackgroundQueue.async {
                        selectedUnit.doUpgrade(to: upgradeUnitType, in: gameModel)

                        DispatchQueue.main.async {
                            gameModel.userInterface?.unselect()
                        }
                    }
                }
            }

        case .automateExploration:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    selectedUnit.automate(with: .explore, in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .automateBuild:
            if let selectedUnit = self.selectedUnit {
                self.unitActionBackgroundQueue.async {
                    selectedUnit.automate(with: .build, in: gameModel)

                    DispatchQueue.main.async {
                        gameModel.userInterface?.unselect()
                    }
                }
            }

        case .establishTradeRoute:
            if let selectedUnit = self.selectedUnit {

                guard let originCity = gameModel.city(at: selectedUnit.origin) else {
                    return // origin city does not exist anymore ?
                }

                let cities = selectedUnit.possibleTradeRouteTargets(in: gameModel)

                gameModel.userInterface?.askForCity(start: originCity, of: cities, completion: { (target) in

                    if let targetCity = target {
                        self.unitActionBackgroundQueue.async {
                            if !selectedUnit.doEstablishTradeRoute(to: targetCity, in: gameModel) {
                                print("could not establish a trade route to \(targetCity.name)")
                            }

                            DispatchQueue.main.async {
                                gameModel.userInterface?.unselect()
                            }
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

                gameModel.userInterface?.askForSelection(
                    title: "Found Religion",
                    items: selectableItems,
                    completion: { selectedIndex in

                        self.unitActionBackgroundQueue.async {
                            let religion = possibleReligions[selectedIndex]
                            print("### selected religion: \(religion) ###")

                            guard let player = self.selectedUnit?.player else {
                                fatalError("cant get player")
                            }

                            player.doFound(religion: religion, at: city, in: gameModel)

                            DispatchQueue.main.async {
                                // first two beliefs still need to be selected
                                gameModel.userInterface?.showScreen(
                                    screenType: .religion,
                                    city: nil,
                                    other: nil,
                                    data: nil
                                )
                            }

                            // finally kill this great prophet
                            selectedUnit.doKill(delayed: true, by: nil, in: gameModel)

                            DispatchQueue.main.async {
                                gameModel.userInterface?.unselect()
                            }
                        }
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
                            self.unitActionBackgroundQueue.async {
                                selectedUnit.activateGreatPerson(in: gameModel)

                                DispatchQueue.main.async {
                                    gameModel.userInterface?.unselect()
                                }
                            }
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

                    guard let city = cityRef as? City else {
                        fatalError("cant get city")
                    }

                    return SelectableItem(
                        iconTexture: city.iconTexture(),
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

                        self.unitActionBackgroundQueue.async {
                            selectedUnit.origin = selectedCity.location
                            selectedUnit.doTransferToAnother(city: selectedCity, in: gameModel)
                            selectedUnit.finishMoves()

                            DispatchQueue.main.async {
                                gameModel.userInterface?.unselect()
                            }
                        }
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
                self.command6ViewModel.update(command: commands.count > 6 ? commands[6].type : .none)
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
        self.command6ViewModel.update(command: commands.count > 6 ? commands[6].type : .none)

        if let selectedUnit = self.selectedUnit {
            self.unitHealthValue = CGFloat(selectedUnit.healthPoints()) / 100.0
            self.unitImage = ImageCache.shared.image(for: selectedUnit.type.portraitTexture())
            self.promotionViewModels = selectedUnit.gainedPromotions()
                .map { PromotionViewModel(promotionType: $0, state: .gained) }
        } else {
            self.promotionViewModels = []
        }
    }
}
extension UnitBannerViewModel: UnitCommandViewModelDelegate {

    func clicked(on commandType: CommandType) {

        self.handle(command: commandType)
    }
}
