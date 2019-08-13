//
//  StringExtension.swift
//  Colony
//
//  Created by Michael Rommel on 12.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

extension String {
    
    var utf8Array: [UInt8] {
        return Array(utf8)
    }
}
