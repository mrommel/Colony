//
//  HexPointCorner.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

/**
A GridPointCorner is an enum that represents a corner of a `GridPoint`.

There are 6 (0-5) corners
```
+--5--0--+
| /    \ |
|/      \|
4        1
|\      /|
| \    / |
+--3--2--+
```
*/
public enum HexPointCorner: Int {

	case northeast = 0
	case east = 1
	case southeast = 2
	case southwest = 3
	case west = 4
	case northwest = 5
}

public func randomGridPointCorner() -> HexPointCorner {
	return HexPointCorner(rawValue: Int.random(number: 6))!
}
