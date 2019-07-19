//
//  OceanFinder.swift
//  Colony
//
//  Created by Michael Rommel on 18.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class OceanFinder {
    
    private var oceanIdentifiers: Array2D<Int>
    
    init(width: Int, height: Int) {
        
        self.oceanIdentifiers = Array2D<Int>(columns: width, rows: height)
        self.oceanIdentifiers.fill(with: OceanConstants.kNotAnalyzed)
    }
    
    func evaluated(value: Int) -> Bool {
        
        return value != OceanConstants.kNotAnalyzed && value != OceanConstants.kNoOcean
    }
    
    @discardableResult
    func execute(on map: HexagonTileMap) -> [Ocean] {
        
        for x in 0..<self.oceanIdentifiers.columns {
            for y in 0..<self.oceanIdentifiers.rows {
                
                self.evaluate(x: x, y: y, on: map)
            }
        }
        
        var oceans = [Ocean]()
        
        for x in 0..<self.oceanIdentifiers.columns {
            for y in 0..<self.oceanIdentifiers.rows {
                
                let oceanIdentifier = self.oceanIdentifiers[x, y]
                
                if self.evaluated(value: oceanIdentifier!) {
                    
                    var ocean = oceans.first(where: { $0.identifier == oceanIdentifier })
                    
                    if ocean == nil {
                        ocean = Ocean(identifier: oceanIdentifier!, name: "Ocean \(oceanIdentifier ?? -1)", on: map)
                        oceans.append(ocean!)
                    }
                    
                    map.set(ocean: ocean, at: HexPoint(x: x, y: y))
                    
                    ocean?.add(point: HexPoint(x: x, y: y))
                }
            }
        }
        
        return oceans
    }
    
    func evaluate(x: Int, y: Int, on map: HexagonTileMap) {
        
        let currentPoint = HexPoint(x: x, y: y)
        
        if map.tile(at: currentPoint)?.isWater ?? false {
            
            let northPoint = currentPoint.neighbor(in: .north)
            let nortwestPoint = currentPoint.neighbor(in: .northwest)
            let southPoint = currentPoint.neighbor(in: .southwest)
            
            let northContinent = map.valid(point: northPoint) ? self.oceanIdentifiers[northPoint.x, northPoint.y] : OceanConstants.kNotAnalyzed
            let nortwestContinent = map.valid(point: nortwestPoint) ? self.oceanIdentifiers[nortwestPoint.x, nortwestPoint.y] : OceanConstants.kNotAnalyzed
            let southContinent = map.valid(point: southPoint) ? self.oceanIdentifiers[southPoint.x, southPoint.y] : OceanConstants.kNotAnalyzed
            
            if self.evaluated(value: northContinent!) {
                self.oceanIdentifiers[x, y] = northContinent
            } else if self.evaluated(value: nortwestContinent!) {
                self.oceanIdentifiers[x, y] = nortwestContinent
            } else if self.evaluated(value: southContinent!) {
                self.oceanIdentifiers[x, y] = southContinent
            } else {
                let freeIdentifier = self.firstFreeIdentifier()
                self.oceanIdentifiers[x, y] = freeIdentifier
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
            self.oceanIdentifiers[x, y] = OceanConstants.kNoOcean
        }
    }
    
    func firstFreeIdentifier() -> Int {
        
        let freeIdentifiers = BitArray(count: 256)
        
        for i in 0..<256 {
            freeIdentifiers.setValueOfBit(value: true, at: i)
        }
        
        for x in 0..<self.oceanIdentifiers.columns {
            for y in 0..<self.oceanIdentifiers.rows {
                
                if let oceanIndex = self.oceanIdentifiers[x, y] {
                    if oceanIndex >= 0 && oceanIndex < 256 {
                        freeIdentifiers.setValueOfBit(value: false, at: oceanIndex)
                    }
                }
            }
        }
        
        for i in 0..<256 {
            if freeIdentifiers.valueOfBit(at: i) == true {
                return i
            }
        }
        
        return OceanConstants.kNoOcean
    }
    
    func replace(oldIdentifier: Int, withIdentifier newIdentifier: Int) {
        
        for x in 0..<self.oceanIdentifiers.columns {
            for y in 0..<self.oceanIdentifiers.rows {
                
                if self.oceanIdentifiers[x, y] == oldIdentifier {
                    self.oceanIdentifiers[x, y] = newIdentifier
                }
            }
        }
    }
}
