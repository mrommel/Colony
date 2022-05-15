//
//  UnitViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol UnitViewModelDelegate: AnyObject {

    func clicked(on unitType: UnitType, at index: Int)
    func clicked(on unit: AbstractUnit?, at index: Int)
}

enum UnitViewModelError: Error {

    case invalidType
}

final class UnitViewModel: QueueViewModel, Codable {

    enum CodingKeys: CodingKey {

        case uuid
        case unitType
        case turns
        case gold
        case faith
        case index
        case enabled
    }

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    let unitType: UnitType
    let turns: Int
    let gold: Int
    let faith: Int
    let unit: AbstractUnit?
    let index: Int
    let enabled: Bool

    @Published
    var toolTip: NSAttributedString

    weak var delegate: UnitViewModelDelegate?

    init(unitType: UnitType, turns: Int = -1, gold: Int = -1, faith: Int = -1, enabled: Bool = true, at index: Int = -1) {

        self.unitType = unitType
        self.turns = turns
        self.gold = gold
        self.faith = faith
        self.enabled = enabled
        self.unit = nil
        self.index = index

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: unitType.name().localized() + "\n\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let tokenizer = LabelTokenizer()
        let effects = tokenizer.bulletPointList(
            from: unitType.effects().map { $0.localized() },
            with: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(effects)

        self.toolTip = toolTipText

        super.init(queueType: .unit)
    }

    init(unit: AbstractUnit?, at index: Int = -1) {

        self.unitType = .barbarianWarrior
        self.turns = -1
        self.gold = -1
        self.faith = -1
        self.enabled = true
        self.unit = unit
        self.index = index

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: unitType.name().localized() + "\n\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let tokenizer = LabelTokenizer()
        let effects = tokenizer.bulletPointList(
            from: unitType.effects(),
            with: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(effects)

        self.toolTip = toolTipText

        super.init(queueType: .unit)
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.unitType = try container.decode(UnitType.self, forKey: .unitType)
        self.turns = try container.decode(Int.self, forKey: .turns)
        self.gold = try container.decode(Int.self, forKey: .gold)
        self.faith = try container.decode(Int.self, forKey: .faith)
        self.index = try container.decode(Int.self, forKey: .index)
        self.enabled = try container.decode(Bool.self, forKey: .enabled)
        self.unit = nil

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: unitType.name().localized() + "\n\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let tokenizer = LabelTokenizer()
        let effects = tokenizer.bulletPointList(
            from: unitType.effects().map { $0.localized() },
            with: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(effects)

        self.toolTip = toolTipText

        super.init(queueType: .unit)

        self.uuid = try container.decode(String.self, forKey: .uuid)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.uuid, forKey: .uuid)
        try container.encode(self.unitType, forKey: .unitType)
        try container.encode(self.turns, forKey: .turns)
        try container.encode(self.gold, forKey: .gold)
        try container.encode(self.faith, forKey: .faith)
        try container.encode(self.index, forKey: .index)
        try container.encode(self.enabled, forKey: .enabled)
    }

    func icon() -> NSImage {

        if let unit = self.unit {
            return ImageCache.shared.image(for: unit.type.typeTexture())
        }

        return ImageCache.shared.image(for: self.unitType.typeTexture())
    }

    func title() -> String {

        if let unit = self.unit {
            return unit.name()
        }

        return self.unitType.name()
    }

    func turnsText() -> String {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        if let unit = self.unit {
            return "\(unit.movesLeft()) / \(unit.maxMoves(in: gameModel)) moves"
        }

        if self.turns != -1 {
            return "\(self.turns)"
        }

        if self.gold != -1 {
            return "\(self.gold)"
        }

        if self.faith != -1 {
            return "\(self.faith)"
        }

        return ""
    }

    func costTypeIcon() -> NSImage {

        if self.unit != nil {
            return NSImage()
        }

        if self.turns != -1 {
            return Globals.Icons.turns
        }

        if self.gold != -1 {
            return Globals.Icons.gold
        }

        if self.faith != -1 {
            return Globals.Icons.faith
        }

        return NSImage()
    }

    func background() -> NSImage {

        if self.enabled {
            return ImageCache.shared.image(for: "grid9-button-active")
        }

        return ImageCache.shared.image(for: "grid9-button-disabled")
    }

    func clicked() {

        if let unit = self.unit {
            self.delegate?.clicked(on: unit, at: self.index)
        } else {
            self.delegate?.clicked(on: self.unitType, at: self.index)
        }
    }
}

extension UnitViewModel: NSItemProviderReading, NSItemProviderWriting {

    static var writableTypeIdentifiersForItemProvider: [String] {
        return [(kUTTypeData) as String]
    }

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {

        let progress = Progress(totalUnitCount: 100)

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {

            completionHandler(nil, error)
        }

        return progress
    }

    static var readableTypeIdentifiersForItemProvider: [String] {
        return [(kUTTypeData) as String]
    }

    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> UnitViewModel {

        let decoder = JSONDecoder()
        do {
            let queueViewModel = try decoder.decode(UnitViewModel.self, from: data)
            return queueViewModel
        } catch {
            throw UnitViewModelError.invalidType
        }
    }
}
