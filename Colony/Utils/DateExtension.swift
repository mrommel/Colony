//
//  DateExtension.swift
//  Colony
//
//  Created by Michael Rommel on 06.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

extension Date {
    
    static var currentTimeStamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
