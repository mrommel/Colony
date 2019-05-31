//
//  HexLayout.swift
//  agents
//
//  Created by Michael Rommel on 31.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SceneKit

class HexOrientation {

	let f0, f1, f2, f3: Double
	let b0, b1, b2, b3: Double
	let startAngle: Double // in multiples of 60°

	init(f0: Double, f1: Double, f2: Double, f3: Double, b0: Double, b1: Double, b2: Double, b3: Double, startAngle: Double) {

		self.f0 = f0
		self.f1 = f1
		self.f2 = f2
		self.f3 = f3
		self.b0 = b0
		self.b1 = b1
		self.b2 = b2
		self.b3 = b3
		self.startAngle = startAngle
	}

	static let flat = HexOrientation(f0: 3.0 / 2.0, f1: 0, f2: sqrt(3.0) / 2.0, f3: sqrt(3.0), b0: 2.0 / 3.0, b1: 0.0, b2: -1.0 / 3.0, b3: sqrt(3.0) / 3.0, startAngle: 0.0)
}

struct HexLayout {

	let orientation: HexOrientation
	let size: CGSize
	let origin: CGPoint

	// grid tpye: even-q
}
