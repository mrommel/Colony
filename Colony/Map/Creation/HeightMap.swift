//
//  HeightMap.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class HeightMap: Array2D<Double> {

	required init(width: Int, height: Int) {

		super.init(columns: width, rows: height)

		self.generate(withOctaves: 4, zoom: 80, andPersistence: 0.52)
		self.normalize()
	}

	required init(width: Int, height: Int, octaves: Int, zoom: Double, andPersistence persistence: Double) {

		super.init(columns: width, rows: height)

		self.generate(withOctaves: octaves, zoom: zoom, andPersistence: persistence)
		self.normalize()
	}
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
	/**
	generates the heightmap based on the input parameters
	
	- parameter octaves: 4
	- parameter zoom: 80
	- parameter persistence: 0.52
	*/
	func generate(withOctaves octaves: Int, zoom: Double, andPersistence persistence: Double) {

		let generator = PerlinGenerator()

		generator.octaves = octaves
		generator.zoom = zoom
		generator.persistence = persistence

		for x in 0..<self.columns {
			for y in 0..<self.rows {

				let value0 = 1.00 * generator.perlinNoise(x: 1.0 * Double(x), y: 1.0 * Double(y), z: 0, t: 0)
				let value1 = 0.50 * generator.perlinNoise(x: 2.0 * Double(x), y: 2.0 * Double(y), z: 0, t: 0)
				let value2 = 0.25 * generator.perlinNoise(x: 4.0 * Double(x), y: 4.0 * Double(y), z: 0, t: 0)

				var value = abs(value0 + value1 + value2)
				if value > 1 {
					value = 1
				}

				self[x, y] = pow(value, 1.97)
			}
		}
	}

	func percentage(below threshold: Double) -> Double {

		var belowNum: Double = 0
		var aboveNum: Double = 0

		for x in 0..<self.columns {
			for y in 0..<self.rows {
				let value = self[x, y]
				if value! < threshold {
					belowNum += 1.0
				} else {
					aboveNum += 1.0
				}
			}
		}

		return Double(belowNum / (belowNum + aboveNum))
	}
    
    func percentage(above threshold: Double) -> Double {
        
        var belowNum: Double = 0
        var aboveNum: Double = 0
        
        for x in 0..<self.columns {
            for y in 0..<self.rows {
                let value = self[x, y]
                if value! < threshold {
                    belowNum += 1.0
                } else {
                    aboveNum += 1.0
                }
            }
        }
        
        return Double(aboveNum / (belowNum + aboveNum))
    }

	func findWaterLevel(forWaterPercentage waterPercentage: Double) -> Double {

		var waterLevel: Double = 0.05
		var calculatedWaterPercentage: Double = self.percentage(below: waterLevel)

		while calculatedWaterPercentage < waterPercentage {
			waterLevel += 0.05
			calculatedWaterPercentage = self.percentage(below: waterLevel)
		}

		return waterLevel
	}
    
    func findPeakLevel(forPeakPercentage peakPercentage: Double) -> Double {
        
        var peakLevel: Double = 1.0
        var calculatedPeakPercentage: Double = self.percentage(above: peakLevel)
        
        while calculatedPeakPercentage < peakPercentage {
            peakLevel -= 0.05
            calculatedPeakPercentage = self.percentage(above: peakLevel)
        }
        
        return peakLevel
    }

	func normalize() {

		var maxValue: Double = Double.leastNormalMagnitude
		var minValue: Double = Double.greatestFiniteMagnitude

		// find min / max
		for x in 0..<self.columns {
			for y in 0..<self.rows {
				if let value = self[x, y] {
					maxValue = max(maxValue, value)
					minValue = min(minValue, value)
				}
			}
		}

		// scale
		// min:2 - max:4 => 3 = 0.5
		for x in 0..<self.columns {
			for y in 0..<self.rows {
				if let value = self[x, y] {
					self[x, y] = (value - minValue) / (maxValue - minValue)
				}
			}
		}
	}
}
