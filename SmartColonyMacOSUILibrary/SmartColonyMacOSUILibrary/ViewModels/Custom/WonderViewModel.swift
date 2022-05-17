//
//  WonderViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol WonderViewModelDelegate: AnyObject {

    func clicked(on wonderType: WonderType, at index: Int, in gameModel: GameModel?)
}

enum WonderViewModelError: Error {

    case invalidType
}

final class WonderViewModel: QueueViewModel, Codable {

    enum CodingKeys: CodingKey {

        case uuid
        case wonderType
        case location
        case turns
        case index
        case showYields
    }

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    let wonderType: WonderType
    let location: HexPoint
    let turns: Int
    let index: Int
    let showYields: Bool

    @Published
    var toolTip: NSAttributedString

    weak var delegate: WonderViewModelDelegate?

    init(wonderType: WonderType, at location: HexPoint, turns: Int, showYields: Bool = false, at index: Int = -1) {

        self.wonderType = wonderType
        self.location = location
        self.turns = turns
        self.showYields = showYields
        self.index = index
        self.toolTip = wonderType.toolTip()

        super.init(queueType: .wonder)
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.wonderType = try container.decode(WonderType.self, forKey: .wonderType)
        self.location = try container.decode(HexPoint.self, forKey: .location)
        self.turns = try container.decode(Int.self, forKey: .turns)
        self.index = try container.decode(Int.self, forKey: .index)
        self.showYields = try container.decode(Bool.self, forKey: .showYields)
        self.toolTip = wonderType.toolTip()

        super.init(queueType: .wonder)

        self.uuid = try container.decode(String.self, forKey: .uuid)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.uuid, forKey: .uuid)
        try container.encode(self.wonderType, forKey: .wonderType)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.turns, forKey: .turns)
        try container.encode(self.index, forKey: .index)
        try container.encode(self.showYields, forKey: .showYields)
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.wonderType.iconTexture())
    }

    func title() -> String {

        return self.wonderType.name().localized()
    }

    func turnsText() -> String {

        if self.showYields {
            return ""
        }

        return "\(self.turns)"
    }

    func turnsIcon() -> NSImage {

        return Globals.Icons.turns
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: "grid9-button-active")
    }

    func yieldValueViewModels() -> [YieldValueViewModel] {

        if !self.showYields {
            return []
        }

        let buildingYield = self.wonderType.yields()
        var models: [YieldValueViewModel] = []

        for yieldType in YieldType.all {

            let yieldValue = buildingYield.value(of: yieldType)
            if yieldValue > 0 {
                models.append(YieldValueViewModel(yieldType: yieldType, initial: yieldValue, type: .onlyValue, withBackground: false))
            }
        }

        return models
    }

    func clicked() {

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        self.delegate?.clicked(on: self.wonderType, at: self.index, in: gameModel)
    }
}

extension WonderViewModel: NSItemProviderReading, NSItemProviderWriting {

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

    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> WonderViewModel {

        let decoder = JSONDecoder()
        do {
            let queueViewModel = try decoder.decode(WonderViewModel.self, from: data)
            return queueViewModel
        } catch {
            throw WonderViewModelError.invalidType
        }
    }
}
