//
//  CityBuildingsDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 07.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

class CityBuildingsDialog: Dialog {

    weak var city: AbstractCity?

    // nodes
    var scrollNode: ScrollNode?

    var buildingsAndDistrictsSectionButton: SectionHeaderButton?
    var districtProductionNodes: [CityDistrictProductionNodeGroup] = []

    var wondersSectionButton: SectionHeaderButton?
    var wonderProductionNodes: [WonderBuildingItemDisplayNode] = []

    init(for city: AbstractCity?) {

        self.city = city

        guard let city = self.city else {
            fatalError("cant get city")
        }

        let uiParser = UIParser()
        guard let cityBuildingsDialogConfiguration = uiParser.parse(from: "CityBuildingsDialog") else {
            fatalError("cant load CityBuildingsDialog configuration")
        }

        super.init(from: cityBuildingsDialogConfiguration)

        // fill fields
        self.set(text: city.name, identifier: "city_name")

        // scroll area
        self.scrollNode = ScrollNode(size: CGSize(width: 250, height: 400), contentSize: CGSize(width: 250, height: 500))
        self.scrollNode?.zPosition = 200
        self.addChild(self.scrollNode!)

        // add scrollview and additional elements
        self.setupProductionScrollAreaContent()

        self.updateLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: private methods

    private func setupProductionScrollAreaContent() {

        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let districts = city.districts else {
            fatalError("cant get city districts")
        }

        guard let buildings = city.buildings else {
            fatalError("cant get city buildings")
        }

        guard let wonders = city.wonders else {
            fatalError("cant get city wonders")
        }

        // buildings/districts section
        self.buildingsAndDistrictsSectionButton = SectionHeaderButton(titled: "Districts & Buildings",
                                                               buttonAction: {
                                                                // self.toogleDistrictAndBuildingProductions()
        })
        self.buildingsAndDistrictsSectionButton?.zPosition = 200
        scrollNode?.addScrolling(child: self.buildingsAndDistrictsSectionButton!)

        // wonder section
        self.wondersSectionButton = SectionHeaderButton(titled: "Wonders",
                                                               buttonAction: {
                                                                // self.toggleWonderProductions()
        })
        self.wondersSectionButton?.zPosition = 200
        scrollNode?.addScrolling(child: self.wondersSectionButton!)

        // show currently built buildings grouped by district

        for districtType in DistrictType.all {

            if districts.has(district: districtType) {

                let districtNode = DistrictBuildingItemDisplayNode(districtType: districtType, active: true, size: CGSize(width: 200, height: 40))
                districtNode.zPosition = 200
                districtNode.delegate = self
                scrollNode?.addScrolling(child: districtNode)

                var buildingNodes: [BuildingBuildingItemDisplayNode?] = []

                for buildingType in BuildingType.all {

                    if buildings.has(building: buildingType) && buildingType.district() == districtType {

                        let buildingNode = BuildingBuildingItemDisplayNode(buildingType: buildingType, size: CGSize(width: 200, height: 40))
                        if city.buildQueue.isBuilding(building: buildingType) {
                            buildingNode.disable()
                        }
                        buildingNode.zPosition = 200
                        buildingNode.delegate = self
                        scrollNode?.addScrolling(child: buildingNode)

                        buildingNodes.append(buildingNode)
                    }
                }

                let cityDistrictProduction = CityDistrictProductionNodeGroup(districtNode: districtNode, buildingNodes: buildingNodes)
                self.districtProductionNodes.append(cityDistrictProduction)

            }
        }

        for wonderType in WonderType.all {

            if wonders.has(wonder: wonderType) {

                let wonderProductionNode = WonderBuildingItemDisplayNode(wonderType: wonderType, size: CGSize(width: 200, height: 40))
                wonderProductionNode.zPosition = 200
                wonderProductionNode.delegate = self
                scrollNode?.addScrolling(child: wonderProductionNode)

                self.wonderProductionNodes.append(wonderProductionNode)
            }
        }

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

    func updateLayout() {

        self.scrollNode?.position = CGPoint(x: 0, y: -350)
        self.scrollNode?.contentSize = CGSize(width: 250, height: 400)

        /*for (index, node) in self.nodes.enumerated() {
            
            node.position = CGPoint(x: -100, y: index * -50 + 180)
        }
        
        self.chooseProductionDialogButton?.position = CGPoint(x: 0, y: -590)*/
    }
}

extension CityBuildingsDialog: BuildingBuildingItemDisplayNodeDelegate {

    func clicked(on buildingType: BuildingType) {
        print("click on \(buildingType)")
    }
}

extension CityBuildingsDialog: WonderBuildingItemDisplayNodeDelegate {

    func clicked(on wonderType: WonderType) {
        print("click on \(wonderType)")
    }
}

extension CityBuildingsDialog: DistrictBuildingItemDisplayNodeDelegate {

    func clicked(on districtType: DistrictType) {
        print("click on \(districtType)")
    }
}
