//
//  CityStateQuestType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 01.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public enum CityStateQuestType {

    case none
    
    case trainUnit(type: UnitType) // Train a certain unit. (Will be lost if the unit becomes obsolete.)
    case constructDistrict(type: DistrictType) // Construct a certain district.
    case triggerEureka(tech: TechType) // Trigger a Eureka Eureka for a certain tech. (Can be completed by a Spy that succeeds at a Steal Tech Boost mission. Will be lost if you research the tech.)
    case triggerInspiration(civic: CivicType) // Trigger an Inspiration Inspiration for a certain civic. (Will be lost if you unlock the civic.)
    case recruitGreatPerson(greatPerson: GreatPersonType) // Recruit a certain type of Great Person Great Person.
    case convertToReligion(religion: ReligionType) // Convert the city-state to your religion. (Given only if you have founded a religion.)
    case sendTradeRoute // Send a Trade Route Trade Route to the city-state.
    case destroyBarbarianOutput(location: HexPoint) // Destroy a Barbarian Outpost within 5 tiles of the city-state. (Will be lost if anyone else destroys it first.)
}