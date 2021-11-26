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
    var gameModel: GameModel?

    // callbacks
    fileprivate var buildingTypeResultHandler: ((_ buildingType: BuildingType) -> Void)?
    fileprivate var districtTypeResultHandler: ((_ districtType: DistrictType) -> Void)?
    fileprivate var unitTypeResultHandler: ((_ unitType: UnitType) -> Void)?
    fileprivate var wonderTypeResultHandler: ((_ wonderType: WonderType) -> Void)?

    // nodes
    var scrollNode: ScrollNode?
    var buildingsAndDistrictsSectionButton: SectionHeaderButton?
    var districtProductionNodes: [CityDistrictProductionNodeGroup] = []

    var unitsSectionButton: SectionHeaderButton?
    var unitProductionNodes: [UnitBuildingItemDisplayNode] = []

    var wondersSectionButton: SectionHeaderButton?
    var wonderProductionNodes: [WonderBuildingItemDisplayNode] = []

    init(for city: AbstractCity?, in gameModel: GameModel?) {

        self.city = city
        self.gameModel = gameModel

        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard self.gameModel != nil else {
            fatalError("cant get gameModel")
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

    func addDistrictTypeResultHandler(handler: @escaping (_ type: DistrictType) -> Void) {

        self.districtTypeResultHandler = handler
    }

    func addUnitTypeResultHandler(handler: @escaping (_ type: UnitType) -> Void) {

        self.unitTypeResultHandler = handler
    }

    func addWonderTypeResultHandler(handler: @escaping (_ type: WonderType) -> Void) {

        self.wonderTypeResultHandler = handler
    }

    // MARK: private methods

    private func setupProductionScrollArea() {

        guard let city = self.city else {
            fatalError("cant get city")
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
        self.scrollNode?.zPosition = 199
        self.addChild(self.scrollNode!)

        // buildings/districts section
        self.buildingsAndDistrictsSectionButton = SectionHeaderButton(titled: "Districts & Buildings",
                                                               buttonAction: {
                                                                self.toogleDistrictAndBuildingProductions()
        })
        self.buildingsAndDistrictsSectionButton?.zPosition = 199
        scrollNode?.addScrolling(child: self.buildingsAndDistrictsSectionButton!)

        // units section
        self.unitsSectionButton = SectionHeaderButton(titled: "Units",
                                                               buttonAction: {
                                                                self.toggleUnitProductions()
        })
        self.unitsSectionButton?.zPosition = 199
        scrollNode?.addScrolling(child: self.unitsSectionButton!)

        // units section
        self.wondersSectionButton = SectionHeaderButton(titled: "Wonders",
                                                               buttonAction: {
                                                                self.toggleWonderProductions()
        })
        self.wondersSectionButton?.zPosition = 199
        scrollNode?.addScrolling(child: self.wondersSectionButton!)

        // show currently built buildings grouped by district

        for districtType in DistrictType.all {

            if districts.has(district: districtType) {

                let districtNode = DistrictBuildingItemDisplayNode(districtType: districtType, active: true, size: CGSize(width: 200, height: 40))
                districtNode.zPosition = 199
                districtNode.delegate = self
                scrollNode?.addScrolling(child: districtNode)

                var buildingNodes: [BuildingBuildingItemDisplayNode?] = []

                for buildingType in BuildingType.all {

                    if city.canBuild(building: buildingType, in: gameModel) &&
                        !buildings.has(building: buildingType) &&
                        buildingType.district() == districtType {

                        let buildingNode = BuildingBuildingItemDisplayNode(
                            buildingType: buildingType,
                            size: CGSize(width: 200, height: 40)
                        )
                        if city.buildQueue.isBuilding(building: buildingType) {
                            buildingNode.disable()
                        }
                        buildingNode.zPosition = 199
                        buildingNode.delegate = self
                        scrollNode?.addScrolling(child: buildingNode)

                        buildingNodes.append(buildingNode)
                    }
                }

                let cityDistrictProduction = CityDistrictProductionNodeGroup(districtNode: districtNode, buildingNodes: buildingNodes)
                self.districtProductionNodes.append(cityDistrictProduction)

            } else {

                if !city.canConstruct(district: districtType, in: gameModel) {
                    continue
                }

                let districtNode = DistrictBuildingItemDisplayNode(districtType: districtType, active: false, size: CGSize(width: 200, height: 40))
                districtNode.zPosition = 199
                districtNode.delegate = self
                scrollNode?.addScrolling(child: districtNode)

                let cityDistrictProduction = CityDistrictProductionNodeGroup(districtNode: districtNode, buildingNodes: [])
                self.districtProductionNodes.append(cityDistrictProduction)
            }
        }

        for unitType in UnitType.all {

            if city.canTrain(unit: unitType, in: gameModel) {

                let unitProduction = UnitBuildingItemDisplayNode(unitType: unitType, size: CGSize(width: 200, height: 40))
                unitProduction.zPosition = 199
                unitProduction.delegate = self
                scrollNode?.addScrolling(child: unitProduction)

                self.unitProductionNodes.append(unitProduction)
            }
        }

        for wonderType in WonderType.all {

            if city.canBuild(wonder: wonderType, in: gameModel) {

                let wonderProductionNode = WonderBuildingItemDisplayNode(wonderType: wonderType, size: CGSize(width: 200, height: 40))
                wonderProductionNode.delegate = self
                wonderProductionNode.zPosition = 199
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

extension CityChooseProductionDialog: UnitBuildingItemDisplayNodeDelegate {

    func clicked(on unitType: UnitType) {
        print("select unitType: \(unitType)")

        if let handler = self.unitTypeResultHandler {
            handler(unitType)
        }
    }
}

extension CityChooseProductionDialog: BuildingBuildingItemDisplayNodeDelegate {

    func clicked(on buildingType: BuildingType) {
        print("select buildingType: \(buildingType)")

        if let handler = self.buildingTypeResultHandler {
            handler(buildingType)
        }
    }
}

extension CityChooseProductionDialog: DistrictBuildingItemDisplayNodeDelegate {

    func clicked(on districtType: DistrictType) {
        print("select districtType: \(districtType)")

        if let handler = self.districtTypeResultHandler {
            handler(districtType)
        }
    }
}

extension CityChooseProductionDialog: WonderBuildingItemDisplayNodeDelegate {

    func clicked(on wonderType: WonderType) {
        print("select wonderType: \(wonderType)")

        if let handler = self.wonderTypeResultHandler {
            handler(wonderType)
        }
    }
}
