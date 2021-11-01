//
//  TestUtils.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 01.11.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation
import XCTest

func assertContains<T>(_ elem: T, in list: [T]) where T: Hashable, T: CustomDebugStringConvertible {

    let contains = list.contains(elem)
    let listAsString = list.map { $0.debugDescription }.joined(separator: ",")
    let message = "The element \(elem) is not contained in the list: [\(listAsString)]"
    XCTAssertTrue(contains, message)
}
