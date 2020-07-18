//
//  CityDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 13.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

struct CityDistrictProductionNodeGroup {

    let districtNode: DistrictBuildingItemDisplayNode?
    let buildingNodes: [BuildingBuildingItemDisplayNode?]
}

/**
 main city dialog
 
 sections
 - citizen management (fields, buildings) / buy tiles
 - amenities
    - number / required = status
    - #luxuries
    - #civics
    - enterteinment buildings
    - great people
    - religion
    - national park
    - war weariness ?
    - bankruptcy (?)
 - housing
    - number / required = status
    - from buildings
    - civics
    - districts
    - improvements
 - buildings (already build)
 - build queue mgmt
 -
 */
class CityDialog: Dialog {

    weak var city: AbstractCity?
    var gameModel: GameModel?

    // additional nodes
    var currentProductionTitle: SKLabelNode?
    var currentProductionNode: BaseBuildingItemDisplayNode?
    var chooseProductionDialogButton: MenuButtonNode?
    var currentProductionHint: SKLabelNode?

    var manageProductionDialogButton: MenuButtonNode?
    var buildingsDialogButton: MenuButtonNode?
    var growthDialogButton: MenuButtonNode?
    var manageCitizenDialogButton: MenuButtonNode?

    // MARK: constructors

    init(for city: AbstractCity?, in gameModel: GameModel?) {

        self.city = city
        self.gameModel = gameModel

        let uiParser = UIParser()
        guard let cityDialogConfiguration = uiParser.parse(from: "CityDialog") else {
            fatalError("cant load cityDialogConfiguration configuration")
        }

        super.init(from: cityDialogConfiguration)

        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: public methods

    func hide() {

        self.position = CGPoint(x: 1000, y: 1000)
    }

    func show() {

        let uiParser = UIParser()
        guard let cityDialogConfiguration = uiParser.parse(from: "CityDialog") else {
            fatalError("cant load cityDialogConfiguration configuration")
        }

        self.position = cityDialogConfiguration.position()

        self.updateLayout()
    }

    // MARK: private methods

    private func setup() {

        guard let city = self.city else {
            fatalError("cant get city")
        }

        let buildQueue = city.buildQueue

        // fill fields
        self.set(text: city.name, identifier: "city_name")
        self.set(text: "\(city.population())", identifier: "population_value")
        self.set(text: city.name, identifier: "city_name")

        // fill yields
        self.set(yieldValue: city.foodPerTurn(in: gameModel), identifier: "food_yield")
        self.set(yieldValue: city.productionPerTurn(in: gameModel), identifier: "production_yield")
        self.set(yieldValue: city.goldPerTurn(in: gameModel), identifier: "gold_yield")
        self.set(yieldValue: city.sciencePerTurn(in: gameModel), identifier: "science_yield")
        self.set(yieldValue: city.culturePerTurn(in: gameModel), identifier: "culture_yield")
        self.set(yieldValue: city.faithPerTurn(in: gameModel), identifier: "faith_yield")

        // reset
        self.currentProductionNode?.removeFromParent()
        self.currentProductionNode = nil
        self.chooseProductionDialogButton?.removeFromParent()
        self.chooseProductionDialogButton = nil
        self.manageProductionDialogButton?.removeFromParent()
        self.manageProductionDialogButton = nil

        self.currentProductionTitle = SKLabelNode(text: "Current production")
        self.currentProductionTitle?.zPosition = self.zPosition + 1
        self.currentProductionTitle?.fontSize = 14
        self.currentProductionTitle?.fontName = Globals.Fonts.customFontFamilyname
        self.currentProductionTitle?.fontColor = .white
        self.currentProductionTitle?.numberOfLines = 1
        self.currentProductionTitle?.horizontalAlignmentMode = .left
        self.currentProductionTitle?.verticalAlignmentMode = .top
        self.currentProductionTitle?.preferredMaxLayoutWidth = 300
        self.addChild(self.currentProductionTitle!)

        self.currentProductionHint = SKLabelNode(text: "")
        self.currentProductionHint?.zPosition = self.zPosition + 1
        self.currentProductionHint?.fontSize = 10
        self.currentProductionHint?.fontName = Globals.Fonts.customFontFamilyname
        self.currentProductionHint?.fontColor = .white
        self.currentProductionHint?.numberOfLines = 1
        self.currentProductionHint?.horizontalAlignmentMode = .left
        self.currentProductionHint?.verticalAlignmentMode = .top
        self.currentProductionHint?.preferredMaxLayoutWidth = 300
        self.addChild(self.currentProductionHint!)

        // show current building item (queue expandable)
        if let currentProduction = buildQueue.peek() {

            if currentProduction.type == .building {

                guard let buildingType = currentProduction.buildingType else {
                    fatalError("cant get buildingType")
                }

                self.currentProductionNode = BuildingBuildingItemDisplayNode(buildingType: buildingType, size: CGSize(width: 300, height: 42), buttonAction: { buildingType in
                    //print("\(buildingType)")
                    // cancel?
                })
                self.currentProductionNode?.show(progress: currentProduction.production)
                self.currentProductionNode?.zPosition = 200

                self.addChild(self.currentProductionNode!)

            } else if currentProduction.type == .district {

                guard let districtType = currentProduction.districtType else {
                    fatalError("cant get districtType")
                }

                self.currentProductionNode = DistrictBuildingItemDisplayNode(districtType: districtType, active: false, size: CGSize(width: 300, height: 42), buttonAction: { districtType in
                    //print("\(districtType)")
                    // cancel?
                })
                self.currentProductionNode?.show(progress: currentProduction.production)
                currentProductionNode?.zPosition = 200
                self.addChild(currentProductionNode!)
                
            } else if currentProduction.type == .unit {
            
                guard let unitType = currentProduction.unitType else {
                    fatalError("cant get unitType")
                }
                
                self.currentProductionNode = UnitBuildingItemDisplayNode(unitType: unitType, size: CGSize(width: 300, height: 42), buttonAction: { unitType in
                    print("unitType: \(unitType)")
                    // cancel?
                })
                self.currentProductionNode?.show(progress: currentProduction.production)
                currentProductionNode?.zPosition = 200
                self.addChild(currentProductionNode!)
                
            } else if currentProduction.type == .wonder {
                
                guard let wonderType = currentProduction.wonderType else {
                    fatalError("cant get wonderType")
                }
                
                self.currentProductionNode = WonderBuildingItemDisplayNode(wonderType: wonderType, size: CGSize(width: 300, height: 42), buttonAction: { wonderType in
                    print("wonderType: \(wonderType)")
                    // cancel?
                })
                self.currentProductionNode?.show(progress: currentProduction.production)
                currentProductionNode?.zPosition = 200
                self.addChild(currentProductionNode!)
                
            } else {
                
                fatalError("not handled: \(currentProduction.type)")
            }
        }

        // add manage queue dialog
        self.manageProductionDialogButton = MenuButtonNode(titled: "Manage Production",
                                                           sized: CGSize(width: 300, height: 42),
                                                           buttonAction: {
                                                               self.showManageProductionDialog()
                                                           })
        self.manageProductionDialogButton?.zPosition = 300
        self.addChild(self.manageProductionDialogButton!)

        // choose production dialog
        self.chooseProductionDialogButton = MenuButtonNode(titled: "Choose Production",
                                                           sized: CGSize(width: 300, height: 42),
                                                           buttonAction: {
                                                               self.showChooseProductionDialog()
                                                           })
        self.chooseProductionDialogButton?.zPosition = 200
        self.addChild(self.chooseProductionDialogButton!)

        self.buildingsDialogButton = MenuButtonNode(titled: "Buildings",
                                                    sized: CGSize(width: 300, height: 42),
                                                    buttonAction: {
                                                        print("buildings")
                                                        self.showBuildingsDialog()
                                                    })
        self.buildingsDialogButton?.zPosition = 200
        self.addChild(self.buildingsDialogButton!)

        self.growthDialogButton = MenuButtonNode(titled: "Population Growth",
                                                 sized: CGSize(width: 300, height: 42),
                                                 buttonAction: {
                                                     self.showPopulationGrowthDialog()
                                                 })
        self.growthDialogButton?.zPosition = 200
        self.addChild(self.growthDialogButton!)

        self.manageCitizenDialogButton = MenuButtonNode(titled: "Manage Citizen",
                                                        sized: CGSize(width: 300, height: 42),
                                                        buttonAction: {
                                                            self.showManageCitizenDialog()
                                                        })
        self.manageCitizenDialogButton?.zPosition = 200
        self.addChild(self.manageCitizenDialogButton!)

        self.updateLayout()
    }

    private func updateLayout() {

        guard let city = self.city else {
            fatalError("cant get city")
        }

        self.currentProductionTitle?.position = CGPoint(x: -150, y: -220)

        if city.buildQueue.hasBuildable() {
            self.currentProductionNode?.position = CGPoint(x: -150, y: -240)
            self.chooseProductionDialogButton?.position = CGPoint(x: 1000, y: 1000) // hide

            self.manageProductionDialogButton?.position = CGPoint(x: 0, y: -320)
            self.manageProductionDialogButton?.enable()
        } else {
            self.currentProductionNode?.position = CGPoint(x: 1000, y: 1000) // hide
            self.chooseProductionDialogButton?.position = CGPoint(x: 0, y: -260)

            self.manageProductionDialogButton?.position = CGPoint(x: 0, y: -320)
            self.manageProductionDialogButton?.disable()
        }
        self.currentProductionHint?.text = "\(city.buildQueue.count - 1) additional items"
        self.currentProductionHint?.position = CGPoint(x: -150, y: -285)

        self.buildingsDialogButton?.position = CGPoint(x: 0, y: -370)
        self.growthDialogButton?.position = CGPoint(x: 0, y: -420)
        self.manageCitizenDialogButton?.position = CGPoint(x: 0, y: -470)
    }

    private func showChooseProductionDialog() {

        self.hide()

        let cityChooseProductionDialog = CityChooseProductionDialog(for: self.city, in: self.gameModel)
        cityChooseProductionDialog.zPosition = 260

        cityChooseProductionDialog.addCancelAction(handler: {
            cityChooseProductionDialog.close()
            self.show()
        })

        cityChooseProductionDialog.addDistrictTypeResultHandler(handler: { districtType in

            print("result: \(districtType)")

            self.city?.startBuilding(district: districtType)

            cityChooseProductionDialog.close()
            self.show()
            
            // update ui
            cityChooseProductionDialog.gameModel?.userInterface?.update(city: self.city)
        })

        cityChooseProductionDialog.addBuildingTypeResultHandler(handler: { buildingType in

            print("result: \(buildingType)")

            self.city?.startBuilding(building: buildingType)

            cityChooseProductionDialog.close()
            self.show()
            
            // update ui
            cityChooseProductionDialog.gameModel?.userInterface?.update(city: self.city)
        })

        cityChooseProductionDialog.addUnitTypeResultHandler(handler: { unitType in

            print("result: \(unitType)")

            self.city?.startTraining(unit: unitType)

            cityChooseProductionDialog.close()
            self.show()
            
            // update ui
            cityChooseProductionDialog.gameModel?.userInterface?.update(city: self.city)
        })

        cityChooseProductionDialog.addWonderTypeResultHandler(handler: { wonderType in

            print("result: \(wonderType)")

            self.city?.startBuilding(wonder: wonderType)

            cityChooseProductionDialog.close()
            self.show()
            
            // update ui
            cityChooseProductionDialog.gameModel?.userInterface?.update(city: self.city)
        })

        if let baseScene = self.scene as? BaseScene {
            baseScene.cameraNode.add(dialog: cityChooseProductionDialog)
        } else {
            fatalError("Must be started from a BaseScene")
        }
    }

    func showPopulationGrowthDialog() {

        self.hide()

        let viewModel = CityPopulationGrowthViewModel(for: self.city, in: self.gameModel)

        let cityPopulationGrowthDialog = CityPopulationGrowthDialog(with: viewModel)
        cityPopulationGrowthDialog.zPosition = 260

        cityPopulationGrowthDialog.addCancelAction(handler: {
            cityPopulationGrowthDialog.close()
            self.show()
        })

        if let baseScene = self.scene as? BaseScene {
            baseScene.cameraNode.add(dialog: cityPopulationGrowthDialog)
        } else {
            fatalError("Must be started from a BaseScene")
        }
    }

    func showManageProductionDialog() {

        self.hide()

        let cityManageProductionDialog = CityManageProductionDialog(for: self.city, in: self.gameModel)
        cityManageProductionDialog.zPosition = 260

        cityManageProductionDialog.addCancelAction(handler: {
            cityManageProductionDialog.close()
            self.show()
        })

        if let baseScene = self.scene as? BaseScene {
            baseScene.cameraNode.add(dialog: cityManageProductionDialog)
        } else {
            fatalError("Must be started from a BaseScene")
        }
    }

    func showBuildingsDialog() {

        self.hide()

        let cityBuildingsDialog = CityBuildingsDialog(for: self.city)
        cityBuildingsDialog.zPosition = 260

        cityBuildingsDialog.addCancelAction(handler: {
            cityBuildingsDialog.close()
            self.show()
        })

        if let baseScene = self.scene as? BaseScene {
            baseScene.cameraNode.add(dialog: cityBuildingsDialog)
        } else {
            fatalError("Must be started from a BaseScene")
        }
    }

    func showManageCitizenDialog() {

        self.hide()

        let cityManageCitizenDialog = CityManageCitizenDialog(for: self.city, in: self.gameModel)
        cityManageCitizenDialog.zPosition = 260

        cityManageCitizenDialog.addCancelAction(handler: {
            cityManageCitizenDialog.close()
            self.show()
        })

        if let baseScene = self.scene as? BaseScene {
            baseScene.cameraNode.add(dialog: cityManageCitizenDialog)
        } else {
            fatalError("Must be started from a BaseScene")
        }
    }
}
