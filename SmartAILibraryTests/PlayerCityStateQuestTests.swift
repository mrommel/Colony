//
//  PlayerCityStateQuestTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 06.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

// swiftlint:disable type_body_length
class PlayerCityStateQuestTests: XCTestCase {

    func testQuestAfterMeetingCityState() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        let questsBefore = playerTrajan.ownQuests(in: gameModel)

        // WHEN
        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        let questsAfter = playerTrajan.ownQuests(in: gameModel)

        // THEN
        XCTAssertEqual(questsBefore.count, 0)
        XCTAssertEqual(questsAfter.count, 1)
    }

    func testQuestUpdatedWithWorldEraChange() throws {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .trainUnit(type: .horseman)),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)
        let worldEraBefore = gameModel.worldEra()

        // WHEN
        try playerAlexander.techs?.discover(tech: .horsebackRiding, in: gameModel)
        playerAlexander.set(era: TechType.horsebackRiding.era(), in: gameModel)
        try playerTrajan.techs?.discover(tech: .horsebackRiding, in: gameModel)
        playerTrajan.set(era: TechType.horsebackRiding.era(), in: gameModel)
        gameModel.doWorldEra()

        let questAfter = playerAmsterdam.quest(for: .trajan)
        let worldEraAfter = gameModel.worldEra()

        // THEN
        XCTAssertEqual(questBefore?.type, .trainUnit(type: .horseman))
        XCTAssertNotEqual(questAfter?.type, .trainUnit(type: .horseman))
        XCTAssertEqual(worldEraBefore, .ancient)
        XCTAssertEqual(worldEraAfter, .classical)
    }

    func testTrainUnitQuestFulfilled() throws {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        try playerTrajan.techs?.discover(tech: .horsebackRiding, in: gameModel)
        playerTrajan.treasury?.changeGold(by: 1000)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .trainUnit(type: .horseman)),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        let unitBought = playerTrajanCity.purchase(unit: .horseman, with: .gold, in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore?.type, .trainUnit(type: .horseman))
        XCTAssertTrue(unitBought)
        XCTAssertNotEqual(questAfter?.type, .trainUnit(type: .horseman))

        var cityState: CityStateType = .vaticanCity
        var quest: CityStateQuestType = .none

        for notification in playerTrajan.notifications()!.notifications() {

            guard case .questCityStateFulfilled(cityState: let tmpCityState, quest: let tmpQuest) = notification.type else {
                continue
            }

            cityState = tmpCityState
            quest = tmpQuest
        }

        XCTAssertEqual(cityState, .amsterdam)
        XCTAssertEqual(quest, .trainUnit(type: .horseman))
    }

    func testTrainUnitQuestObsolete() throws {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        try playerTrajan.techs?.discover(tech: .wheel, in: gameModel)
        playerTrajan.treasury?.changeGold(by: 1000)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .trainUnit(type: .heavyChariot)),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        try playerTrajan.techs?.discover(tech: .stirrups, in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore?.type, .trainUnit(type: .heavyChariot))
        XCTAssertNotEqual(questAfter?.type, .trainUnit(type: .heavyChariot))

        var cityState: CityStateType = .vaticanCity
        var quest: CityStateQuestType = .none

        for notification in playerTrajan.notifications()!.notifications() {

            guard case .questCityStateObsolete(cityState: let tmpCityState, quest: let tmpQuest) = notification.type else {
                continue
            }

            cityState = tmpCityState
            quest = tmpQuest
        }

        XCTAssertEqual(cityState, .amsterdam)
        XCTAssertEqual(quest, .trainUnit(type: .heavyChariot))
    }

    func testConstructDistrictQuestFulfilled() throws {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        try playerTrajan.techs?.discover(tech: .bronzeWorking, in: gameModel)
        playerTrajan.treasury?.changeGold(by: 1000)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .constructDistrict(type: .encampment)),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        _ = playerTrajanCity.purchase(district: .encampment, with: .gold, at: HexPoint(x: 14, y: 15), in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore?.type, .constructDistrict(type: .encampment))
        XCTAssertNotEqual(questAfter?.type, .constructDistrict(type: .encampment))

        var cityState: CityStateType = .vaticanCity
        var quest: CityStateQuestType = .none

        for notification in playerTrajan.notifications()!.notifications() {

            guard case .questCityStateFulfilled(cityState: let tmpCityState, quest: let tmpQuest) = notification.type else {
                continue
            }

            cityState = tmpCityState
            quest = tmpQuest
        }

        XCTAssertEqual(cityState, .amsterdam)
        XCTAssertEqual(quest, .constructDistrict(type: .encampment))
    }

    func testTriggerEurekaQuestFulfilled() throws {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .triggerEureka(tech: .irrigation)),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        playerTrajan.techs?.triggerEureka(for: .irrigation, in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore?.type, .triggerEureka(tech: .irrigation))
        XCTAssertNotEqual(questAfter?.type, .triggerEureka(tech: .irrigation))

        var cityState: CityStateType = .vaticanCity
        var quest: CityStateQuestType = .none

        for notification in playerTrajan.notifications()!.notifications() {

            guard case .questCityStateFulfilled(cityState: let tmpCityState, quest: let tmpQuest) = notification.type else {
                continue
            }

            cityState = tmpCityState
            quest = tmpQuest
        }

        XCTAssertEqual(cityState, .amsterdam)
        XCTAssertEqual(quest, .triggerEureka(tech: .irrigation))
    }

    func testTriggerEurekaQuestObsolete() throws {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .triggerEureka(tech: .irrigation)),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        try playerTrajan.techs?.discover(tech: .irrigation, in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore?.type, .triggerEureka(tech: .irrigation))
        XCTAssertNotEqual(questAfter?.type, .triggerEureka(tech: .irrigation))

        var cityState: CityStateType = .vaticanCity
        var quest: CityStateQuestType = .none

        for notification in playerTrajan.notifications()!.notifications() {

            guard case .questCityStateObsolete(cityState: let tmpCityState, quest: let tmpQuest) = notification.type else {
                continue
            }

            cityState = tmpCityState
            quest = tmpQuest
        }

        XCTAssertEqual(cityState, .amsterdam)
        XCTAssertEqual(quest, .triggerEureka(tech: .irrigation))
    }

    func testTriggerInspirationQuestFulfilled() throws {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .triggerInspiration(civic: .stateWorkforce)),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        playerTrajan.civics?.triggerInspiration(for: .stateWorkforce, in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore?.type, .triggerInspiration(civic: .stateWorkforce))
        XCTAssertNotEqual(questAfter?.type, .triggerInspiration(civic: .stateWorkforce))

        var cityState: CityStateType = .vaticanCity
        var quest: CityStateQuestType = .none

        for notification in playerTrajan.notifications()!.notifications() {

            guard case .questCityStateFulfilled(cityState: let tmpCityState, quest: let tmpQuest) = notification.type else {
                continue
            }

            cityState = tmpCityState
            quest = tmpQuest
        }

        XCTAssertEqual(cityState, .amsterdam)
        XCTAssertEqual(quest, .triggerInspiration(civic: .stateWorkforce))
    }

    func testTriggerInspirationQuestObsolete() throws {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .triggerInspiration(civic: .stateWorkforce)),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        try playerTrajan.civics?.discover(civic: .stateWorkforce, in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore?.type, .triggerInspiration(civic: .stateWorkforce))
        XCTAssertNotEqual(questAfter?.type, .triggerInspiration(civic: .stateWorkforce))

        var cityState: CityStateType = .vaticanCity
        var quest: CityStateQuestType = .none

        for notification in playerTrajan.notifications()!.notifications() {

            guard case .questCityStateObsolete(cityState: let tmpCityState, quest: let tmpQuest) = notification.type else {
                continue
            }

            cityState = tmpCityState
            quest = tmpQuest
        }

        XCTAssertEqual(cityState, .amsterdam)
        XCTAssertEqual(quest, .triggerInspiration(civic: .stateWorkforce))
    }

    func testRecruitGreatPersonFulfilled() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .recruitGreatPerson(greatPerson: .greatGeneral)),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        playerTrajan.recruit(greatPerson: .boudica, in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore?.type, .recruitGreatPerson(greatPerson: .greatGeneral))
        XCTAssertNotEqual(questAfter?.type, .recruitGreatPerson(greatPerson: .greatGeneral))

        var cityState: CityStateType = .vaticanCity
        var quest: CityStateQuestType = .none

        for notification in playerTrajan.notifications()!.notifications() {

            guard case .questCityStateFulfilled(cityState: let tmpCityState, quest: let tmpQuest) = notification.type else {
                continue
            }

            cityState = tmpCityState
            quest = tmpQuest
        }

        XCTAssertEqual(cityState, .amsterdam)
        XCTAssertEqual(quest, .recruitGreatPerson(greatPerson: .greatGeneral))
    }

    func testConvertToReligionFulfilled() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        playerTrajanCity.cityReligion?.addReligiousPressure(reason: .followerChangeHolyCity, pressure: 200, for: .buddhism, in: gameModel)

        let playerAmsterdamCity = City(name: "Amsterdam", at: HexPoint(x: 5, y: 5), capital: true, owner: playerAmsterdam)
        playerAmsterdamCity.initialize(in: gameModel)
        gameModel.add(city: playerAmsterdamCity)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .convertToReligion(religion: .buddhism)),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        playerAmsterdamCity.cityReligion?.addReligiousPressure(reason: .followerChangeHolyCity, pressure: 200, for: .buddhism, in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore?.type, .convertToReligion(religion: .buddhism))
        XCTAssertNotEqual(questAfter?.type, .convertToReligion(religion: .buddhism))

        var cityState: CityStateType = .vaticanCity
        var quest: CityStateQuestType = .none

        for notification in playerTrajan.notifications()!.notifications() {

            guard case .questCityStateFulfilled(cityState: let tmpCityState, quest: let tmpQuest) = notification.type else {
                continue
            }

            cityState = tmpCityState
            quest = tmpQuest
        }

        XCTAssertEqual(cityState, .amsterdam)
        XCTAssertEqual(quest, .convertToReligion(religion: .buddhism))
    }

    func testSendTradeRouteQuestFulfilled() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        let playerAmsterdamCity = City(name: "Amsterdam", at: HexPoint(x: 5, y: 5), capital: true, owner: playerAmsterdam)
        playerAmsterdamCity.initialize(in: gameModel)
        gameModel.add(city: playerAmsterdamCity)

        // initial units

        let playerTrajanTrader = Unit(at: HexPoint(x: 15, y: 15), name: "Trader", type: .trader, owner: playerTrajan)
        gameModel.add(unit: playerTrajanTrader)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .sendTradeRoute), for: playerTrajan.leader)

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        _ = playerTrajan.doEstablishTradeRoute(from: playerTrajanCity, to: playerAmsterdamCity, with: playerTrajanTrader, in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore?.type, .sendTradeRoute)
        XCTAssertNotEqual(questAfter?.type, .sendTradeRoute)

        var cityState: CityStateType = .vaticanCity
        var quest: CityStateQuestType = .none

        for notification in playerTrajan.notifications()!.notifications() {

            guard case .questCityStateFulfilled(cityState: let tmpCityState, quest: let tmpQuest) = notification.type else {
                continue
            }

            cityState = tmpCityState
            quest = tmpQuest
        }

        XCTAssertEqual(cityState, .amsterdam)
        XCTAssertEqual(quest, .sendTradeRoute)
    }

    func testDestroyBarbarianOutputQuestFulfilled() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        let playerAmsterdamCity = City(name: "Amsterdam", at: HexPoint(x: 5, y: 5), capital: true, owner: playerAmsterdam)
        playerAmsterdamCity.initialize(in: gameModel)
        gameModel.add(city: playerAmsterdamCity)

        gameModel.tile(at: HexPoint(x: 7, y: 7))?.set(improvement: .barbarianCamp)

        // let playerTrajanTrader = Unit(at: HexPoint(x: 7, y: 7), name: "Barbar", type: .warrior, owner: barbarianPlayer)
        // gameModel.add(unit: playerTrajanTrader)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .destroyBarbarianOutput(location: HexPoint(x: 7, y: 7))),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        playerTrajan.doClearBarbarianCamp(at: gameModel.tile(at: HexPoint(x: 7, y: 7)), in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore?.type, .destroyBarbarianOutput(location: HexPoint(x: 7, y: 7)))
        XCTAssertNotEqual(questAfter?.type, .destroyBarbarianOutput(location: HexPoint(x: 7, y: 7)))

        var cityState: CityStateType = .vaticanCity
        var quest: CityStateQuestType = .none

        for notification in playerTrajan.notifications()!.notifications() {

            guard case .questCityStateFulfilled(cityState: let tmpCityState, quest: let tmpQuest) = notification.type else {
                continue
            }

            cityState = tmpCityState
            quest = tmpQuest
        }

        XCTAssertEqual(cityState, .amsterdam)
        XCTAssertEqual(quest, .destroyBarbarianOutput(location: HexPoint(x: 7, y: 7)))
    }

    func testDestroyBarbarianOutputQuestObsolete() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        let playerAmsterdamCity = City(name: "Amsterdam", at: HexPoint(x: 5, y: 5), capital: true, owner: playerAmsterdam)
        playerAmsterdamCity.initialize(in: gameModel)
        gameModel.add(city: playerAmsterdamCity)

        gameModel.tile(at: HexPoint(x: 7, y: 7))?.set(improvement: .barbarianCamp)

        // let playerTrajanTrader = Unit(at: HexPoint(x: 7, y: 7), name: "Barbar", type: .warrior, owner: barbarianPlayer)
        // gameModel.add(unit: playerTrajanTrader)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .destroyBarbarianOutput(location: HexPoint(x: 7, y: 7))),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        playerAlexander.doClearBarbarianCamp(at: gameModel.tile(at: HexPoint(x: 7, y: 7)), in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore?.type, .destroyBarbarianOutput(location: HexPoint(x: 7, y: 7)))
        XCTAssertNotEqual(questAfter?.type, .destroyBarbarianOutput(location: HexPoint(x: 7, y: 7)))

        var cityState: CityStateType = .vaticanCity
        var quest: CityStateQuestType = .none

        for notification in playerTrajan.notifications()!.notifications() {

            guard case .questCityStateObsolete(cityState: let tmpCityState, quest: let tmpQuest) = notification.type else {
                continue
            }

            cityState = tmpCityState
            quest = tmpQuest
        }

        XCTAssertEqual(cityState, .amsterdam)
        XCTAssertEqual(quest, .destroyBarbarianOutput(location: HexPoint(x: 7, y: 7)))
    }
}
