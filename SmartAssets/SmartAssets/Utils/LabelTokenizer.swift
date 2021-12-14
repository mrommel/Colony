//
//  LabelTokenizer.swift
//  SmartAssets
//
//  Created by Michael Rommel on 21.11.21.
//

import Foundation
import Cocoa

public enum LabelImageType {

    // yields
    case food
    case production
    case gold
    case housing
    case science
    case faith

    case tradeRoute
    case loyalty
    case capital
    case strength

    static func fromString(value: String) -> LabelImageType {

        switch value {

            // yields
        case "[Food]": return .food
        case "[Production]": return .production
        case "[Gold]": return .gold
        case "[Housing]": return .housing
        case "[Science]": return .science
        case "[Faith]": return .faith

        case "[TradeRoute]": return .tradeRoute
        case "[Loyalty]": return .loyalty
        case "[Capital]": return .capital
        case "[Strength]": return .strength

        default:
            fatalError("Value: '\(value)' not handled.")
        }
    }

    public func image() -> NSImage {

        switch self {

            // yields
        case .food: return Globals.Icons.food
        case .production: return Globals.Icons.production
        case .gold: return Globals.Icons.gold
        case .housing: return Globals.Icons.housing
        case .science: return Globals.Icons.science
        case .faith: return Globals.Icons.faith

        case .tradeRoute: return Globals.Icons.tradeRoute
        case .loyalty: return Globals.Icons.loyalty
        case .capital: return Globals.Icons.capital
        case .strength: return Globals.Icons.strength

        }
    }
}

public enum LabelTokenType {

    case text(content: String)
    case translation(key: String)
    case image(type: LabelImageType)
}

extension LabelTokenType: Equatable {

    public static func == (lhs: LabelTokenType, rhs: LabelTokenType) -> Bool {

        switch (lhs, rhs) {

        case (.text(content: let lhsContent), .text(content: let rhsContent)):
            return lhsContent == rhsContent

        case (.translation(key: let lhsKey), .translation(key: let rhsKey)):
            return lhsKey == rhsKey

        case (.image(type: let lhsType), .image(type: let rhsType)):
            return lhsType == rhsType

        default:
            return false
        }
    }
}

public class LabelTokenizer {

    let tokenPattern: String = "\\[([^\\[]*?)\\]"

    public init() {

    }

    public func tokenize(text: String) -> [LabelTokenType] {

        var regex: NSRegularExpression

        do {
            regex = try NSRegularExpression(pattern: self.tokenPattern, options: [])
        } catch {
            return []
        }

        let matches = regex.matches(in: text, range: NSRange(location: 0, length: text.utf16.count))

        if matches.isEmpty {
            return [.text(content: text)]
        }

        var matchResults: [LabelTokenType] = []
        var endLastMatchLocation: String.Index = String.Index(utf16Offset: 0, in: text)

        for match in matches {

            if String.Index(utf16Offset: match.range.location, in: text) != endLastMatchLocation {

                let start = endLastMatchLocation
                let end = String.Index(utf16Offset: match.range.location - 1, in: text)

                let content: String = String(text.utf16[start...end])!.trimmingCharacters(in: .whitespacesAndNewlines)
                matchResults.append(LabelTokenType.text(content: content))
            }

            let start = String.Index(utf16Offset: match.range.location, in: text)
            let end = String.Index(utf16Offset: match.range.location + match.range.length, in: text)

            let content: String = String(text.utf16[start..<end])!.trimmingCharacters(in: .whitespacesAndNewlines)
            let imageType: LabelImageType = LabelImageType.fromString(value: content)
            matchResults.append(LabelTokenType.image(type: imageType))

            endLastMatchLocation = end
        }

        if endLastMatchLocation < String.Index(utf16Offset: text.utf16.count - 1, in: text) {

            let start = endLastMatchLocation
            let end = String.Index(utf16Offset: text.utf16.count, in: text)

            let content: String = String(text.utf16[start..<end])!.trimmingCharacters(in: .whitespacesAndNewlines)

            if content.starts(with: "TXT_KEY_") {
                matchResults.append(LabelTokenType.translation(key: content))
            } else {
                matchResults.append(LabelTokenType.text(content: content))
            }
        }

        return matchResults
    }
}
