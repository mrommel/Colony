//
//  LabelTokenizer.swift
//  SmartAssets
//
//  Created by Michael Rommel on 21.11.21.
//

import Foundation
import Cocoa

extension NSTextAttachment {

    public func setImage(height: CGFloat) {

        guard let image = image else { return }

        let ratio = image.size.width / image.size.height

        self.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
    }
}

public enum LabelImageType {

    // yields
    case food
    case production
    case gold
    case housing
    case science
    case culture
    case faith
    case tourism

    case tradeRoute
    case tradingPost
    case loyalty
    case amenities
    case capital
    case strength
    case citizen
    case governor

    case greatPerson
    case greatAdmiral
    case greatArtist
    case greatEngineer
    case greatGeneral
    case greatMerchant
    case greatMusician
    case greatProphet
    case greatScientist
    case greatWriter

    case relic

    case darkAge
    case normalAge
    case goldenAge
    case inspiration
    case eureka

    static func fromString(value: String) -> LabelImageType {

        switch value {

            // yields
        case "[Food]": return .food
        case "[Production]": return .production
        case "[Gold]": return .gold
        case "[Housing]": return .housing
        case "[Science]": return .science
        case "[Culture]": return .culture
        case "[Faith]": return .faith
        case "[Tourism]": return .tourism

        case "[TradeRoute]": return .tradeRoute
        case "[TradingPost]": return .tradingPost
        case "[Loyalty]": return .loyalty
        case "[Amenities]": return .amenities
        case "[Capital]": return .capital
        case "[Strength]": return .strength
        case "[Citizen]": return .citizen
        case "[Governor]": return .governor
        case "[Population]": return .citizen

        case "[GreatPerson]": return .greatPerson
        case "[GreatAdmiral]": return .greatAdmiral
        case "[GreatArtist]": return .greatArtist
        case "[GreatEngineer]": return .greatEngineer
        case "[GreatGeneral]": return .greatGeneral
        case "[GreatMerchant]": return .greatMerchant
        case "[GreatMusician]": return .greatMusician
        case "[GreatProphet]": return .greatProphet
        case "[GreatScientist]": return .greatScientist
        case "[GreatWriter]": return .greatWriter

        case "[Relic]": return .relic

        case "[DarkAge]": return .darkAge
        case "[NormalAge]": return .normalAge
        case "[GoldenAge]": return .goldenAge
        case "[Inspiration]": return .inspiration
        case "[Eureka]": return .eureka

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
        case .culture: return Globals.Icons.culture
        case .faith: return Globals.Icons.faith
        case .tourism: return Globals.Icons.tourism

        case .tradeRoute: return Globals.Icons.tradeRoute
        case .tradingPost: return Globals.Icons.tradingPost
        case .loyalty: return Globals.Icons.loyalty
        case .amenities: return Globals.Icons.amenities
        case .capital: return Globals.Icons.capital
        case .strength: return Globals.Icons.strength
        case .citizen: return Globals.Icons.citizen
        case .governor: return Globals.Icons.governor

        case .greatPerson: return Globals.Icons.greatPerson
        case .greatAdmiral: return Globals.Icons.greatAdmiral
        case .greatArtist: return Globals.Icons.greatArtist
        case .greatEngineer: return Globals.Icons.greatEngineer
        case .greatGeneral: return Globals.Icons.greatGeneral
        case .greatMerchant: return Globals.Icons.greatMerchant
        case .greatMusician: return Globals.Icons.greatMusician
        case .greatProphet: return Globals.Icons.greatProphet
        case .greatScientist: return Globals.Icons.greatScientist
        case .greatWriter: return Globals.Icons.greatWriter

        case .relic: return Globals.Icons.relic

        case .darkAge: return Globals.Icons.darkAge
        case .normalAge: return Globals.Icons.normalAge
        case .goldenAge: return Globals.Icons.goldenAge
        case .inspiration: return Globals.Icons.inspiration
        case .eureka: return Globals.Icons.eureka
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

    public func convert(text rawText: String, with attributes: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString {

        let tokens = self.tokenize(text: rawText)
        let attributedString = self.join(tokens: tokens)

        if let attributes = attributes {
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            let completeRange = NSRange(location: 0, length: mutableAttributedString.length)

            mutableAttributedString.addAttributes(attributes, range: completeRange)
            return mutableAttributedString
        }

        return attributedString
    }

    private func tokenize(text: String) -> [LabelTokenType] {

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

    private func join(tokens: [LabelTokenType]) -> NSAttributedString {

        let attributedString = NSMutableAttributedString()

        for token in tokens {

            switch token {

            case .text(content: let content):
                attributedString.append(NSAttributedString(string: content))

            case .translation(key: let key):
                let content = key.localized()
                attributedString.append(NSAttributedString(string: content))

            case .image(type: let type):
                let attachment: NSTextAttachment = NSTextAttachment()
                attachment.image = type.image()
                attachment.setImage(height: 12)

                let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
                attributedString.append(attachmentString)
            }

            attributedString.append(NSAttributedString(string: " "))
        }

        return attributedString
    }
}
