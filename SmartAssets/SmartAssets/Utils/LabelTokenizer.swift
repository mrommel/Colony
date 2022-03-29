//
//  LabelTokenizer.swift
//  SmartAssets
//
//  Created by Michael Rommel on 21.11.21.
//

import Foundation
import Cocoa
import SmartAILibrary

extension NSTextAttachment {

    public func setImage(height: CGFloat, offset: CGFloat) {

        guard let image = image else { return }

        let ratio = image.size.width / image.size.height

        self.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y + offset, width: ratio * height, height: height)
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
    case power

    case tradeRoute
    case tradingPost
    case loyalty
    case amenities
    case capital
    case strength
    case rangedStrength
    case religiousStrength
    case movement
    case governor
    case citizen
    case promotion
    case diplomaticFavor
    case envoy
    case grievances

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
    case artifact
    case greatWorkOfWriting

    case darkAge
    case normalAge
    case goldenAge

    case inspiration
    case eureka

    case horses
    case niter
    case coal
    case aluminum
    case oil
    case uranium
    case iron

    // swiftlint:disable cyclomatic_complexity
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
        case "[Power]": return .power

        case "[TradeRoute]": return .tradeRoute
        case "[TradingPost]": return .tradingPost
        case "[Loyalty]": return .loyalty
        case "[Amenities]": return .amenities
        case "[Amenity]": return .amenities
        case "[Capital]": return .capital
        case "[Strength]": return .strength
        case "[RangedStrength]": return .rangedStrength
        case "[ReligiousStrength]": return .religiousStrength
        case "[Movement]": return .movement
        case "[Citizen]": return .citizen
        case "[Governor]": return .governor
        case "[Population]": return .citizen
        case "[Promotion]": return .promotion
        case "[DiplomaticFavor]": return .diplomaticFavor
        case "[Envoy]": return .envoy
        case "[Grievances]": return .grievances

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
        case "[Artifact]": return .artifact
        case "[GreatWorkOfWriting]": return .greatWorkOfWriting

        case "[DarkAge]": return .darkAge
        case "[NormalAge]": return .normalAge
        case "[GoldenAge]": return .goldenAge

        case "[Inspiration]": return .inspiration
        case "[Eureka]": return .eureka

        case "[Horses]": return .horses
        case "[Niter]": return .niter
        case "[Coal]": return .coal
        case "[Aluminum]": return .aluminum
        case "[Oil]": return .oil
        case "[Iron]": return .iron
        case "[Uranium]": return .uranium

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
        case .power: return Globals.Icons.power

        case .tradeRoute: return Globals.Icons.tradeRoute
        case .tradingPost: return Globals.Icons.tradingPost
        case .loyalty: return Globals.Icons.loyalty
        case .amenities: return Globals.Icons.amenities
        case .capital: return Globals.Icons.capital
        case .strength: return Globals.Icons.strength
        case .rangedStrength: return Globals.Icons.rangedStrength
        case .religiousStrength: return Globals.Icons.religiousStrength
        case .movement: return Globals.Icons.movement
        case .citizen: return Globals.Icons.citizen
        case .governor: return Globals.Icons.governor
        case .promotion: return Globals.Icons.promotion
        case .diplomaticFavor: return Globals.Icons.diplomaticFavor
        case .envoy: return Globals.Icons.envoy
        case .grievances: return Globals.Icons.grievances

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
        case .artifact: return Globals.Icons.artifact
        case .greatWorkOfWriting: return Globals.Icons.greatWorkOfWriting

        case .darkAge: return Globals.Icons.darkAge
        case .normalAge: return Globals.Icons.normalAge
        case .goldenAge: return Globals.Icons.goldenAge
        case .inspiration: return Globals.Icons.inspiration
        case .eureka: return Globals.Icons.eureka

        case .horses: return Globals.Icons.horses
        case .niter: return Globals.Icons.niter
        case .coal: return Globals.Icons.coal
        case .aluminum: return Globals.Icons.aluminum
        case .oil: return Globals.Icons.oil
        case .uranium: return Globals.Icons.uranium
        case .iron: return Globals.Icons.iron
        }
    }
}

public enum LabelTokenType {

    case text(content: String)
    case colored(content: String, color: TypeColor)
    case translation(key: String)
    case image(type: LabelImageType)
}

extension LabelTokenType: Equatable {

    public static func == (lhs: LabelTokenType, rhs: LabelTokenType) -> Bool {

        switch (lhs, rhs) {

        case (.text(content: let lhsContent), .text(content: let rhsContent)):
            return lhsContent == rhsContent

        case (.colored(content: let lhsContent, color: let lhsColor), .colored(content: let rhsContent, color: let rhsColor)):
            return lhsContent == rhsContent && lhsColor == rhsColor

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

    var currentColorStack: Stack<TypeColor>

    public init() {

        self.currentColorStack = Stack<TypeColor>()
    }

    public func convert(text rawText: String, with attributes: [NSAttributedString.Key: Any]? = nil, extraSpace: Bool = false) -> NSAttributedString {

        let tokens = self.tokenize(text: rawText)
        let attributedString = self.join(tokens: tokens, extraSpace: extraSpace)

        if let attributes = attributes {
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            let completeRange = NSRange(location: 0, length: mutableAttributedString.length)

            mutableAttributedString.addAttributes(attributes, range: completeRange)
            return mutableAttributedString
        }

        return attributedString
    }

    public func bulletPointList(from strings: [String], with attributesRef: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 12
        paragraphStyle.maximumLineHeight = 12
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]

        var attributes: [NSAttributedString.Key: Any]
        if let attr = attributesRef {
            attributes = attr
        } else {
            attributes = [
                NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: NSColor.white,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        }

        let string = strings.map({ "•\t\($0)" }).joined(separator: "\n")

        return NSAttributedString(string: string,
                                  attributes: attributes)
    }

    private func startColor(_ keyword: String) -> TypeColor? {

        switch keyword {

        case "[red]": return .red
        case "[green]": return .green

        default: return nil
        }
    }

    private func endColor(_ keyword: String) -> TypeColor? {

        if keyword.starts(with: "[/") {
            return self.startColor(keyword.replacingOccurrences(of: "/", with: ""))
        }

        return nil
    }

    internal func tokenize(text: String) -> [LabelTokenType] {

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

                if !content.isEmpty {
                    if let peekColor = self.currentColorStack.peek() {
                        matchResults.append(LabelTokenType.colored(content: content, color: peekColor))
                    } else {
                        matchResults.append(LabelTokenType.text(content: content))
                    }
                }
            }

            let start = String.Index(utf16Offset: match.range.location, in: text)
            let end = String.Index(utf16Offset: match.range.location + match.range.length, in: text)

            let keyword: String = String(text.utf16[start..<end])!.trimmingCharacters(in: .whitespacesAndNewlines)

            if let color = self.startColor(keyword) {
                self.currentColorStack.push(color)
            } else if let color = self.endColor(keyword) {
                if let peekColor = self.currentColorStack.peek() {
                    guard peekColor == color else {
                        fatalError("wrong color on the stack - cant close color tag for \(color) - expected \(peekColor)")
                    }

                    self.currentColorStack.pop()
                } else {
                    fatalError("no color on the stack - cant close color tag for \(color)")
                }
            } else {
                let imageType: LabelImageType = LabelImageType.fromString(value: keyword)
                matchResults.append(LabelTokenType.image(type: imageType))
            }

            endLastMatchLocation = end
        }

        if endLastMatchLocation < String.Index(utf16Offset: text.utf16.count - 1, in: text) {

            let start = endLastMatchLocation
            let end = String.Index(utf16Offset: text.utf16.count, in: text)

            let content: String = String(text.utf16[start..<end])!.trimmingCharacters(in: .whitespacesAndNewlines)

            if !content.isEmpty {
                if content.starts(with: "TXT_KEY_") {
                    matchResults.append(LabelTokenType.translation(key: content))
                } else {
                    if let peekColor = self.currentColorStack.peek() {
                        matchResults.append(LabelTokenType.colored(content: content, color: peekColor))
                    } else {
                        matchResults.append(LabelTokenType.text(content: content))
                    }
                }
            }
        }

        return matchResults
    }

    private func join(tokens: [LabelTokenType], extraSpace: Bool = false) -> NSAttributedString {

        let attributedString = NSMutableAttributedString()

        for token in tokens {

            switch token {

            case .text(content: let content):
                attributedString.append(NSAttributedString(string: content))

            case .colored(content: let content, color: let color):
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: color
                ]
                let coloredString = NSAttributedString(string: content, attributes: attributes)
                attributedString.append(coloredString)

            case .translation(key: let key):
                let content = key.localized()
                attributedString.append(NSAttributedString(string: content))

            case .image(type: let type):
                let attachment: NSTextAttachment = NSTextAttachment()
                attachment.image = type.image()
                attachment.setImage(height: 12, offset: extraSpace ? 8 : 0)

                if extraSpace {
                    attributedString.append(NSAttributedString(string: " "))
                }

                let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
                attributedString.append(attachmentString)
            }

            attributedString.append(NSAttributedString(string: " "))
        }

        return attributedString
    }
}
