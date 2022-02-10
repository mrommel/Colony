//
//  GameLoader.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public class GameLoader {

    public init() {

    }

    public func load(from url: URL?) -> GameModel? {

        if let gameUrl = url {

            do {
                let jsonData = try Data(contentsOf: gameUrl, options: .mappedIfSafe)

                let gameModel = try JSONDecoder().decode(GameModel.self, from: jsonData)

                return gameModel
            } catch {
                print("Error reading \(error)")
            }
        }

        return nil
    }
}
