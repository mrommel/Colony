//
//  CityManageProductionDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 07.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

class CityManageProductionDialog: Dialog {

    weak var city: AbstractCity?
    var gameModel: GameModel?

    // nodes
    var scrollNode: ScrollNode?
    var chooseProductionDialogButton: MenuButtonNode?
    var nodes: [BaseBuildingItemDisplayNode] = []

    init(for city: AbstractCity?, in gameModel: GameModel?) {

        self.city = city
        self.gameModel = gameModel

        guard let city = self.city else {
            fatalError("cant get city")
        }

        let uiParser = UIParser()
        guard let cityManageProductionDialogConfiguration = uiParser.parse(from: "CityManageProductionDialog") else {
            fatalError("cant load CityManageProductionDialog configuration")
        }

        super.init(from: cityManageProductionDialogConfiguration)

        // fill fields
        self.set(text: city.name, identifier: "city_name")

        // scroll area
        self.scrollNode = ScrollNode(size: CGSize(width: 250, height: 400), contentSize: CGSize(width: 250, height: 500))
        self.scrollNode?.zPosition = 200
        self.addChild(self.scrollNode!)

        // add scrollview and additional elements
        self.setupProductionScrollAreaContent()

        // choose production dialog
        self.chooseProductionDialogButton = MenuButtonNode(titled: "Choose Production",
                                                           buttonAction: {
                                                               self.showChooseProductionDialog()
                                                           })
        self.chooseProductionDialogButton?.zPosition = 201
        self.addChild(self.chooseProductionDialogButton!)

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

        for node in self.nodes {
            node.removeFromParent()
        }

        self.nodes = []

        for currentBuilding in city.buildQueue {

            switch currentBuilding.type {

            case .unit:
                break

            case .building:

                guard let buildintType = currentBuilding.buildingType else {
                    fatalError("building without type")
                }

                let buildingNode = BuildingBuildingItemDisplayNode(buildingType: buildintType, size: CGSize(width: 200, height: 40))
                buildingNode.zPosition = 199
                buildingNode.delegate = self
                scrollNode?.addScrolling(child: buildingNode)

                self.nodes.append(buildingNode)
            case .wonder:
                guard let wonderType = currentBuilding.wonderType else {
                    fatalError("wonder without type")
                }

                let wonderNode = WonderBuildingItemDisplayNode(wonderType: wonderType, size: CGSize(width: 200, height: 40))
                wonderNode.zPosition = 199
                wonderNode.delegate = self
                scrollNode?.addScrolling(child: wonderNode)

                self.nodes.append(wonderNode)
            case .district:
                break
            case .project:
                break
            }

        }
    }

    func updateLayout() {

        self.scrollNode?.position = CGPoint(x: 0, y: -350)
        self.scrollNode?.contentSize = CGSize(width: 250, height: 400)

        for (index, node) in self.nodes.enumerated() {

            node.position = CGPoint(x: -100, y: index * -50 + 180)
        }

        self.chooseProductionDialogButton?.position = CGPoint(x: 0, y: -590)
    }

    func hide() {

        self.position = CGPoint(x: 1000, y: 1000)
    }

    func show() {

        let uiParser = UIParser()
        guard let cityManageProductionDialogConfiguration = uiParser.parse(from: "CityManageProductionDialog") else {
            fatalError("cant load CityManageProductionDialog configuration")
        }

        self.position = cityManageProductionDialogConfiguration.position()

        self.setupProductionScrollAreaContent()

        self.updateLayout()
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

            print("startBuilding: \(districtType)")
            self.city?.startBuilding(district: districtType)
            cityChooseProductionDialog.close()
            self.show()
        })

        cityChooseProductionDialog.addBuildingTypeResultHandler(handler: { buildingType in

            print("startBuilding: \(buildingType)")
            self.city?.startBuilding(building: buildingType)
            cityChooseProductionDialog.close()
            self.show()
        })

        cityChooseProductionDialog.addUnitTypeResultHandler(handler: { unitType in

            print("startTraining: \(unitType)")
            self.city?.startTraining(unit: unitType)
            cityChooseProductionDialog.close()
            self.show()
        })

        cityChooseProductionDialog.addWonderTypeResultHandler(handler: { wonderType in

            print("startBuilding: \(wonderType)")
            self.city?.startBuilding(wonder: wonderType)
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

extension CityManageProductionDialog: BuildingBuildingItemDisplayNodeDelegate {

    func clicked(on buildingType: BuildingType) {
        print("cancel building \(buildingType)?")
    }
}

extension CityManageProductionDialog: WonderBuildingItemDisplayNodeDelegate {

    func clicked(on wonderType: WonderType) {
        print("cancel building \(wonderType)?")
    }
}
