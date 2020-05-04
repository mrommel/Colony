//
//  CityChooseProductionDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 24.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit
import CoreGraphics

class CityChooseProductionDialog: Dialog {

    weak var city: AbstractCity?
    weak var gameModel: GameModel?
    
    // callbacks
    fileprivate var buildingTypeResultHandler: ((_ type: BuildingType) -> Void)?
    
    // nodes
    var scrollNode: ScrollNode?
    var buildingsAndDistrictsSectionButton: SectionHeaderButton?
    var districtProductionNodes: [CityDistrictProductionNodeGroup] = []
    
    var unitsSectionButton: SectionHeaderButton?
    var unitProductionNodes: [UnitBuildingItemDisplayNode] = []
    
    var wondersSectionButton: SectionHeaderButton?
    var wonderProductionNodes: [WonderDisplayNode] = []

    init(for city: AbstractCity?, in gameModel: GameModel?) {

        self.city = city
        self.gameModel = gameModel
        
        guard let city = self.city else {
            fatalError("cant get city")
        }

        let uiParser = UIParser()
        guard let cityChooseProductionDialogConfiguration = uiParser.parse(from: "CityChooseProductionDialog") else {
            fatalError("cant load CityChooseProductionDialog configuration")
        }

        super.init(from: cityChooseProductionDialogConfiguration)
        
        // fill fields
        self.set(text: city.name, identifier: "city_name")
        
        // add scrollview and additional elements
        self.setupProductionScrollArea()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: public methods
    
    func addBuildingTypeResultHandler(handler: @escaping (_ type: BuildingType) -> Void) {
        self.buildingTypeResultHandler = handler
    }
    
    // MARK: private methods
    
    private func setupProductionScrollArea() {
        
        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let techs = city.player?.techs else {
            fatalError("cant get player techs")
        }

        guard let civics = city.player?.civics else {
            fatalError("cant get player civics")
        }

        guard let buildings = city.buildings else {
            fatalError("cant get city buildings")
        }

        guard let districts = city.districts else {
            fatalError("cant get city districts")
        }
        
        // scroll area
        self.scrollNode = ScrollNode(size: CGSize(width: 250, height: 300), contentSize: CGSize(width: 250, height: 500))
        self.scrollNode?.position = CGPoint(x: 0, y: -415)
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
        
        // units section
        self.wondersSectionButton = SectionHeaderButton(titled: "Wonders",
                                                               buttonAction: {
                                                                self.toggleWonderProductions()
        })
        self.wondersSectionButton?.zPosition = 200
        scrollNode?.addScrolling(child: self.wondersSectionButton!)
        
        // show currently built buildings grouped by district

        for districtType in DistrictType.all {
            
            var valid = true
            if let requiredTech = districtType.requiredTech() {
                valid = valid && techs.has(tech: requiredTech)
            }
            
            if let requiredCivic = districtType.requiredCivic() {
                valid = valid && civics.has(civic: requiredCivic)
            }
            
            if !valid {
                continue
            }
            
            if districts.has(district: districtType) {
                
                let districtNode = DistrictBuildingItemDisplayNode(districtType: districtType, active: true, size: CGSize(width: 200, height: 40), buttonAction: { districtType in
                    
                })
                districtNode.zPosition = 200
                scrollNode?.addScrolling(child: districtNode)
                
                var buildingNodes: [BuildingBuildingItemDisplayNode?] = []
                
                for buildingType in BuildingType.all {
                    
                    var valid = true
                    if let requiredTech = buildingType.requiredTech() {
                        valid = valid && techs.has(tech: requiredTech)
                    }
                    
                    if let requiredCivic = buildingType.requiredCivic() {
                        valid = valid && civics.has(civic: requiredCivic)
                    }
                    
                    /*if let civilization = buildingType.civilization() {
                        valid = valid && (civilization == city.player?.leader.civilization())
                    }*/
                    
                    if valid && !buildings.has(building: buildingType) && buildingType.district() == districtType {

                        let buildingNode = BuildingBuildingItemDisplayNode(buildingType: buildingType, size: CGSize(width: 200, height: 40), buttonAction: { buildingType in
                            //print("select buildingType: \(buildingType)")
                            
                            if let handler = self.buildingTypeResultHandler {
                                handler(buildingType)
                            }
                        })
                        buildingNode.zPosition = 200
                        scrollNode?.addScrolling(child: buildingNode)
                        
                        buildingNodes.append(buildingNode)
                    }
                }
                
                let cityDistrictProduction = CityDistrictProductionNodeGroup(districtNode: districtNode, buildingNodes: buildingNodes)
                self.districtProductionNodes.append(cityDistrictProduction)
                
            } else {
                
                let districtNode = DistrictBuildingItemDisplayNode(districtType: districtType, active: false, size: CGSize(width: 200, height: 40), buttonAction: { districtType in
                    
                })
                districtNode.zPosition = 200
                scrollNode?.addScrolling(child: districtNode)
                
                let cityDistrictProduction = CityDistrictProductionNodeGroup(districtNode: districtNode, buildingNodes: [])
                self.districtProductionNodes.append(cityDistrictProduction)
            }
        }
        
        for unitType in UnitType.all {
            
            var valid = true
            if let requiredTech = unitType.required() {
                valid = techs.has(tech: requiredTech)
            }
            
            // filter great people
            if unitType.productionCost() < 0 {
                valid = false
            }
            
            if let civilization = unitType.civilization() {
                valid = valid && (civilization == city.player?.leader.civilization())
            }
            
            if valid {
                
                let unitProduction = UnitBuildingItemDisplayNode(unitType: unitType, size: CGSize(width: 200, height: 40), buttonAction: { unitType in
                    print("select unitType: \(unitType)")
                })
                unitProduction.zPosition = 200
                scrollNode?.addScrolling(child: unitProduction)
                
                self.unitProductionNodes.append(unitProduction)
            }
        }
        
        for wonderType in WonderType.all {
            
            var valid = true
            if let requiredTech = wonderType.requiredTech() {
                valid = techs.has(tech: requiredTech)
            }
            
            if let requiredCivic = wonderType.requiredCivic() {
                valid = civics.has(civic: requiredCivic)
            }
            
            if valid {
                
                let wonderProductionNode = WonderDisplayNode(wonderType: wonderType, size: CGSize(width: 200, height: 40), buttonAction: { wonderType in
                    print("select wonderType: \(wonderType)")
                })
                wonderProductionNode.zPosition = 200
                scrollNode?.addScrolling(child: wonderProductionNode)
                
                self.wonderProductionNodes.append(wonderProductionNode)
            }
        }
        
        self.calculateProductionContentSize()
    }
    
    private func toogleDistrictAndBuildingProductions() {
        
        //print("toggle districts & buildings")
        self.buildingsAndDistrictsSectionButton?.expanded = !self.buildingsAndDistrictsSectionButton!.expanded //.toogle()
        
        // calculate contentsize
        self.calculateProductionContentSize()
    }
    
    private func toggleUnitProductions() {
        
        //print("toggle units")
        self.unitsSectionButton?.expanded = !self.unitsSectionButton!.expanded // .toogle()
        
        // calculate contentsize
        self.calculateProductionContentSize()
    }
    
    private func toggleWonderProductions() {
        
        //print("toggle units")
        self.wondersSectionButton?.expanded = !self.wondersSectionButton!.expanded // .toogle()
        
        // calculate contentsize
        self.calculateProductionContentSize()
    }
    
    private func calculateProductionContentSize() {
        
        var calculatedHeight: CGFloat = 0.0
        
        if let buildingsAndDistrictsSectionButton = self.buildingsAndDistrictsSectionButton {
            
            buildingsAndDistrictsSectionButton.position = CGPoint(x: 0, y: 120 - calculatedHeight)
            calculatedHeight += 50
            
            if buildingsAndDistrictsSectionButton.expanded {
                
                for districtProduction in self.districtProductionNodes {
                    
                    districtProduction.districtNode?.position = CGPoint(x: -100, y: 120 - calculatedHeight + 20)
                    calculatedHeight += 50
                    
                    for buildingNode in districtProduction.buildingNodes {
                        
                        buildingNode?.position = CGPoint(x: -100, y: 120 - calculatedHeight + 20)
                        calculatedHeight += 50
                    }
                }
            } else {
                
                for districtProduction in self.districtProductionNodes {
                    
                    districtProduction.districtNode?.position = CGPoint(x: 200, y: 120)
                    
                    for buildingNode in districtProduction.buildingNodes {
                        
                        buildingNode?.position = CGPoint(x: 200, y: 120)
                    }
                }
            }
        }

        if let unitsSectionButton = self.unitsSectionButton {
        
            unitsSectionButton.position = CGPoint(x: 0, y: 120 - calculatedHeight)
            calculatedHeight += 50
            
            if unitsSectionButton.expanded {
                
                for unitProduction in self.unitProductionNodes {
                    
                    unitProduction.position = CGPoint(x: -100, y: 120 - calculatedHeight + 20)
                    calculatedHeight += 50
                }
            } else {
                for unitProduction in self.unitProductionNodes {
                    
                    unitProduction.position = CGPoint(x: 200, y: 120)
                }
            }
        }
        
        if let wondersSectionButton = self.wondersSectionButton {
        
            wondersSectionButton.position = CGPoint(x: 0, y: 120 - calculatedHeight)
            calculatedHeight += 50
            
            if wondersSectionButton.expanded {
                
                for wonderProductionNode in self.wonderProductionNodes {
                    
                    wonderProductionNode.position = CGPoint(x: -100, y: 120 - calculatedHeight + 20)
                    calculatedHeight += 50
                }
            } else {
                for wonderProductionNode in self.wonderProductionNodes {
                    
                    wonderProductionNode.position = CGPoint(x: 200, y: 120)
                }
            }
        }
        
        calculatedHeight += 10
        
        self.scrollNode?.contentSize.height = calculatedHeight
    }
}
