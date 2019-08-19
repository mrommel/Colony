//
//  BattleTest.swift
//  ColonyTests
//
//  Created by Michael Rommel on 15.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import XCTest
@testable import Colony

class BattleTests: XCTestCase {
    
    let semaphore = DispatchSemaphore(value: 0)
    var game: Game?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        CoreDataManager.shared.setup(completion: {
            self.semaphore.signal()
        })
        
        self.semaphore.wait()
        
        let userUsecase = UserUsecase()
        if !userUsecase.isCurrentUserExisting() {
            userUsecase.createCurrentUser(named: "Test", civilization: .french)
        }
        
        let map = HexagonTileMap(with: CGSize(width: 5, height: 5))
        let startPositions = StartPositions(monsterPosition: HexPoint(x: 0, y: 0), playerPosition: HexPoint(x: 2, y: 2), cityPositions: [])
        let gameObjectManager = GameObjectManager(on: map)
        let level = Level(number: 0, title: "", summary: "", difficulty: .easy, duration: 120, map: map, startPositions: startPositions, gameObjectManager: gameObjectManager)
        let boosterStock = BoosterStock()
        self.game = Game(with: level, coins: 0, boosterStock: boosterStock)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSimpleBattle() {
        
        let attacker = Axeman(with: "attacker", at: HexPoint(x: 1, y: 1), civilization: .english)
        let defender = Axeman(with: "defender", at: HexPoint(x: 1, y: 1), civilization: .french)
        
        let battle = Battle(between: attacker, and: defender, attackType: .active, in: self.game)
        let result = battle.predict()

        XCTAssertEqual(attacker.strength, 10, "attacker should still have 10 strength")
        XCTAssertEqual(defender.strength, 10, "defender should still have 10 strength")
        
        XCTAssertEqual(result.attackerDamage, 5, "attacker should have 5 losses")
        XCTAssertEqual(result.defenderDamage, 5, "defender should have 5 losses")
        XCTAssertEqual(result.options, [], "result should be empty")
    }
    
    func testBattleDefenderKilled() {
        
        let attacker = Axeman(with: "attacker", at: HexPoint(x: 1, y: 1), civilization: .english)
        let defender = Axeman(with: "defender", at: HexPoint(x: 1, y: 1), civilization: .french)
        defender.strength = 4
        
        let battle = Battle(between: attacker, and: defender, attackType: .active, in: self.game)
        let result = battle.predict()
        
        XCTAssertEqual(attacker.strength, 10, "attacker should still have 10 strength")
        XCTAssertEqual(defender.strength, 4, "defender should still have 4 strength")
        
        XCTAssertEqual(result.attackerDamage, 2, "attacker should have 5 losses")
        XCTAssertEqual(result.defenderDamage, 5, "defender should be killed")
        XCTAssertEqual(result.options, [BattleOptions.defenderKilled], "result should contain 'defender killed'")
    }
    
    func testBattleAttackBrokenUp() {
        
        let attacker = Axeman(with: "attacker", at: HexPoint(x: 1, y: 1), civilization: .english)
        attacker.strength = 1
        let defender = Axeman(with: "defender", at: HexPoint(x: 1, y: 1), civilization: .french)
        defender.experience = 5
        
        let battle = Battle(between: attacker, and: defender, attackType: .active, in: self.game)
        let result = battle.predict()
        
        XCTAssertEqual(attacker.strength, 1, "attacker should still have 1 strength")
        XCTAssertEqual(defender.strength, 10, "defender should still have 10 strength")
        
        XCTAssertEqual(result.attackerDamage, 6, "attacker should have 1 loss")
        XCTAssertEqual(result.defenderDamage, 0, "defender should have 0 losses")
        XCTAssertEqual(result.options, [BattleOptions.attackBrokenUp, BattleOptions.attackerKilled], "result should be attacker killed and attack broken up")
    }
    
    func testBattlePrediction() {
     
        let attacker = Axeman(with: "attacker", at: HexPoint(x: 1, y: 1), civilization: .english)
        attacker.strength = 7
        attacker.experience = 3
        attacker.entrenchment = 2

        let defender = Axeman(with: "defender", at: HexPoint(x: 1, y: 1), civilization: .french)
        defender.strength = 6
        defender.experience = 2
        defender.entrenchment = 4
        
        let battle = Battle(between: attacker, and: defender, attackType: .active, in: self.game)
        let predictResult = battle.predict()
        
        var averageAttackerDamage: CGFloat = 0.0
        var averageDefenderDamage: CGFloat = 0.0
        
        for _ in 0..<10 {
            
            let attackerTmp = Axeman(with: "attacker", at: HexPoint(x: 1, y: 1), civilization: .english)
            attackerTmp.strength = 7
            attackerTmp.experience = 3
            attackerTmp.entrenchment = 2
            
            let defenderTmp = Axeman(with: "defender", at: HexPoint(x: 1, y: 1), civilization: .french)
            defenderTmp.strength = 6
            defenderTmp.experience = 2
            defenderTmp.entrenchment = 4
            
            let battle = Battle(between: attackerTmp, and: defenderTmp, attackType: .active, in: self.game)
            let fightResult = battle.fight()
            
            averageAttackerDamage += CGFloat(fightResult.attackerDamage)
            averageDefenderDamage += CGFloat(fightResult.defenderDamage)
        }
        
        averageAttackerDamage /= 10
        averageDefenderDamage /= 10
        
        XCTAssertEqual(predictResult.attackerDamage, Int(averageAttackerDamage.rounded()), "predicted attacker damage differs from average")
        XCTAssertEqual(predictResult.defenderDamage, Int(averageDefenderDamage.rounded()), "predicted defender damage differs from average")
    }
}
