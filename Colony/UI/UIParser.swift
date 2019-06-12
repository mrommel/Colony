//
//  UIParser.swift
//  Colony
//
//  Created by Michael Rommel on 10.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import XMLParsing
import SpriteKit

class UIParser: NSObject {

    var dialogConfiguration: DialogConfiguration?

    override init() {

    }

    func parse(from name: String) -> DialogConfiguration? {

        if let filePath = Bundle.main.url(forResource: name, withExtension: "xml") {
            do {
                let data = try Data(contentsOf: filePath)

                let decoder = XMLDecoder()

                do {
                    return try decoder.decode(DialogConfiguration.self, from: data)
                } catch {
                    fatalError("can't parse xml because \(error)")
                }

            } catch {
                fatalError("contents could not be loaded")
            }
        } else {
            fatalError("file \(name) could not be found")
        }

        return nil
    }
}

