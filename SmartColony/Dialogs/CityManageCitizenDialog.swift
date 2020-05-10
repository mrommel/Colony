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

        let uiParser = UIParser()
        guard let cityManageCitizenDialogConfiguration = uiParser.parse(from: "CityManageCitizenDialog") else {
            fatalError("cant load CityManageCitizenDialog configuration")
        }

        super.init(from: cityManageCitizenDialogConfiguration)

        // fill fields
        self.set(text: city.name, identifier: "city_name")

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
        
        if let food_yield = self.item(with: "food_yield") as? YieldDisplayNode {
            food_yield.zPosition = 500
            food_yield.action = { yieldType in
                city.cityCitizens?.setFocusType(focus: .food)
                self.update()
            }
        }
        
        if let production_yield = self.item(with: "production_yield") as? YieldDisplayNode {
            production_yield.zPosition = 500
            production_yield.action = { yieldType in
                city.cityCitizens?.setFocusType(focus: .production)
                self.update()
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
    
    func update() {
        
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
        
        guard let cityCitizens = self.city?.cityCitizens else {
            fatalError("cant get cityCitizens")
        }
        
        if cityCitizens.isForcedWorked(at: point) {
            cityCitizens.forceWorkingPlot(at: point, force: false, in: self.gameModel)
        } else {
            cityCitizens.forceWorkingPlot(at: point, force: true, in: self.gameModel)
        }
        
        self.update()
    }
}
