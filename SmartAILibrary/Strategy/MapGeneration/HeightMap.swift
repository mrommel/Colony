//
//  HeightMap.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

// https://www.redblobgames.com/maps/terrain-from-noise/
public class HeightMap: Array2D<Double> {

    private let tau = .pi * 2.0

    public required override init(width: Int, height: Int) {

        super.init(width: width, height: height)

        self.generate(withOctaves: 4, zoom: 1.0, andPersistence: 1.0)
		self.normalize()
	}

    public required init(width: Int, height: Int, octaves: Int, zoom: Double, andPersistence persistence: Double) {

        super.init(width: width, height: height)

		self.generate(withOctaves: octaves, zoom: zoom, andPersistence: persistence)
		self.normalize()
	}

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

	/**
	generates the heightmap based on the input parameters
	
	- parameter octaves: 4
	- parameter zoom: 1.0
	- parameter persistence: 1.0
	*/
    public func generate(withOctaves octaves: Int, zoom: Double, andPersistence persistence: Double) {

		let generator = PerlinGenerator()

		generator.octaves = octaves
		generator.zoom = zoom
		generator.persistence = persistence

		for x in 0..<self.width {
            for y in 0..<self.height {

                let nx = Double(x) / Double(self.width) - 0.5
                let ny = Double(y) / Double(self.height) - 0.5

                let angle_x = self.tau * nx

                /* In "noise parameter space", we need nx and ny to travel the
                       same distance. The circle created from nx needs to have
                       circumference=1 to match the length=1 line created from ny,
                       which means the circle's radius is 1/2π, or 1/tau */

                // self[x, y] = generator.perlinNoise(x: cos(angle_x) / self.tau, y: sin(angle_x) / self.tau, z: ny, t: 0)

				let value0 = 1.00 * generator.perlinNoise(x: 1.0 * cos(angle_x) / self.tau, y: 1.0 * sin(angle_x) / self.tau, z: 1.0 * ny, t: 0)
				let value1 = 0.50 * generator.perlinNoise(x: 2.0 * cos(angle_x) / self.tau, y: 2.0 * sin(angle_x) / self.tau, z: 2.0 * ny, t: 0)
                let value2 = 0.25 * generator.perlinNoise(x: 4.0 * cos(angle_x) / self.tau, y: 4.0 * sin(angle_x) / self.tau, z: 4.0 * ny, t: 0)
                let value3 = 0.125 * generator.perlinNoise(x: 8.0 * cos(angle_x) / self.tau, y: 8.0 * sin(angle_x) / self.tau, z: 8.0 * ny, t: 0)

                var value = abs(value0 + value1 + value2 + value3) / 1.875
                if value > 1.0 {
                    value = 1.0
				}

                self[x, y] = pow(value, 4.0) // 1.97
			}
		}
	}

	func percentage(below threshold: Double) -> Double {

		var belowNum: Double = 0
		var aboveNum: Double = 0

		for x in 0..<self.width {
			for y in 0..<self.height {
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

	func findThresholdBelow(percentage: Double) -> Double {

        var tmpArray: [Double] = []

        // fill from map
        for x in 0..<self.width {
            for y in 0..<self.height {
                if let value = self[x, y] {
                    tmpArray.append(value)
                }
            }
        }

        // sorted smallest first, highest last
        tmpArray.sort()

        let thresholdIndex: Int = Int(Double(tmpArray.count) * percentage)

        return tmpArray[thresholdIndex - 1]
	}

    /// this function takes the complete height map into account
    /// for land only - please multiply with land values
    func findThresholdAbove(percentage: Double) -> Double {

        var tmpArray: [Double] = []

        // fill from map
        for x in 0..<self.width {
            for y in 0..<self.height {
                if let value = self[x, y] {
                    tmpArray.append(value)
                }
            }
        }

        // sorted smallest first, highest last
        tmpArray.sort()
        tmpArray.reverse()

        let thresholdIndex: Int = Int(Double(tmpArray.count) * percentage)

        return tmpArray[thresholdIndex - 1]
    }

    public func normalize() {

		var maxValue: Double = Double.leastNormalMagnitude
		var minValue: Double = Double.greatestFiniteMagnitude

		// find min / max
		for x in 0..<self.width {
			for y in 0..<self.height {
				if let value = self[x, y] {
					maxValue = max(maxValue, value)
					minValue = min(minValue, value)
				}
			}
		}

		// scale
		// min:2 - max:4 => 3 = 0.5
		for x in 0..<self.width {
			for y in 0..<self.height {
				if let value = self[x, y] {
					self[x, y] = (value - minValue) / (maxValue - minValue)
				}
			}
		}
	}
}
