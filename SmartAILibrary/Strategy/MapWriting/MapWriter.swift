//
//  MapWriter.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.12.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class MapWriter {

    public init() {

    }

    public func write(map: MapModel?, to url: URL?) -> Bool {

        guard let url = url else {
            print("cant write map - no url provided")
            return false
        }

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(map)
            let string = String(data: data, encoding: .utf8)!

            try string.write(to: url, atomically: true, encoding: String.Encoding.utf8)

            return true
        } catch {
            print("Cant store map: \(error)")
            return false
        }
    }
}
