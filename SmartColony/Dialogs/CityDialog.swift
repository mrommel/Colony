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
    
    let districtNode: DistrictDisplayNode?
    let buildingNodes: [BuildingDisplayNode?]
}

class CityDialog: Dialog {

    weak var city: AbstractCity?
    weak var gameModel: GameModel?
    
    // additional nodes
    var currentProductionNode: SKNode?
    var manageProductionDialogButton: MenuButtonNode?
    var chooseProductionDialogButton: MenuButtonNode?

    // MARK: constructors
    
    init(for city: AbstractCity?, in gameModel: GameModel?) {

        self.city = city
        self.gameModel = gameModel

        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        let buildQueue = city.buildQueue

        let uiParser = UIParser()
        guard let cityDialogConfiguration = uiParser.parse(from: "CityDialog") else {
            fatalError("cant load cityDialogConfiguration configuration")
        }

        super.init(from: cityDialogConfiguration)

        // fill fields
        self.set(text: city.name, identifier: "city_name")
        self.set(text: "\(city.population())", identifier: "population_value")

        self.set(yieldValue: city.foodPerTurn(in: gameModel), identifier: "food_yield")
        self.set(yieldValue: city.productionPerTurn(in: gameModel), identifier: "production_yield")
        self.set(yieldValue: city.goldPerTurn(in: gameModel), identifier: "gold_yield")
        self.set(yieldValue: city.sciencePerTurn(in: gameModel), identifier: "science_yield")
        self.set(yieldValue: city.culturePerTurn(in: gameModel), identifier: "culture_yield")
        self.set(yieldValue: city.faithPerTurn(in: gameModel), identifier: "faith_yield")

        // show current building item (queue expandable)
        if let currentBuilding = buildQueue.peek() {
            
            if currentBuilding.type == .building {
                
                guard let buildingType = currentBuilding.buildingType else {
                    fatalError("cant get buildingType")
                }
                
                self.currentProductionNode = BuildingDisplayNode(buildingType: buildingType, size: CGSize(width: 100, height: 50), buttonAction: { buildingType in
                    //print("\(buildingType)")
                })
                self.currentProductionNode?.zPosition = 200
            
                self.addChild(self.currentProductionNode!)
                
            } else if currentBuilding.type == .district {
                
                guard let districtType = currentBuilding.districtType else {
                    fatalError("cant get districtType")
                }
                
                self.currentProductionNode = DistrictDisplayNode(districtType: districtType, active: false, size: CGSize(width: 100, height: 50))
                currentProductionNode?.zPosition = 200
                self.addChild(currentProductionNode!)
            } else {
                fatalError("not handled: \(currentBuilding.type)")
            }
            
            // add manage queue dialog
            self.manageProductionDialogButton = MenuButtonNode(titled: "Manage Production",
                buttonAction: {
                    print("choose production")
                })
            self.manageProductionDialogButton?.zPosition = 200
            self.addChild(self.manageProductionDialogButton!)
        } else {
            // choose production dialog
            self.chooseProductionDialogButton = MenuButtonNode(titled: "Choose Production",
                buttonAction: {
                    print("choose production")
                    self.showChooseProductionDialog()
                })
            self.chooseProductionDialogButton?.zPosition = 200
            self.addChild(self.chooseProductionDialogButton!)
        }
        
        self.updateLayout()
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
    
    private func updateLayout() {
        
        self.currentProductionNode?.position = CGPoint(x: -50, y: -200)
        
        self.manageProductionDialogButton?.position = CGPoint(x: -50, y: -250)
        self.chooseProductionDialogButton?.position = CGPoint(x: -50, y: -300)
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
}
