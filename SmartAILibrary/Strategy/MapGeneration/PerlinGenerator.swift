//
// Port of a Perlin noise Objective-C implementation in Swift
// Original source https://github.com/czgarrett/perlin-ios
//
// For references on the Perlin algorithm:
// Each of these has a slightly different way of explaining Perlin noise.  They were all useful:
// Overviews of Perlin: http://paulbourke.net/texture_colour/perlin/ and http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
// Awesome C++ tutorial on Perlin: http://www.dreamincode.net/forums/topic/66480-perlin-noise/
//  MIT License:
//  Perlin-Swift Copyright (c) 2015 Lachlan Hurst
//  Perlin-iOS Copyright (C) 2011 by Christopher Z. Garrett
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN

import Foundation

// swiftlint:disable variable_name
public class PerlinGenerator {

    static let kPermutationSize = 256
	static let gradient: [[Int8]] = [
		[1, 1, 1, 0], [1, 1, 0, 1], [1, 0, 1, 1], [0, 1, 1, 1],
		[1, 1, -1, 0], [1, 1, 0, -1], [1, 0, 1, -1], [0, 1, 1, -1],
		[1, -1, 1, 0], [1, -1, 0, 1], [1, 0, -1, 1], [0, 1, -1, 1],
		[1, -1, -1, 0], [1, -1, 0, -1], [1, 0, -1, -1], [0, 1, -1, -1],
		[-1, 1, 1, 0], [-1, 1, 0, 1], [-1, 0, 1, 1], [0, -1, 1, 1],
		[-1, 1, -1, 0], [-1, 1, 0, -1], [-1, 0, 1, -1], [0, -1, 1, -1],
		[-1, -1, 1, 0], [-1, -1, 0, 1], [-1, 0, -1, 1], [0, -1, -1, 1],
		[-1, -1, -1, 0], [-1, -1, 0, -1], [-1, 0, -1, -1], [0, -1, -1, -1]
	]

	var permut: [Int]

	var octaves: Int
	var persistence: Double
	var zoom: Double

	public init() {

        self.permut = []
        self.permut.reserveCapacity(PerlinGenerator.kPermutationSize)
        for _ in 0 ..< PerlinGenerator.kPermutationSize {
            self.permut.append(Int(drand48() * 255))
		}

        self.octaves = 1
        self.persistence = 1.0
        self.zoom = 1.0
	}

	public func gradientAt(i: Int, j: Int, k: Int, l: Int) -> Int {

        return (permut[(l + permut[(k + permut[(j + permut[i & 0xff]) & 0xff]) & 0xff]) & 0xff] & 0x1f)
	}

	public func productOf(a: Double, b: Int8) -> Double {

		if b > 0 {
			return a
		}
		if b < 0 {
			return -a
		}

		return 0
	}

	public func dotProductI(x0: Double, x1: Int8, y0: Double, y1: Int8, z0: Double, z1: Int8, t0: Double, t1: Int8) -> Double {

		return self.productOf(a: x0, b: x1) +
			self.productOf(a: y0, b: y1) +
			self.productOf(a: z0, b: z1) +
			self.productOf(a: t0, b: t1)
	}

	public func spline(state: Double) -> Double {

		let square = state * state
		let cubic = square * state
		return cubic * (6 * square - 15 * state + 10)
	}

	public func interpolate(a: Double, b: Double, x: Double) -> Double {

		return a + x * (b - a)
	}

	public func smoothNoise(x: Double, y: Double, z: Double, t: Double) -> Double {

		let x0 = Int(x > 0 ? x : x - 1)
		let y0 = Int(y > 0 ? y : y - 1)
		let z0 = Int(z > 0 ? z : z - 1)
		let t0 = Int(t > 0 ? t : t - 1)

		let x1 = x0 + 1
		let y1 = y0 + 1
		let z1 = z0 + 1
		let t1 = t0 + 1

		// The vectors
		var dx0 = x - Double(x0)
		var dy0 = y - Double(y0)
		var dz0 = z - Double(z0)
		var dt0 = t - Double(t0)
		let dx1 = x - Double(x1)
		let dy1 = y - Double(y1)
		let dz1 = z - Double(z1)
		let dt1 = t - Double(t1)

		// The 16 gradient values
        let g0000 = PerlinGenerator.gradient[self.gradientAt(i: x0, j: y0, k: z0, l: t0)]
        let g0001 = PerlinGenerator.gradient[self.gradientAt(i: x0, j: y0, k: z0, l: t1)]
        let g0010 = PerlinGenerator.gradient[self.gradientAt(i: x0, j: y0, k: z1, l: t0)]
        let g0011 = PerlinGenerator.gradient[self.gradientAt(i: x0, j: y0, k: z1, l: t1)]
        let g0100 = PerlinGenerator.gradient[self.gradientAt(i: x0, j: y1, k: z0, l: t0)]
        let g0101 = PerlinGenerator.gradient[self.gradientAt(i: x0, j: y1, k: z0, l: t1)]
        let g0110 = PerlinGenerator.gradient[self.gradientAt(i: x0, j: y1, k: z1, l: t0)]
        let g0111 = PerlinGenerator.gradient[self.gradientAt(i: x0, j: y1, k: z1, l: t1)]
        let g1000 = PerlinGenerator.gradient[self.gradientAt(i: x1, j: y0, k: z0, l: t0)]
        let g1001 = PerlinGenerator.gradient[self.gradientAt(i: x1, j: y0, k: z0, l: t1)]
        let g1010 = PerlinGenerator.gradient[self.gradientAt(i: x1, j: y0, k: z1, l: t0)]
        let g1011 = PerlinGenerator.gradient[self.gradientAt(i: x1, j: y0, k: z1, l: t1)]
        let g1100 = PerlinGenerator.gradient[self.gradientAt(i: x1, j: y1, k: z0, l: t0)]
        let g1101 = PerlinGenerator.gradient[self.gradientAt(i: x1, j: y1, k: z0, l: t1)]
        let g1110 = PerlinGenerator.gradient[self.gradientAt(i: x1, j: y1, k: z1, l: t0)]
        let g1111 = PerlinGenerator.gradient[self.gradientAt(i: x1, j: y1, k: z1, l: t1)]

		// The 16 dot products
		let b0000 = self.dotProductI(x0: dx0, x1: g0000[0], y0: dy0, y1: g0000[1], z0: dz0, z1: g0000[2], t0: dt0, t1: g0000[3])
		let b0001 = self.dotProductI(x0: dx0, x1: g0001[0], y0: dy0, y1: g0001[1], z0: dz0, z1: g0001[2], t0: dt1, t1: g0001[3])
		let b0010 = self.dotProductI(x0: dx0, x1: g0010[0], y0: dy0, y1: g0010[1], z0: dz1, z1: g0010[2], t0: dt0, t1: g0010[3])
		let b0011 = self.dotProductI(x0: dx0, x1: g0011[0], y0: dy0, y1: g0011[1], z0: dz1, z1: g0011[2], t0: dt1, t1: g0011[3])
		let b0100 = self.dotProductI(x0: dx0, x1: g0100[0], y0: dy1, y1: g0100[1], z0: dz0, z1: g0100[2], t0: dt0, t1: g0100[3])
		let b0101 = self.dotProductI(x0: dx0, x1: g0101[0], y0: dy1, y1: g0101[1], z0: dz0, z1: g0101[2], t0: dt1, t1: g0101[3])
		let b0110 = self.dotProductI(x0: dx0, x1: g0110[0], y0: dy1, y1: g0110[1], z0: dz1, z1: g0110[2], t0: dt0, t1: g0110[3])
		let b0111 = self.dotProductI(x0: dx0, x1: g0111[0], y0: dy1, y1: g0111[1], z0: dz1, z1: g0111[2], t0: dt1, t1: g0111[3])
		let b1000 = self.dotProductI(x0: dx1, x1: g1000[0], y0: dy0, y1: g1000[1], z0: dz0, z1: g1000[2], t0: dt0, t1: g1000[3])
		let b1001 = self.dotProductI(x0: dx1, x1: g1001[0], y0: dy0, y1: g1001[1], z0: dz0, z1: g1001[2], t0: dt1, t1: g1001[3])
		let b1010 = self.dotProductI(x0: dx1, x1: g1010[0], y0: dy0, y1: g1010[1], z0: dz1, z1: g1010[2], t0: dt0, t1: g1010[3])
		let b1011 = self.dotProductI(x0: dx1, x1: g1011[0], y0: dy0, y1: g1011[1], z0: dz1, z1: g1011[2], t0: dt1, t1: g1011[3])
		let b1100 = self.dotProductI(x0: dx1, x1: g1100[0], y0: dy1, y1: g1100[1], z0: dz0, z1: g1100[2], t0: dt0, t1: g1100[3])
		let b1101 = self.dotProductI(x0: dx1, x1: g1101[0], y0: dy1, y1: g1101[1], z0: dz0, z1: g1101[2], t0: dt1, t1: g1101[3])
		let b1110 = self.dotProductI(x0: dx1, x1: g1110[0], y0: dy1, y1: g1110[1], z0: dz1, z1: g1110[2], t0: dt0, t1: g1110[3])
		let b1111 = self.dotProductI(x0: dx1, x1: g1111[0], y0: dy1, y1: g1111[1], z0: dz1, z1: g1111[2], t0: dt1, t1: g1111[3])

		dx0 = self.spline(state: dx0)
		dy0 = self.spline(state: dy0)
		dz0 = self.spline(state: dz0)
		dt0 = self.spline(state: dt0)

		let b111 = self.interpolate(a: b1110, b: b1111, x: dt0)
		let b110 = self.interpolate(a: b1100, b: b1101, x: dt0)
		let b101 = self.interpolate(a: b1010, b: b1011, x: dt0)
		let b100 = self.interpolate(a: b1000, b: b1001, x: dt0)
		let b011 = self.interpolate(a: b0110, b: b0111, x: dt0)
		let b010 = self.interpolate(a: b0100, b: b0101, x: dt0)
		let b001 = self.interpolate(a: b0010, b: b0011, x: dt0)
		let b000 = self.interpolate(a: b0000, b: b0001, x: dt0)

		let b11 = self.interpolate(a: b110, b: b111, x: dz0)
		let b10 = self.interpolate(a: b100, b: b101, x: dz0)
		let b01 = self.interpolate(a: b010, b: b011, x: dz0)
		let b00 = self.interpolate(a: b000, b: b001, x: dz0)

		let b1 = self.interpolate(a: b10, b: b11, x: dy0)
		let b0 = self.interpolate(a: b00, b: b01, x: dy0)

		let result = self.interpolate(a: b0, b: b1, x: dx0)

		return result
	}

	public func perlinNoise(x: Double, y: Double, z: Double, t: Double) -> Double {

		var noise: Double = 0.0
		for octave in 0..<self.octaves {
			let frequency: Double = pow(2, Double(octave))
			let amplitude = pow(self.persistence, Double(octave))

			noise += self.smoothNoise(x: x * frequency / zoom,
				y: y * frequency / zoom,
				z: z * frequency / zoom,
				t: t * frequency / zoom) * amplitude
		}
		return noise
	}
}
// swiftlint:enable variable_name
