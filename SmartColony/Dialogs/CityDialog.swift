//
//  CityDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 13.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

struct CityDistrictProduction {
    
    let districtNode: DistrictDisplayNode?
    let buildingNodes: [BuildingDisplayNode?]
}

class CityDialog: Dialog {

    weak var city: AbstractCity?
    
    // nodes
    var scrollNode: ScrollNode?
    var buildingsAndDistrictsSectionButton: SectionHeaderButton?
    var unitsSectionButton: SectionHeaderButton?
    
    var districtProductions: [CityDistrictProduction] = []
    var unitProductions: [UnitDisplayNode] = []

    init(for city: AbstractCity?, in gameModel: GameModel?) {

        self.city = city

        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        guard let techs = city.player?.techs else {
            fatalError("cant get player techs")
        }

        guard let buildings = city.buildings else {
            fatalError("cant get city buildings")
        }

        guard let districts = city.districts else {
            fatalError("cant get city districts")
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

        var y = -200
        // show current building item (queue expandable)
        if let currentBuilding = buildQueue.peek() {
            
            if currentBuilding.type == .building {
                
                guard let buildingType = currentBuilding.buildingType else {
                    fatalError("cant get buildingType")
                }
                
                let buildingNode = BuildingDisplayNode(buildingType: buildingType, size: CGSize(width: 100, height: 50), buttonAction: { buildingType in
                    //print("\(buildingType)")
                })
                buildingNode.position = CGPoint(x: -50, y: y)
                buildingNode.zPosition = 200
            
                self.addChild(buildingNode)
                
            } else if currentBuilding.type == .district {
                
                guard let districtType = currentBuilding.districtType else {
                    fatalError("cant get districtType")
                }
                
                let districtNode = DistrictDisplayNode(districtType: districtType, active: false, size: CGSize(width: 100, height: 50))
                districtNode.position = CGPoint(x: -50, y: y)
                districtNode.zPosition = 200
                self.addChild(districtNode)
            }
        }
        
        y -= 65
        
        // scroll area
        self.scrollNode = ScrollNode(size: CGSize(width: 250, height: 300), contentSize: CGSize(width: 250, height: 500))
        self.scrollNode?.position = CGPoint(x: 0, y: y - 150)
        self.scrollNode?.zPosition = 200
        self.addChild(self.scrollNode!)
        
        // buildings/districts section
        self.buildingsAndDistrictsSectionButton = SectionHeaderButton(titled: "Districts & Buildings",
                                                               buttonAction: {
                                                                self.toogleDistrictAndBuildingProductions()
        })
        self.buildingsAndDistrictsSectionButton?.zPosition = 200
        scrollNode?.addScrolling(child: self.buildingsAndDistrictsSectionButton!)
        
        // units section
        self.unitsSectionButton = SectionHeaderButton(titled: "Units",
                                                               buttonAction: {
                                                                self.toggleUnitProductions()
        })
        self.unitsSectionButton?.zPosition = 200
        scrollNode?.addScrolling(child: self.unitsSectionButton!)
        
        // show currently built buildings grouped by district

        for districtType in DistrictType.all {
            
            var valid = true
            if let requiredTech = districtType.required() {
                valid = techs.has(tech: requiredTech)
            }
            
            if !valid {
                continue
            }
            
            if districts.has(district: districtType) {
                
                let districtNode = DistrictDisplayNode(districtType: districtType, active: true, size: CGSize(width: 200, height: 40))
                districtNode.zPosition = 200
                scrollNode?.addScrolling(child: districtNode)
                
                var buildingNodes: [BuildingDisplayNode?] = []
                
                for buildingType in BuildingType.all {
                    if buildings.has(building: buildingType) && buildingType.district() == districtType {

                        let buildingNode = BuildingDisplayNode(buildingType: buildingType, size: CGSize(width: 200, height: 40), buttonAction: { buildingType in
                            print("buildingType: \(buildingType)")
                        })
                        buildingNode.zPosition = 200
                        scrollNode?.addScrolling(child: buildingNode)
                        
                        buildingNodes.append(buildingNode)
                    }
                }
                
                let cityDistrictProduction = CityDistrictProduction(districtNode: districtNode, buildingNodes: buildingNodes)
                self.districtProductions.append(cityDistrictProduction)
            } else {
                let districtNode = DistrictDisplayNode(districtType: districtType, active: false, size: CGSize(width: 200, height: 40))
                districtNode.zPosition = 200
                scrollNode?.addScrolling(child: districtNode)
                
                let cityDistrictProduction = CityDistrictProduction(districtNode: districtNode, buildingNodes: [])
                self.districtProductions.append(cityDistrictProduction)
            }
        }
        
        for unitType in UnitType.all {
            
            var valid = true
            if let requiredTech = unitType.required() {
                valid = techs.has(tech: requiredTech)
            }
            
            if let civilization = unitType.civilization() {
                valid = valid && (civilization == city.player?.leader.civilization())
            }
            
            if valid {
                
                let unitProduction = UnitDisplayNode(unitType: unitType, size: CGSize(width: 200, height: 40), buttonAction: { unitType in
                    print("unitType: \(unitType)")
                })
                unitProduction.zPosition = 200
                scrollNode?.addScrolling(child: unitProduction)
                
                self.unitProductions.append(unitProduction)
            }
        }
        
        self.calculateProductionContentSize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func toogleDistrictAndBuildingProductions() {
        
        //print("toggle districts & buildings")
        self.buildingsAndDistrictsSectionButton?.expanded = !self.buildingsAndDistrictsSectionButton!.expanded //.toogle()
        
        // calculate contentsize
        self.calculateProductionContentSize()
        
        // hide buildings
    }
    
    private func toggleUnitProductions() {
        
        //print("toggle units")
        self.unitsSectionButton?.expanded = !self.unitsSectionButton!.expanded // .toogle()
        
        // calculate contentsize
        self.calculateProductionContentSize()
        
        // hide units
    }
    
    private func calculateProductionContentSize() {
        
        var calculatedHeight: CGFloat = 0.0
        
        if let buildingsAndDistrictsSectionButton = self.buildingsAndDistrictsSectionButton {
            
            self.buildingsAndDistrictsSectionButton?.position = CGPoint(x: 0, y: 120 - calculatedHeight)
            calculatedHeight += 50
            
            if buildingsAndDistrictsSectionButton.expanded {
                
                for districtProduction in self.districtProductions {
                    
                    districtProduction.districtNode?.position = CGPoint(x: -100, y: 120 - calculatedHeight + 20)
                    calculatedHeight += 50
                    
                    for buildingNode in districtProduction.buildingNodes {
                        
                        buildingNode?.position = CGPoint(x: -100, y: 120 - calculatedHeight + 20)
                        calculatedHeight += 50
                    }
                }
            } else {
                
                for districtProduction in self.districtProductions {
                    
                    districtProduction.districtNode?.position = CGPoint(x: 200, y: 120)
                    
                    for buildingNode in districtProduction.buildingNodes {
                        
                        buildingNode?.position = CGPoint(x: 200, y: 120)
                    }
                }
            }
        }

        if let unitsSectionButton = self.unitsSectionButton {
        
            self.unitsSectionButton?.position = CGPoint(x: 0, y: 120 - calculatedHeight)
            calculatedHeight += 50
            
            if unitsSectionButton.expanded {
                
                for unitProduction in self.unitProductions {
                    
                    unitProduction.position = CGPoint(x: -100, y: 120 - calculatedHeight + 20)
                    calculatedHeight += 50
                }
            } else {
                for unitProduction in self.unitProductions {
                    
                    unitProduction.position = CGPoint(x: 200, y: 120)
                }
            }
        }
        
        calculatedHeight += 10
        
        self.scrollNode?.contentSize.height = calculatedHeight
    }
}
