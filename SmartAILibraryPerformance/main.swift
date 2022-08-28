//
//  main.swift
//  SmartAILibraryPerformance
//
//  Created by Michael Rommel on 23.08.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
import SmartAILibrary

let suite = XCTestSuite.default
suite.addTest(UsecaseTests())
suite.addTest(TradeRouteTests())
suite.run()
