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
        
        let result = GameObject.battle(between: attacker, and: defender, attackType: .active, real: false, in: game)

        XCTAssertEqual(attacker.strength, 5, "attacker should have 5 losses")
        XCTAssertEqual(defender.strength, 5, "defender should have 5 losses")
        XCTAssertEqual(result, [], "result should be empty")
    }
    
    func testBattleDefenderKilled() {
        
        let attacker = Axeman(with: "attacker", at: HexPoint(x: 1, y: 1), civilization: .english)
        let defender = Axeman(with: "defender", at: HexPoint(x: 1, y: 1), civilization: .french)
        defender.strength = 4
        
        let result = GameObject.battle(between: attacker, and: defender, attackType: .active, real: false, in: game)
        
        XCTAssertEqual(attacker.strength, 5, "attacker should have 5 losses")
        XCTAssertEqual(defender.strength, 0, "defender should be killed")
        XCTAssertEqual(result, [BattleResult.defenderKilled], "result should contain 'defender killed'")
    }
    
    func testBattleAttackBrokenUp() {
        
        let attacker = Axeman(with: "attacker", at: HexPoint(x: 1, y: 1), civilization: .english)
        attacker.strength = 1
        let defender = Axeman(with: "defender", at: HexPoint(x: 1, y: 1), civilization: .french)
        defender.experience = 5
        
        let result = GameObject.battle(between: attacker, and: defender, attackType: .active, real: false, in: game)
        
        XCTAssertEqual(attacker.strength, 0, "attacker should have 1 loss")
        XCTAssertEqual(defender.strength, 10, "defender should have 0 losses")
        XCTAssertEqual(result, [BattleResult.attackBrokenUp, BattleResult.attackerKilled], "result should be attacker killed and attack broken up")
    }
}
