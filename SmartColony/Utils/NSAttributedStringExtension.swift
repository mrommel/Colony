//
//  NSAttributedStringExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 22.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

extension NSRegularExpression {
    
    func split(_ str: String) -> [String] {
        let range = NSRange(location: 0, length: str.count)
        
        //get locations of matches
        var matchingRanges: [NSRange] = []
        let matches: [NSTextCheckingResult] = self.matches(in: str, options: [], range: range)
        for match: NSTextCheckingResult in matches {
            matchingRanges.append(match.range)
        }
        
        //invert ranges - get ranges of non-matched pieces
        var pieceRanges: [NSRange] = []
        
        //add first range
        pieceRanges.append(NSRange(location: 0, length: (matchingRanges.count == 0 ? str.count : matchingRanges[0].location)))
        
        //add between splits ranges and last range
        for i in 0..<matchingRanges.count {
            let isLast = i + 1 == matchingRanges.count
            
            let location = matchingRanges[i].location
            let length = matchingRanges[i].length
            
            //
            pieceRanges.append(NSRange(location: location, length: length))
            
            let startLoc = location + length
            let endLoc = isLast ? str.count : matchingRanges[i + 1].location
            pieceRanges.append(NSRange(location: startLoc, length: endLoc - startLoc))
        }
        
        var pieces: [String] = []
        for range: NSRange in pieceRanges {
            let piece = (str as NSString).substring(with: range)
            pieces.append(piece)
        }
        
        return pieces
    }
}

/*extension NSAttributedString {

    func apply() {

        
    }
}*/
