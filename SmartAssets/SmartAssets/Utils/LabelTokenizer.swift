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

    static func fromString(value: String) -> LabelImageType {

        switch value {

        case "[Food]": return .food
        case "[Production]": return .production

        default:
            fatalError("Value: '\(value)' not handled.")
        }
    }

    public func image() -> NSImage {

        switch self {

        case .food: return Globals.Icons.food
        case .production: return Globals.Icons.production
        }
    }
}

public enum LabelTokenType {

    case text(content: String)
    case image(type: LabelImageType)
}

extension LabelTokenType: Equatable {

    public static func == (lhs: LabelTokenType, rhs: LabelTokenType) -> Bool {

        switch (lhs, rhs) {

        case (.text(content: let lhsContent), .text(content: let rhsContent)):
            return lhsContent == rhsContent

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

            // print("resultType: \(match.resultType)")
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
            matchResults.append(LabelTokenType.text(content: content))
        }

        print(matchResults)
        return matchResults

        // the combination of zip, dropFirst and map to optional here is a trick
        // to be able to map on [(result1, result2), (result2, result3), (result3, nil)]
        /*let results = zip(matches, matches.dropFirst().map { Optional.some($0) } + [nil]).map { current, next -> String in
            let range = current.range(at: 0)
            let start = String.Index(utf16Offset: range.location, in: text)
            // if there's a next, use it's starting location as the ending of our match
            // otherwise, go to the end of the searched string
            let end = next
                .map { $0.range(at: 0) }
                .map { String.Index(utf16Offset: $0.location, in: text) } ?? String.Index(utf16Offset: text.utf16.count, in: text)

            return String(text.utf16[start..<end])!
        }

        return results*/
    }
}
