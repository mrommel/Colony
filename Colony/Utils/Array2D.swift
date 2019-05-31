//
//  Array2D.swift
//  agents
//
//  Created by Michael Rommel on 25.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

public class Array2D<T: Equatable> {
	public let columns: Int
	public let rows: Int
	fileprivate var array: [T?] = [T?]()

	public init(columns: Int, rows: Int) {
		self.columns = columns
		self.rows = rows
		self.array = [T?](repeating: nil, count: rows * columns)
	}

	public subscript(column: Int, row: Int) -> T? {
		get {
			precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			return array[row * columns + column]
		}
		set {
			precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
			array[row * columns + column] = newValue
		}
	}
}

extension Array2D where T: Comparable {

	var minimum: T {
		var minimumValue: T = self[0, 0]!

		for x in 0..<self.columns {
			for y in 0..<self.rows {
				if minimumValue > self[x, y]! {
					minimumValue = self[x, y]!
				}
			}
		}

		return minimumValue
	}

	var maximum: T {
		var maximumValue: T = self[0, 0]!

		for x in 0..<self.columns {
			for y in 0..<self.rows {
				if maximumValue < self[x, y]! {
					maximumValue = self[x, y]!
				}
			}
		}

		return maximumValue
	}
}

// MARK: fill methods

extension Array2D {

	func fill(with value: T) {
		for x in 0..<self.columns {
			for y in 0..<self.rows {
				self[x, y] = value
			}
		}
	}

	func fill(with function: (Int, Int) -> T) {
		for x in 0..<self.columns {
			for y in 0..<self.rows {
				self[x, y] = function(x, y)
			}
		}
	}
}

// MARK: grid method

extension Array2D {

	subscript(gridPoint: HexPoint) -> T? {
		get {
			return array[(gridPoint.y * columns) + gridPoint.x]
		}
		set(newValue) {
			array[(gridPoint.y * columns) + gridPoint.x] = newValue
		}
	}
}
