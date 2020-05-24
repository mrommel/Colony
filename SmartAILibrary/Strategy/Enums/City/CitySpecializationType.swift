//
//  CitySpecializationType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum CitySpecializationType: Int, Codable {
    
    case none
    
    case settlerPump // CITYSPECIALIZATION_SETTLER_PUMP
    case militaryTraining // CITYSPECIALIZATION_MILITARY_TRAINING
    case emergencyUnits // CITYSPECIALIZATION_EMERGENCY_UNITS
    case militaryNaval // CITYSPECIALIZATION_MILITARY_NAVAL
    case productionWonder // CITYSPECIALIZATION_PRODUCTION_WONDER
    // CITYSPECIALIZATION_PRODUCTION_SPACESHIP
    case commerce // CITYSPECIALIZATION_COMMERCE
    case science // CITYSPECIALIZATION_SCIENCE
    case generalEconomic // CITYSPECIALIZATION_GENERAL_ECONOMIC
    
    static var all: [CitySpecializationType] {
        return [.settlerPump, .militaryTraining, .emergencyUnits, .militaryNaval, .productionWonder, .commerce, .science, .generalEconomic]
    }
    
    func name() -> String {
        
        return self.data().name
    }
    
    func yieldType() -> YieldType? {
        
        return self.data().yield
    }
    
    func isDefault() -> Bool {
        
        return self.data().isDefault
    }
    
    func isWonder() -> Bool {
        
        return self.data().isWonder
    }
    
    func isOperationUnitProvider() -> Bool {
        
        return self.data().isOperationUnitProvider
    }
    
    func mustBeCoastal() -> Bool {
        
        return self.data().mustBeCoastal
    }
    
    func flavorModifier() -> [Flavor] {
        
        return self.data().flavors
    }
    
    func flavorModifier(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavorModifier().first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return 0
    }
    
    // private
    
    struct CitySpecializationTypeData {
        
        let name: String
        let yield: YieldType?
        let isDefault: Bool
        let isWonder: Bool
        let isOperationUnitProvider: Bool
        let mustBeCoastal: Bool
        let flavors: [Flavor]
    }
    
    private func data() -> CitySpecializationTypeData {
        
        switch self {
        case .none: return CitySpecializationTypeData(name: "None", yield: nil, isDefault: false, isWonder: false, isOperationUnitProvider: false, mustBeCoastal: false, flavors: [])
            
        case .settlerPump: return CitySpecializationTypeData(name: "settlerPump", yield: .food, isDefault: false, isWonder: false, isOperationUnitProvider: false, mustBeCoastal: false, flavors: [Flavor(type: .expansion, value: 30), Flavor(type: .production, value: -4), Flavor(type: .gold, value: -4), Flavor(type: .science, value: -4), Flavor(type: .mobile, value: -2), Flavor(type: .navalGrowth, value: -5)/*, Flavor(type: .waterConnection, value: -5)*/, Flavor(type: .culture, value: -4), Flavor(type: .wonder, value: -6), Flavor(type: .offense, value: -4), Flavor(type: .defense, value: -4), Flavor(type: .ranged, value: -4), Flavor(type: .naval, value: -4), Flavor(type: .militaryTraining, value: -6)])
            
        case .militaryTraining: return CitySpecializationTypeData(name: "militaryTraining", yield: .production, isDefault: false, isWonder: false, isOperationUnitProvider: true, mustBeCoastal: false, flavors: [Flavor(type: .expansion, value: -4), Flavor(type: .growth, value: -4), Flavor(type: .production, value: -4), Flavor(type: .gold, value: -4), Flavor(type: .science, value: -4), Flavor(type: .offense, value: 20), Flavor(type: .defense, value: 20), Flavor(type: .ranged, value: 10), Flavor(type: .militaryTraining, value: 20), Flavor(type: .naval, value: -4)])
            
        case .emergencyUnits: return CitySpecializationTypeData(name: "emergencyUnits", yield: .production, isDefault: false, isWonder: false, isOperationUnitProvider: true, mustBeCoastal: false, flavors: [Flavor(type: .expansion, value: -4), Flavor(type: .growth, value: -4), Flavor(type: .production, value: -4), Flavor(type: .gold, value: -4), Flavor(type: .science, value: -4), Flavor(type: .defense, value: 200), Flavor(type: .ranged, value: 100), Flavor(type: .militaryTraining, value: -4), Flavor(type: .naval, value: -25), Flavor(type: .recon, value: -25)])
            
        case .militaryNaval: return CitySpecializationTypeData(name: "militaryNaval", yield: .production, isDefault: false, isWonder: false, isOperationUnitProvider: false, mustBeCoastal: true, flavors: [Flavor(type: .expansion, value: -4), Flavor(type: .growth, value: -4), Flavor(type: .production, value: -4), Flavor(type: .gold, value: -4), Flavor(type: .science, value: -4), Flavor(type: .naval, value: 200), Flavor(type: .navalRecon, value: 100), Flavor(type: .offense, value: -25), Flavor(type: .defense, value: -25), Flavor(type: .ranged, value: -25)])
            
        case .productionWonder: return CitySpecializationTypeData(name: "productionWonder", yield: .production, isDefault: false, isWonder: true, isOperationUnitProvider: false, mustBeCoastal: false, flavors: [Flavor(type: .expansion, value: -4), Flavor(type: .growth, value: -4), Flavor(type: .production, value: -4), Flavor(type: .gold, value: -4), Flavor(type: .science, value: -4), Flavor(type: .wonder, value: 30), Flavor(type: .offense, value: -4), Flavor(type: .defense, value: -4), Flavor(type: .ranged, value: -4), Flavor(type: .naval, value: -4)])
            
        case .commerce: return CitySpecializationTypeData(name: "commerce", yield: .gold, isDefault: false, isWonder: false, isOperationUnitProvider: false, mustBeCoastal: false, flavors: [Flavor(type: .expansion, value: -4), Flavor(type: .culture, value: 10), Flavor(type: .production, value: 10), Flavor(type: .gold, value: 30), Flavor(type: .science, value: 10), Flavor(type: .happiness, value: 10), Flavor(type: .greatPeople, value: 5), Flavor(type: .offense, value: -4), Flavor(type: .defense, value: -4), Flavor(type: .ranged, value: -4), Flavor(type: .naval, value: -4)/*, Flavor(type: .waterConnection, value: 20)*/])
            
        case .science: return CitySpecializationTypeData(name: "science", yield: .science, isDefault: false, isWonder: false, isOperationUnitProvider: false, mustBeCoastal: false, flavors: [Flavor(type: .expansion, value: -4), Flavor(type: .culture, value: 10), Flavor(type: .production, value: 10), Flavor(type: .gold, value: 10), Flavor(type: .science, value: 30), Flavor(type: .happiness, value: 10), Flavor(type: .greatPeople, value: 5), Flavor(type: .offense, value: -4), Flavor(type: .defense, value: -4), Flavor(type: .ranged, value: -4), Flavor(type: .naval, value: -4)])
            
        case .generalEconomic: return CitySpecializationTypeData(name: "generalEconomic", yield: .production, isDefault: true, isWonder: false, isOperationUnitProvider: false, mustBeCoastal: false, flavors: [Flavor(type: .expansion, value: -4), Flavor(type: .culture, value: 30), Flavor(type: .production, value: 20), Flavor(type: .gold, value: 20), Flavor(type: .science, value: 20), Flavor(type: .happiness, value: 20), Flavor(type: .greatPeople, value: 10), Flavor(type: .offense, value: -4), Flavor(type: .defense, value: -4), Flavor(type: .ranged, value: -4), Flavor(type: .naval, value: -4)])
        }
    }
}
