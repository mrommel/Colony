//
//  MapLoader.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 02.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class MapLoader {

    public init() {

    }

    public func load(from url: URL?, for leader: LeaderType) -> MapModel? {

        if let mapUrl = url {

            do {
                let jsonData = try Data(contentsOf: mapUrl, options: .mappedIfSafe)

                let map = try JSONDecoder().decode(MapModel.self, from: jsonData)

                let numberOfPlayers = 4

                let startPositioner = StartPositioner(on: map, for: numberOfPlayers)
                startPositioner.generateRegions()

                let aiLeaders: [LeaderType] = LeaderType.all.filter({ $0 != leader }).choose(numberOfPlayers - 1)

                startPositioner.chooseLocations(for: aiLeaders, human: leader)

                map.startLocations = startPositioner.startLocations

                return map
            } catch {
                print("Error reading \(error)")
            }
        }

        return nil
    }
}
