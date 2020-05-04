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
 - citizen growth overview
    - food per turn
    - food consumption
    - food surplus per turn = sum
    - amenities growth bonus (in percent)
    - other growth bonuses (in percent) (which?)
    - modified food surplus per turn = sum
    - housing multiplier (in percent 25%)
    - occupied city multiplier (???)
    - total food surplus
    - growth in turns
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
    weak var gameModel: GameModel?
    
    // additional nodes
    var currentProductionNode: SKNode?
    var manageProductionDialogButton: MenuButtonNode?
    var chooseProductionDialogButton: MenuButtonNode?
    var growthDialogButton: MenuButtonNode?

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
        
        // show current building item (queue expandable)
        if let currentBuilding = buildQueue.peek() {
            
            if currentBuilding.type == .building {
                
                guard let buildingType = currentBuilding.buildingType else {
                    fatalError("cant get buildingType")
                }
                
                self.currentProductionNode = BuildingBuildingItemDisplayNode(buildingType: buildingType, size: CGSize(width: 200, height: 42), buttonAction: { buildingType in
                    //print("\(buildingType)")
                })
                self.currentProductionNode?.zPosition = 200
            
                self.addChild(self.currentProductionNode!)
                
            } else if currentBuilding.type == .district {
                
                guard let districtType = currentBuilding.districtType else {
                    fatalError("cant get districtType")
                }
                
                self.currentProductionNode = DistrictBuildingItemDisplayNode(districtType: districtType, active: false, size: CGSize(width: 200, height: 42), buttonAction: { districtType in
                    //print("\(districtType)")
                })
                currentProductionNode?.zPosition = 200
                self.addChild(currentProductionNode!)
            } else {
                fatalError("not handled: \(currentBuilding.type)")
            }
        } else {
            //asdf
        }
        
        // add manage queue dialog
        self.manageProductionDialogButton = MenuButtonNode(titled: "Manage Production",
            buttonAction: {
                print("manage production")
            })
        self.manageProductionDialogButton?.zPosition = 200
        self.addChild(self.manageProductionDialogButton!)
        
        // choose production dialog
        self.chooseProductionDialogButton = MenuButtonNode(titled: "Choose Production",
            buttonAction: {
                print("choose production")
                self.showChooseProductionDialog()
            })
        self.chooseProductionDialogButton?.zPosition = 200
        self.addChild(self.chooseProductionDialogButton!)
        
        self.growthDialogButton = MenuButtonNode(titled: "Population Growth",
            buttonAction: {
                print("growth")
                self.showPopulationGrowthDialog()
            })
        self.growthDialogButton?.zPosition = 200
        self.addChild(self.growthDialogButton!)
        
        self.updateLayout()
    }
    
    private func updateLayout() {
        
        self.currentProductionNode?.position = CGPoint(x: -100, y: -270)
        
        self.manageProductionDialogButton?.position = CGPoint(x: 0, y: -320)
        self.chooseProductionDialogButton?.position = CGPoint(x: 0, y: -370)
        self.growthDialogButton?.position = CGPoint(x: 0, y: -420)
    }
    
    private func showChooseProductionDialog() {
        
        self.hide()
        
        let cityChooseProductionDialog = CityChooseProductionDialog(for: self.city, in: self.gameModel)
        cityChooseProductionDialog.zPosition = 260
               
        cityChooseProductionDialog.addCancelAction(handler: {
            cityChooseProductionDialog.close()
            self.show()
        })
        
        cityChooseProductionDialog.addBuildingTypeResultHandler(handler: { buildingType in
            print("result: \(buildingType))")
            
            self.city?.startBuilding(building: buildingType)
            
            cityChooseProductionDialog.close()
            self.show()
        })
        
        if let baseScene = self.scene as? BaseScene {
            baseScene.cameraNode.add(dialog: cityChooseProductionDialog)
        } else {
            fatalError("Must be started from a BaseScene")
        }
    }
    
    func showPopulationGrowthDialog() {
        
        /*self.hide()
        
        let cityChooseProductionDialog = CityChooseProductionDialog(for: self.city, in: self.gameModel)
        cityChooseProductionDialog.zPosition = 260
               
        cityChooseProductionDialog.addCancelAction(handler: {
            cityChooseProductionDialog.close()
            self.show()
        })
        
        cityChooseProductionDialog.addBuildingTypeResultHandler(handler: { buildingType in
            print("result: \(buildingType))")
            
            self.city?.startBuilding(building: buildingType)
            
            cityChooseProductionDialog.close()
            self.show()
        })
        
        if let baseScene = self.scene as? BaseScene {
            baseScene.cameraNode.add(dialog: cityChooseProductionDialog)
        } else {
            fatalError("Must be started from a BaseScene")
        }*/
    }
}
