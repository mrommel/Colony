//
//  NSAttributedStringExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 22.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

// https://stackoverflow.com/questions/28496093/making-text-bold-using-attributed-string-in-swift
extension NSMutableAttributedString {

    var fontSize: CGFloat { return 14 }
    var boldFont: UIFont { return UIFont(name: "DINNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont: UIFont { return UIFont(name: "DINNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize) }

    func bold(_ value: String) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
                .font: boldFont,
                .foregroundColor: UIColor.white
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    func normal(_ value: String) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
                .font: normalFont,
                .foregroundColor: UIColor.white
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value: String) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
                .font: normalFont,
                .foregroundColor: UIColor.white,
                .backgroundColor: UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    func blackHighlight(_ value: String) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
                .font: normalFont,
                .foregroundColor: UIColor.white,
                .backgroundColor: UIColor.black
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    func underlined(_ value: String) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
                .font: normalFont,
                .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}

extension NSRegularExpression {

    func split(_ string: String) -> [String] {
        let range = NSRange(location: 0, length: string.count)

        //get locations of matches
        var matchingRanges: [NSRange] = []
        let matches: [NSTextCheckingResult] = self.matches(in: string, options: [], range: range)
        for match: NSTextCheckingResult in matches {
            matchingRanges.append(match.range)
        }

        //invert ranges - get ranges of non-matched pieces
        var pieceRanges: [NSRange] = []

        //add first range
        pieceRanges.append(NSRange(location: 0, length: (matchingRanges.isEmpty ? string.count : matchingRanges[0].location)))

        //add between splits ranges and last range
        for index in 0..<matchingRanges.count {
            let isLast = index + 1 == matchingRanges.count

            let location = matchingRanges[index].location
            let length = matchingRanges[index].length

            //
            pieceRanges.append(NSRange(location: location, length: length))

            let startLoc = location + length
            let endLoc = isLast ? string.count : matchingRanges[index + 1].location
            pieceRanges.append(NSRange(location: startLoc, length: endLoc - startLoc))
        }

        var pieces: [String] = []
        for range: NSRange in pieceRanges {
            let piece = (string as NSString).substring(with: range)
            pieces.append(piece)
        }

        return pieces
    }
}
