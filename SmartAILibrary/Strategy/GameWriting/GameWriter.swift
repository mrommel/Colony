//
//  GameWriter.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public class GameWriter {

    public init() {

    }

    public func write(game: GameModel?, to url: URL?) -> Bool {

        guard let url = url else {
            print("cant write game - no url provided")
            return false
        }

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(game)
            let string = String(data: data, encoding: .utf8)!

            try string.write(to: url, atomically: true, encoding: String.Encoding.utf8)

            return true
        } catch {
            print("Cant store game: \(error)")
            return false
        }
    }
}
