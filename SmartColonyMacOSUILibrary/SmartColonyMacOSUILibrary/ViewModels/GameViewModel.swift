//
//  GameViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.04.21.
//

import SmartAILibrary
import SmartAssets
import Cocoa
import SwiftUI

protocol GameViewModelDelegate: AnyObject {
    
    func focus(on point: HexPoint)
    
    func showPopup(popupType: PopupType, with data: PopupData?)
    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData?)
    
    func showChangeTechDialog()
    func showChangeCivicDialog()
    
    func showGovernmentDialog()
    func showChangeGovernmentDialog()
    func showChangePoliciesDialog()
    
    func showCityNameDialog()
    func foundCity(named cityName: String)
    func showCityDialog(for city: AbstractCity?)
    func showCityChooseProductionDialog(for city: AbstractCity?)
    func showCityBuildingsDialog(for city: AbstractCity?)
    
    func isShown(screen: ScreenType) -> Bool
    
    func checkPopups() -> Bool
    func add(notification: NotificationItem)
    func remove(notification: NotificationItem)
    
    func closeDialog()
}

class GameViewModelPopupData {
    
    let popupType: PopupType
    let popupData: PopupData?
    
    init(popupType: PopupType, data popupData: PopupData?) {
        
        self.popupType = popupType
        self.popupData = popupData
    }
}

public class GameViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var magnification: CGFloat = 1.0
    
    @Published
    var gameSceneViewModel: GameSceneViewModel
    
    @Published
    var notificationsViewModel: NotificationsViewModel
    
    @Published
    var governmentDialogViewModel: GovernmentDialogViewModel
    
    @Published
    var changeGovernmentDialogViewModel: ChangeGovernmentDialogViewModel
    
    @Published
    var changePolicyDialogViewModel: ChangePolicyDialogViewModel
    
    @Published
    var techDialogViewModel: TechDialogViewModel
    
    @Published
    var civicDialogViewModel: CivicDialogViewModel
    
    @Published
    var cityNameDialogViewModel: CityNameDialogViewModel
    
    @Published
    var cityDialogViewModel: CityDialogViewModel

    // UI
    
    @Published
    var currentScreenType: ScreenType = .none
    
    @Published
    var currentPopupType: PopupType = .none
    
    @Published
    var popups: [GameViewModelPopupData] = []
    
    // MARK: map display options
    
    @Published
    public var mapOptionShowResourceMarkers: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showResourceMarkers = self.mapOptionShowResourceMarkers
        }
    }
    
    @Published
    public var mapOptionShowYields: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showYields = self.mapOptionShowYields
        }
    }
    
    @Published
    public var mapOptionShowWater: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showWater = self.mapOptionShowWater
        }
    }
    
    // debug
    
    @Published
    public var mapOptionShowHexCoordinates: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showHexCoordinates = self.mapOptionShowHexCoordinates
        }
    }
    
    @Published
    public var mapOptionShowCompleteMap: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showCompleteMap = self.mapOptionShowCompleteMap
        }
    }
    
    private let textureNames: [String] = ["water", "focus-attack1", "focus-attack2", "focus-attack3", "focus1", "focus2", "focus3", "focus4", "focus5", "focus6", "unit-type-background", "cursor", "top-bar", "grid9-dialog", "techInfo-active", "techInfo-disabled", "techInfo-researched", "techInfo-researching", "civicInfo-active", "civicInfo-disabled", "civicInfo-researched", "civicInfo-researching", "notification-bagde", "notification-bottom", "notification-top", "grid9-button-active", "grid9-button-clicked", "banner", "science-progress", "culture-progress", "header-bar-button", "header-bar-left", "header-bar-right", "city-banner", "grid9-button-district-active", "grid9-button-district"]
    
    // MARK: constructor
    
    public init(preloadAssets: Bool = false) {
        
        // init models
        self.gameSceneViewModel = GameSceneViewModel()
        self.notificationsViewModel = NotificationsViewModel()
        self.governmentDialogViewModel = GovernmentDialogViewModel()
        self.changeGovernmentDialogViewModel = ChangeGovernmentDialogViewModel()
        self.changePolicyDialogViewModel = ChangePolicyDialogViewModel()
        self.techDialogViewModel = TechDialogViewModel()
        self.civicDialogViewModel = CivicDialogViewModel()
        self.cityNameDialogViewModel = CityNameDialogViewModel()
        self.cityDialogViewModel = CityDialogViewModel()
        
        // connect models
        self.gameSceneViewModel.delegate = self
        self.notificationsViewModel.delegate = self
        self.governmentDialogViewModel.delegate = self
        self.changeGovernmentDialogViewModel.delegate = self
        self.changePolicyDialogViewModel.delegate = self
        self.techDialogViewModel.delegate = self
        self.civicDialogViewModel.delegate = self
        self.cityNameDialogViewModel.delegate = self
        self.cityDialogViewModel.delegate = self
        
        self.mapOptionShowResourceMarkers = self.gameEnvironment.displayOptions.value.showResourceMarkers
        self.mapOptionShowWater = self.gameEnvironment.displayOptions.value.showWater
        self.mapOptionShowYields = self.gameEnvironment.displayOptions.value.showYields
        
        self.mapOptionShowHexCoordinates = self.gameEnvironment.displayOptions.value.showHexCoordinates
        self.mapOptionShowCompleteMap = self.gameEnvironment.displayOptions.value.showCompleteMap
        
        if preloadAssets {
            self.loadAssets()
        }
    }
    
    public func loadAssets() {
        
        // load assets into image cache
        print("-- pre-load images --")
        let bundle = Bundle.init(for: Textures.self)
        let textures: Textures = Textures(game: nil)

        print("- load \(textures.allTerrainTextureNames.count) terrain, \(textures.allRiverTextureNames.count) river and \(textures.allCoastTextureNames.count) coast textures")
        for terrainTextureName in textures.allTerrainTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: terrainTextureName), for: terrainTextureName)
        }

        for coastTextureName in textures.allCoastTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: coastTextureName), for: coastTextureName)
        }

        for riverTextureName in textures.allRiverTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: riverTextureName), for: riverTextureName)
        }

        print("- load \(textures.allFeatureTextureNames.count) feature (+ \(textures.allIceFeatureTextureNames.count) ice + \(textures.allSnowFeatureTextureNames.count) snow textures")
        for featureTextureName in textures.allFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: featureTextureName), for: featureTextureName)
        }

        for iceFeatureTextureName in textures.allIceFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: iceFeatureTextureName), for: iceFeatureTextureName)
        }
        
        for snowFeatureTextureName in textures.allSnowFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: snowFeatureTextureName), for: snowFeatureTextureName)
        }

        print("- load \(textures.allResourceTextureNames.count) resource and marker textures")
        for resourceTextureName in textures.allResourceTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: resourceTextureName), for: resourceTextureName)
        }
        for resourceMarkerTextureName in textures.allResourceMarkerTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: resourceMarkerTextureName), for: resourceMarkerTextureName)
        }
        
        print("- load \(textures.allBorderTextureNames.count) border textures")
        for borderTextureName in textures.allBorderTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: borderTextureName), for: borderTextureName)
        }
        
        print("- load \(textures.allYieldsTextureNames.count) yield textures")
        for yieldTextureName in textures.allYieldsTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: yieldTextureName), for: yieldTextureName)
        }
        
        print("- load \(textures.allBoardTextureNames.count) board textures")
        for boardTextureName in textures.allBoardTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: boardTextureName), for: boardTextureName)
        }
        
        print("- load \(textures.allImprovementTextureNames.count) improvement textures")
        for improvementTextureName in textures.allImprovementTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: improvementTextureName), for: improvementTextureName)
        }
        
        print("- load \(textures.allPathTextureNames.count) + \(textures.allPathOutTextureNames.count) path textures")
        for pathTextureName in textures.allPathTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: pathTextureName), for: pathTextureName)
        }
        for pathTextureName in textures.allPathOutTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: pathTextureName), for: pathTextureName)
        }
        
        var unitTextures: Int = 0
        for unitType in UnitType.all {
            
            if let idleTextures = unitType.idleAtlas?.textures {
                for (index, texture) in idleTextures.enumerated() {
                    ImageCache.shared.add(image: texture, for: "\(unitType.name().lowercased())-idle-\(index)")
                    
                    unitTextures += 1
                }
            } else {
                print("cant get idle textures of \(unitType.name())")
            }
            
            ImageCache.shared.add(image: bundle.image(forResource: unitType.typeTexture()), for: unitType.typeTexture())
        }
        print("- load \(unitTextures) unit textures")
        
        // populate cache with ui textures
        print("- load \(self.textureNames.count) misc textures")
        for textureName in self.textureNames {
            if !ImageCache.shared.exists(key: textureName) {
                // load from SmartAsset package
                ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
            }
        }
        
        print("- load \(textures.buttonTextureNames.count) button textures")
        for buttonTextureName in textures.buttonTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: buttonTextureName), for: buttonTextureName)
        }
        
        print("- load \(textures.cultureProgressTextureNames.count) culture progress textures")
        for cultureProgressTextureName in textures.cultureProgressTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: cultureProgressTextureName), for: cultureProgressTextureName)
        }
        
        print("- load \(textures.scienceProgressTextureNames.count) science progress textures")
        for scienceProgressTextureName in textures.scienceProgressTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: scienceProgressTextureName), for: scienceProgressTextureName)
        }
        
        print("- load \(textures.headerTextureNames.count) header textures")
        for headerTextureName in textures.headerTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: headerTextureName), for: headerTextureName)
        }
        
        print("- load \(textures.cityProgressTextureNames.count) city progress textures")
        for cityProgressTextureName in textures.cityProgressTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: cityProgressTextureName), for: cityProgressTextureName)
        }
        
        print("- load \(textures.cityTextureNames.count) city textures")
        for cityTextureName in textures.cityTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: cityTextureName), for: cityTextureName)
        }
        
        print("- load \(textures.commandTextureNames.count) + \(textures.commandButtonTextureNames.count) command textures")
        for commandTextureName in textures.commandTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: commandTextureName), for: commandTextureName)
        }
        
        for commandButtonTextureName in textures.commandButtonTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: commandButtonTextureName), for: commandButtonTextureName)
        }
        
        print("- load \(textures.policyCardTextureNames.count) policy card textures")
        for policyCardTextureName in textures.policyCardTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: policyCardTextureName), for: policyCardTextureName)
        }
        
        print("- load \(textures.governmentStateBackgroundTextureNames.count) government state background textures")
        for governmentStateBackgroundTextureName in textures.governmentStateBackgroundTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: governmentStateBackgroundTextureName), for: governmentStateBackgroundTextureName)
        }
        
        print("- load \(textures.governmentTextureNames.count) government and \(textures.governmentAmbientTextureNames.count) ambient textures")
        for governmentTextureName in textures.governmentTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: governmentTextureName), for: governmentTextureName)
        }
        for governmentAmbientTextureName in textures.governmentAmbientTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: governmentAmbientTextureName), for: governmentAmbientTextureName)
        }
        
        print("- load \(textures.yieldTextureNames.count) / \(textures.yieldBackgroundTextureNames.count) yield textures")
        for yieldTextureName in textures.yieldTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: yieldTextureName), for: yieldTextureName)
        }
        for yieldBackgroundTextureName in textures.yieldBackgroundTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: yieldBackgroundTextureName), for: yieldBackgroundTextureName)
        }
        
        print("- load \(textures.techTextureNames.count) tech type textures")
        for techTextureName in textures.techTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: techTextureName), for: techTextureName)
        }
        
        print("- load \(textures.civicTextureNames.count) civic type textures")
        for civicTextureName in textures.civicTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: civicTextureName), for: civicTextureName)
        }
        
        print("- load \(textures.buildTypeTextureNames.count) build type textures")
        for buildTypeTextureName in textures.buildTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: buildTypeTextureName), for: buildTypeTextureName)
        }
        
        print("- load \(textures.buildingTypeTextureNames.count) building type textures")
        for buildingTypeTextureName in textures.buildingTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: buildingTypeTextureName), for: buildingTypeTextureName)
        }
        
        print("- load \(textures.wonderTypeTextureNames.count) wonder type textures")
        for wonderTypeTextureName in textures.wonderTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: wonderTypeTextureName), for: wonderTypeTextureName)
        }
        
        print("- load \(textures.districtTypeTextureNames.count) district type textures")
        for districtTypeTextureName in textures.districtTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: districtTypeTextureName), for: districtTypeTextureName)
        }
        
        print("-- all textures loaded --")
    }
    
    public func centerCapital() {
        
        guard let game = self.gameEnvironment.game.value else {
            print("cant center on capital: game not set")
            return
        }
        
        guard let human = game.humanPlayer() else {
            print("cant center on capital: human not set")
            return
        }
        
        if let capital = game.capital(of: human) {
            self.gameEnvironment.moveCursor(to: capital.location)
            self.centerOnCursor()
            return
        }
            
        if let unitRef = game.units(of: human).first, let unit = unitRef {
            self.gameEnvironment.moveCursor(to: unit.location)
            self.centerOnCursor()
            return
        }
        
        print("cant center on capital: no capital nor units")
    }
    
    public func centerOnCursor() {
        
        let cursor = self.gameEnvironment.cursor.value
        
        print("todo center on cursor")
    }
    
    public func zoomIn() {
        
        self.magnification = self.magnification * 0.75
    }
    
    public func zoomOut() {
        
        self.magnification = self.magnification / 0.75
    }
    
    public func zoomReset() {
        
        self.magnification = 1.0
    }
    
    func displayPopups() {
        
        if let firstPopup = self.popups.first {

            print("show popup: \(firstPopup.popupType)")

            switch firstPopup.popupType {

            case .none:
                // NOOP
                break
            case .declareWarQuestion:
                // NOOP
                break
            case .barbarianCampCleared:
                // NOOP
                break
                
            case .techDiscovered:
                if let techType = firstPopup.popupData?.tech {
                    self.showTechDiscoveredPopup(for: techType)
                } else {
                    fatalError("popup data did not provide tech")
                }
                
            case .civicDiscovered:
                if let civicType = firstPopup.popupData?.civic {
                    self.showCivicDiscoveredPopup(for: civicType)
                } else {
                    fatalError("popup data did not provide tech")
                }
                
            case .eraEntered:
                if let era = firstPopup.popupData?.era {
                    self.showEnteredEraPopup(for: era)
                } else {
                    fatalError("popup data did not provide era")
                }
                
            case .eurekaActivated:
                if let popupData = firstPopup.popupData {
                    if popupData.tech != .none {
                        self.showEurekaActivatedPopup(for: popupData.tech)
                    } else if popupData.civic != .none {
                        self.showEurekaActivatedPopup(for: popupData.civic)
                    }
                } else {
                    fatalError("popup data did not provide tech nor civic")
                }
                
            case .goodyHutReward:
                if let goodyType = firstPopup.popupData?.goodyType {
                    let cityName = firstPopup.popupData?.cityName
                    self.showGoodyHutRewardPopup(for: goodyType, in: cityName)
                } else {
                    fatalError("popup data did not provide goodyType")
                }
        
            case .unitTrained:
                // NOOP
                break
                
            case .buildingBuilt:
                // NOOP
                break
                
            case .religionAdopted:
                if let religionType = firstPopup.popupData?.religionType {
                    let cityName = firstPopup.popupData?.cityName
                    
                    fatalError("religionAdopted")
                    //self.showGoodyHutRewardPopup(for: goodyType, in: cityName)
                } else {
                    fatalError("popup data did not provide goodyType")
                }
            }

            self.popups.removeFirst()
            return
        }
    }
}

extension GameViewModel: GameViewModelDelegate {

    func focus(on point: HexPoint) {

        self.gameSceneViewModel.centerOn = point
    }
    
    func showPopup(popupType: PopupType, with data: PopupData?) {
    
        self.popups.append(GameViewModelPopupData(popupType: popupType, data: data))
    }
    
    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData?) {
        
        switch screenType {

        case .interimRanking:
            // self.showInterimRankingDialog()
            print("==> interimRanking")
        case .diplomatic:
            // self.showDiplomaticDialog(with: otherPlayer, data: data, deal: nil)
            print("==> diplomatic")
        case .city:
            self.showCityDialog(for: city)
        case .techs:
            self.showChangeTechDialog()
        case .civics:
            self.showChangeCivicDialog()
        case .treasury:
            // self.showTreasuryDialog()
            print("==> treasury")
        case .menu:
            // self.showMenuDialog()
            print("==> menu")
        case .government:
            self.showGovernmentDialog()
        case .selectPromotion:
            guard let game = self.gameEnvironment.game.value else {
                fatalError("cant get game")
            }
            
            guard let humanPlayer = game.humanPlayer() else {
                fatalError("cant get human player")
            }
            
            if let promotableUnit = humanPlayer.firstPromotableUnit(in: game) {
            
                // self.handleUnitPromotion(at: promotableUnit.location)
                print("==> selectPromotion")
            }
        default:
            print("screen: \(screenType) not handled")
        }
    }
    
    func showGovernmentDialog() {
        
        if self.currentScreenType == .government {
            // already shown
            return
        }
        
        if self.currentScreenType == .none {
            self.governmentDialogViewModel.update()
            self.currentScreenType = .government
        } else {
            fatalError("cant show government dialog, \(self.currentScreenType) is currently shown")
        }
    }
    
    func showChangeGovernmentDialog() {
        
        if self.currentScreenType == .changeGovernment {
            // already shown
            return
        }
        
        if self.currentScreenType == .none {
            self.changeGovernmentDialogViewModel.update()
            self.currentScreenType = .changeGovernment
        } else {
            fatalError("cant show change government dialog, \(self.currentScreenType) is currently shown")
        }
    }
    
    func showChangePoliciesDialog() {
        
        if self.currentScreenType == .changePolicies {
            // already shown
            return
        }
        
        if self.currentScreenType == .none {
            self.changePolicyDialogViewModel.update()
            self.currentScreenType = .changePolicies
        } else {
            fatalError("cant show change policy dialog, \(self.currentScreenType) is currently shown")
        }
    }
    
    func showChangeTechDialog() {
        
        if self.currentScreenType == .techs {
            // already shown
            return
        }
        
        if self.currentScreenType == .none {
            self.techDialogViewModel.update()
            self.currentScreenType = .techs
        } else {
            fatalError("cant show tech dialog, \(self.currentScreenType) is currently shown")
        }
    }
    
    func showChangeCivicDialog() {
        
        if self.currentScreenType == .civics {
            // already shown
            return
        }
        
        if self.currentScreenType == .none {
            self.civicDialogViewModel.update()
            self.currentScreenType = .civics
        } else {
            fatalError("cant show civic dialog, \(self.currentScreenType) is currently shown")
        }
    }
    
    func showCityNameDialog() {
        
        if self.currentScreenType == .cityName {
            // already shown
            return
        }
        
        if self.currentScreenType == .none {
            self.cityNameDialogViewModel.update()
            self.currentScreenType = .cityName
        } else {
            fatalError("cant show city name dialog, \(self.currentScreenType) is currently shown")
        }
    }
    
    func foundCity(named cityName: String) {
        
        self.gameSceneViewModel.foundCity(named: cityName)
    }
    
    func showCityDialog(for city: AbstractCity?) {
        
        if self.currentScreenType == .city {
            // already shown
            return
        }
        
        if self.currentScreenType == .none {
            self.cityDialogViewModel.update(for: city)
            self.currentScreenType = .city
        } else {
            fatalError("cant show city dialog, \(self.currentScreenType) is currently shown")
        }
    }
    
    func showCityChooseProductionDialog(for city: AbstractCity?) {
        
        if self.currentScreenType == .city {
            // already shown
            return
        }
        
        if self.currentScreenType == .none {
            self.cityDialogViewModel.update(for: city)
            self.cityDialogViewModel.cityDetailViewType = .production
            self.cityDialogViewModel.update(for: city)
            self.currentScreenType = .city
        } else {
            fatalError("cant show city choose production dialog, \(self.currentScreenType) is currently shown")
        }
    }
    
    func showCityBuildingsDialog(for city: AbstractCity?) {
        
        if self.currentScreenType == .city {
            // already shown
            return
        }
        
        if self.currentScreenType == .none {
            self.cityDialogViewModel.update(for: city)
            self.cityDialogViewModel.cityDetailViewType = .buildings
            self.currentScreenType = .city
        } else {
            fatalError("cant show city buildings dialog, \(self.currentScreenType) is currently shown")
        }
    }
    
    func checkPopups() -> Bool {
        
        if self.currentScreenType == .none {

            if self.popups.count > 0 && self.currentPopupType == .none {
                self.displayPopups()
                return true
            }
        }
        
        return false
    }
    
    func add(notification: NotificationItem) {
        
        self.notificationsViewModel.add(notification: notification)
    }
    
    func remove(notification: NotificationItem) {
        
        self.notificationsViewModel.remove(notification: notification)
    }
    
    func isShown(screen: ScreenType) -> Bool {
        
        return self.currentScreenType == screen
    }
    
    func closeDialog() {
        
        // update some models
        self.governmentDialogViewModel.update()
        
        self.currentScreenType = .none
    }
}
