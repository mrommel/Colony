//
//  SiteEvaluator.swift
//  Colony
//
//  Created by Michael Rommel on 15.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol SiteEvaluator {
    
    func value(of point: HexPoint, by civilization: Civilization) -> Int
    func value(of area: HexArea, by civilization: Civilization) -> Int
}
