//
//  BuildingViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol BuildingViewModelDelegate: AnyObject {

    func clicked(on buildingType: BuildingType, at index: Int)
}

enum BuildingViewModelError: Error {

    case invalidType
}

final class BuildingViewModel: QueueViewModel, Codable {

    enum CodingKeys: CodingKey {

        case uuid
        case buildingType
        case turns
        case gold
        case index
        case showYields
        case active
    }

    let buildingType: BuildingType
    let turns: Int
    let gold: Int
    let index: Int
    let showYields: Bool

    var active: Bool

    @Published
    var toolTip: NSAttributedString

    weak var delegate: BuildingViewModelDelegate?

    init(buildingType: BuildingType, turns: Int, active: Bool = true, showYields: Bool = false, at index: Int = -1) {

        self.buildingType = buildingType
        self.turns = turns
        self.gold = -1
        self.showYields = showYields
        self.index = index
        self.active = active
        self.toolTip = buildingType.toolTip()

        super.init(queueType: .building)
    }

    init(buildingType: BuildingType, gold: Int, active: Bool = true, showYields: Bool = false, at index: Int = -1) {

        self.buildingType = buildingType
        self.turns = -1
        self.gold = gold
        self.showYields = showYields
        self.index = index
        self.active = active
        self.toolTip = buildingType.toolTip()

        super.init(queueType: .building)
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.buildingType = try container.decode(BuildingType.self, forKey: .buildingType)
        self.turns = try container.decode(Int.self, forKey: .turns)
        self.gold = try container.decode(Int.self, forKey: .gold)
        self.index = try container.decode(Int.self, forKey: .index)
        self.showYields = try container.decode(Bool.self, forKey: .showYields)
        self.active = try container.decode(Bool.self, forKey: .active)
        self.toolTip = buildingType.toolTip()

        super.init(queueType: .building)

        self.uuid = try container.decode(String.self, forKey: .uuid)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.uuid, forKey: .uuid)
        try container.encode(self.buildingType, forKey: .buildingType)
        try container.encode(self.turns, forKey: .turns)
        try container.encode(self.gold, forKey: .gold)
        try container.encode(self.index, forKey: .index)
        try container.encode(self.showYields, forKey: .showYields)
        try container.encode(self.active, forKey: .active)
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.buildingType.iconTexture())
    }

    func title() -> String {

        return self.buildingType.name().localized()
    }

    func turnsText() -> String {

        if self.turns != -1 {
            return "\(self.turns)"
        }

        if self.gold != -1 {
            return "\(self.gold)"
        }

        /* if self.faith != -1 {
            return "\(self.faith)"
        } */

        return ""
    }

    func turnsIcon() -> NSImage {

        if self.turns != -1 {
            return Globals.Icons.turns
        }

        if self.gold != -1 {
            return Globals.Icons.gold
        }

        /* if self.faith != -1 {
            return Globals.Icons.faith
        } */

        return NSImage()
    }

    func background() -> NSImage {

        if self.active {
            return ImageCache.shared.image(for: "grid9-button-active")
        } else {
            return ImageCache.shared.image(for: "grid9-button-disabled")
        }
    }

    func yieldValueViewModels() -> [YieldValueViewModel] {

        if !self.showYields {
            return []
        }

        let buildingYield = self.buildingType.yields()
        var models: [YieldValueViewModel] = []

        for yieldType in YieldType.all {

            let yieldValue = buildingYield.value(of: yieldType)
            if yieldValue > 0.0 {
                models.append(YieldValueViewModel(yieldType: yieldType, initial: yieldValue, type: .onlyValue, withBackground: false))
            }
        }

        return models
    }

    func clicked() {

        self.delegate?.clicked(on: self.buildingType, at: self.index)
    }
}

extension BuildingViewModel: NSItemProviderReading, NSItemProviderWriting {

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

    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> BuildingViewModel {

        let decoder = JSONDecoder()
        do {
            let queueViewModel = try decoder.decode(BuildingViewModel.self, from: data)
            return queueViewModel
        } catch {
            throw BuildingViewModelError.invalidType
        }
    }
}
