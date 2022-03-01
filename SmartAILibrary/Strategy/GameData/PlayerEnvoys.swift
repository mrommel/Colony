//
//  PlayerEnvoys.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 01.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractPlayerEnvoys: AnyObject, Codable {

    var player: AbstractPlayer? { get set }

    func meet(cityState: CityStateType, isFirst: Bool)
    func envoys(in cityState: CityStateType) -> Int
    func assignEnvoy(to cityState: CityStateType)
    func unassignEnvoy(from cityState: CityStateType)
}

public class PlayerEnvoys: AbstractPlayerEnvoys {

    enum CodingKeys: CodingKey {

        case envoyArray
    }

    // user properties / values
    public var player: AbstractPlayer?

    private let envoyArray: WeightedList<CityStateType>
    private var unassignedEnvoys: Int

    // MARK: constructor

    init(player: Player?) {

        self.player = player

        self.envoyArray = WeightedList<CityStateType>()
        self.unassignedEnvoys = 0
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.envoyArray = try container.decode(WeightedList<CityStateType>.self, forKey: .envoyArray)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.envoyArray, forKey: .envoyArray)
    }

    public func meet(cityState: CityStateType, isFirst: Bool) {

        self.envoyArray.add(weight: isFirst ? 1 : 0, for: cityState)
    }

    public func envoys(in cityState: CityStateType) -> Int {

        return Int(self.envoyArray.weight(of: cityState))
    }

    public func assignEnvoy(to cityState: CityStateType) {

        self.envoyArray.add(weight: 1, for: cityState)
    }

    public func unassignEnvoy(from cityState: CityStateType) {

        self.envoyArray.add(weight: -1, for: cityState)
    }
}
