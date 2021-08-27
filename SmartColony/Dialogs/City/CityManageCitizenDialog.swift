//
//  CityManageCitizenDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 08.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

class CityManageCitizenDialog: Dialog {

    weak var city: AbstractCity?
    var gameModel: GameModel?

    // nodes
    var scrollNode: ScrollNode?
    var citizenMapNode: CitizenMapNode?

    init(for city: AbstractCity?, in gameModel: GameModel?) {

        self.city = city
        self.gameModel = gameModel

        guard let game = self.gameModel else {
            fatalError("cant get game")
        }

        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let cityCitizens = city.cityCitizens else {
            fatalError("cant get cityCitizens")
        }

        let uiParser = UIParser()
        guard let cityManageCitizenDialogConfiguration = uiParser.parse(from: "CityManageCitizenDialog") else {
            fatalError("cant load CityManageCitizenDialog configuration")
        }

        super.init(from: cityManageCitizenDialogConfiguration)

        // fill fields
        self.set(text: city.name, identifier: "city_name")
        if cityCitizens.focusType() == .productionGrowth {
            self.set(text: "---", identifier: "focus_label")
        } else {
            self.set(text: "\(cityCitizens.focusType())", identifier: "focus_label")
        }
        self.toggle(focusType: cityCitizens.focusType())

        let contentSize = game.contentSize()

        // scroll area
        self.scrollNode = ScrollNode(size: CGSize(width: 300, height: 400), contentSize: contentSize)
        self.scrollNode?.zPosition = self.zPosition + 1
        self.addChild(self.scrollNode!)

        self.citizenMapNode = CitizenMapNode(for: self.city, in: self.gameModel)
        self.citizenMapNode?.zPosition = self.zPosition + 2
        self.citizenMapNode?.delegate = self
        self.scrollNode?.addScrolling(child: self.citizenMapNode!)

        self.citizenMapNode?.center(on: city.location)

        self.updateLayout()

        let button = self.button(with: "cancel_button")
        button?.zPosition = 500

        if let foodYield = self.item(with: "food_yield") as? YieldDisplayNode {
            foodYield.zPosition = 500
            foodYield.action = { yieldType in
                self.toggle(focusType: yieldType.focusType())
            }
        }

        if let productionYield = self.item(with: "production_yield") as? YieldDisplayNode {
            productionYield.zPosition = 500
            productionYield.action = { yieldType in
                self.toggle(focusType: yieldType.focusType())
            }
        }

        if let goldYield = self.item(with: "gold_yield") as? YieldDisplayNode {
            goldYield.zPosition = 500
            goldYield.action = { yieldType in
                self.toggle(focusType: yieldType.focusType())
            }
        }

        if let scienceYield = self.item(with: "science_yield") as? YieldDisplayNode {
            scienceYield.zPosition = 500
            scienceYield.action = { yieldType in
                self.toggle(focusType: yieldType.focusType())
            }
        }

        if let cultureYield = self.item(with: "culture_yield") as? YieldDisplayNode {
            cultureYield.zPosition = 500
            cultureYield.action = { yieldType in
                self.toggle(focusType: yieldType.focusType())
            }
        }

        if let faithYield = self.item(with: "faith_yield") as? YieldDisplayNode {
            faithYield.zPosition = 500
            faithYield.action = { yieldType in
                self.toggle(focusType: yieldType.focusType())
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateLayout() {

        self.scrollNode?.position = CGPoint(x: 0, y: -320)
        self.scrollNode?.contentSize = CGSize(width: 250, height: 400)
    }

    func toggle(focusType: CityFocusType) {

        guard let cityCitizens = self.city?.cityCitizens else {
            fatalError("cant get cityCitizens")
        }

        if let foodYield = self.item(with: "food_yield") as? YieldDisplayNode {
            if focusType == .food {
                foodYield.enable()
            } else {
                foodYield.disable()
            }
        }

        if let productionYield = self.item(with: "production_yield") as? YieldDisplayNode {
            if focusType == .production {
                productionYield.enable()
            } else {
                productionYield.disable()
            }
        }

        if let goldYield = self.item(with: "gold_yield") as? YieldDisplayNode {
            if focusType == .gold {
                goldYield.enable()
            } else {
                goldYield.disable()
            }
        }

        if let scienceYield = self.item(with: "science_yield") as? YieldDisplayNode {
            if focusType == .science {
                scienceYield.enable()
            } else {
                scienceYield.disable()
            }
        }

        if let cultureYield = self.item(with: "culture_yield") as? YieldDisplayNode {
            if focusType == .culture {
                cultureYield.enable()
            } else {
                cultureYield.disable()
            }
        }

        if let faithYield = self.item(with: "faith_yield") as? YieldDisplayNode {
            if focusType == .faith {
                faithYield.enable()
            } else {
                faithYield.disable()
            }
        }

        if cityCitizens.focusType() == focusType {
            cityCitizens.set(focusType: .productionGrowth) // default
            self.set(text: "---", identifier: "focus_label")
        } else {
            cityCitizens.set(focusType: focusType)
            self.set(text: "\(focusType)", identifier: "focus_label")
        }

        self.updateNodes()
    }

    func updateNodes() {

        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let cityCitizens = self.city?.cityCitizens else {
            fatalError("cant get cityCitizens")
        }

        cityCitizens.doReallocateCitizens(in: self.gameModel)
        self.citizenMapNode?.refresh()

        // fill yields
        self.set(yieldValue: city.foodPerTurn(in: gameModel), identifier: "food_yield")
        self.set(yieldValue: city.productionPerTurn(in: gameModel), identifier: "production_yield")
        self.set(yieldValue: city.goldPerTurn(in: gameModel), identifier: "gold_yield")
        self.set(yieldValue: city.sciencePerTurn(in: gameModel), identifier: "science_yield")
        self.set(yieldValue: city.culturePerTurn(in: gameModel), identifier: "culture_yield")
        self.set(yieldValue: city.faithPerTurn(in: gameModel), identifier: "faith_yield")
    }
}

extension CityManageCitizenDialog: CitizenMapNodeDelegate {

    func clicked(on point: HexPoint) {

        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }

        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let player = self.city?.player else {
            fatalError("cant get player")
        }

        guard let treasury = player.treasury else {
            fatalError("cant get treasury")
        }

        guard let cityCitizens = self.city?.cityCitizens else {
            fatalError("cant get cityCitizens")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        var isNeighborWorkedByCity = false

        for neighbor in point.neighbors() {

            if let neighborTile = gameModel.tile(at: neighbor) {
                if player.isEqual(to: neighborTile.workingCity()?.player) {
                    isNeighborWorkedByCity = true
                }
            }
        }

        if isNeighborWorkedByCity && tile.isVisible(to: player) {

            let cost: Double = Double(city.buyPlotCost(at: point, in: gameModel))

            if treasury.value() > cost {
                print("purchase: \(cost) at \(point)")
                city.doBuyPlot(at: point, in: gameModel)
            }
        } else {
            if cityCitizens.isForcedWorked(at: point) {
                cityCitizens.forceWorkingPlot(at: point, force: false, in: self.gameModel)
            } else {
                cityCitizens.forceWorkingPlot(at: point, force: true, in: self.gameModel)
            }
        }

        self.updateNodes()
    }
}
