//
//  ContinentFinder.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class ContinentFinder {

    private var continentIdentifiers: Array2D<Int>

    public init(width: Int, height: Int) {

        self.continentIdentifiers = Array2D<Int>(width: width, height: height)
        self.continentIdentifiers.fill(with: ContinentConstants.kNotAnalyzed)
    }

    public convenience init(size: MapSize) {

        self.init(width: size.width(), height: size.height())
    }

    func evaluated(value: Int) -> Bool {

        return value != ContinentConstants.kNotAnalyzed && value != ContinentConstants.kNoContinent
    }

    @discardableResult
    public func execute(on map: MapModel?) -> [Continent] {

        for x in 0..<self.continentIdentifiers.width {
            for y in 0..<self.continentIdentifiers.height {

                self.evaluate(x: x, y: y, on: map)
            }
        }

        var continents = [Continent]()

        for x in 0..<self.continentIdentifiers.width {
            for y in 0..<self.continentIdentifiers.height {

                let continentIdentifier = self.continentIdentifiers[x, y]

                if self.evaluated(value: continentIdentifier!) {

                    var continent = continents.first(where: { $0.identifier == continentIdentifier })

                    if continent == nil {
                        continent = Continent(identifier: continentIdentifier!, name: "Continent \(continentIdentifier ?? -1)", on: map)
                        continents.append(continent!)
                    }

                    map?.set(continent: continent, at: HexPoint(x: x, y: y))

                    continent?.add(point: HexPoint(x: x, y: y))
                }
            }
        }

        return continents
    }

    func evaluate(x: Int, y: Int, on map: MapModel?) {

        let currentPoint = HexPoint(x: x, y: y)

        if map?.tile(at: currentPoint)?.terrain().isLand() ?? false {

            let northPoint = currentPoint.neighbor(in: .north)
            let nortwestPoint = currentPoint.neighbor(in: .northwest)
            let southPoint = currentPoint.neighbor(in: .southwest)

            let northContinent = (map?.valid(point: northPoint) ?? false) ?
                self.continentIdentifiers[northPoint.x, northPoint.y] : ContinentConstants.kNotAnalyzed
            let nortwestContinent = (map?.valid(point: nortwestPoint) ?? false) ?
                self.continentIdentifiers[nortwestPoint.x, nortwestPoint.y] : ContinentConstants.kNotAnalyzed
            let southContinent = (map?.valid(point: southPoint) ?? false) ?
                self.continentIdentifiers[southPoint.x, southPoint.y] : ContinentConstants.kNotAnalyzed

            if self.evaluated(value: northContinent!) {
                self.continentIdentifiers[x, y] = northContinent
            } else if self.evaluated(value: nortwestContinent!) {
                self.continentIdentifiers[x, y] = nortwestContinent
            } else if self.evaluated(value: southContinent!) {
                self.continentIdentifiers[x, y] = southContinent
            } else {
                let freeIdentifier = self.firstFreeIdentifier()
                self.continentIdentifiers[x, y] = freeIdentifier
            }

            // handle continent joins
            if self.evaluated(value: northContinent!) && self.evaluated(value: nortwestContinent!) && northContinent != nortwestContinent {
                self.replace(oldIdentifier: nortwestContinent!, withIdentifier: northContinent!)
            } else if self.evaluated(value: nortwestContinent!) && self.evaluated(value: southContinent!) && nortwestContinent != southContinent {
                self.replace(oldIdentifier: nortwestContinent!, withIdentifier: southContinent!)
            } else if self.evaluated(value: northContinent!) && self.evaluated(value: southContinent!) && northContinent != southContinent {
                self.replace(oldIdentifier: northContinent!, withIdentifier: southContinent!)
            }

        } else {
            self.continentIdentifiers[x, y] = ContinentConstants.kNoContinent
        }
    }

    func firstFreeIdentifier() -> Int {

        let freeIdentifiers = BitArray(count: 256)

        for index in 0..<256 {
            freeIdentifiers.setValueOfBit(value: true, at: index)
        }

        for x in 0..<self.continentIdentifiers.width {
            for y in 0..<self.continentIdentifiers.height {

                if let continentIndex = self.continentIdentifiers[x, y] {
                    if continentIndex >= 0 && continentIndex < 256 {
                        freeIdentifiers.setValueOfBit(value: false, at: continentIndex)
                    }
                }
            }
        }

        for index in 0..<256 {
            if freeIdentifiers.valueOfBit(at: index) == true {
                return index
            }
        }

        return ContinentConstants.kNoContinent
    }

    func replace(oldIdentifier: Int, withIdentifier newIdentifier: Int) {

        for x in 0..<self.continentIdentifiers.width {
            for y in 0..<self.continentIdentifiers.height {

                if self.continentIdentifiers[x, y] == oldIdentifier {
                    self.continentIdentifiers[x, y] = newIdentifier
                }
            }
        }
    }
}
