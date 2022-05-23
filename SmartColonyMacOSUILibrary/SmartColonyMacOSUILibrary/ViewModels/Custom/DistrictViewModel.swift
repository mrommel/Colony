//
//  DistrictViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol DistrictViewModelDelegate: AnyObject {

    func clicked(on districtType: DistrictType, at index: Int, in gameModel: GameModel?)
}

enum DistrictViewModelError: Error {

    case invalidType
}

final class DistrictViewModel: QueueViewModel, Codable {

    enum CodingKeys: CodingKey {

        case uuid
        case districtType
        case location
        case turns
        case index
        case showYields
        case active
    }

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    let districtType: DistrictType
    let location: HexPoint
    let turns: Int
    let index: Int
    let showYields: Bool

    var active: Bool

    @Published
    var toolTip: NSAttributedString

    weak var delegate: DistrictViewModelDelegate?

    init(districtType: DistrictType, at location: HexPoint, turns: Int = -1, active: Bool, showYields: Bool = false, at index: Int = -1) {

        self.districtType = districtType
        self.location = location
        self.turns = active ? -1 : turns
        self.active = active
        self.showYields = showYields
        self.index = index
        self.toolTip = districtType.toolTip()

        super.init(queueType: .district)
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.districtType = try container.decode(DistrictType.self, forKey: .districtType)
        self.location = try container.decode(HexPoint.self, forKey: .location)
        self.turns = try container.decode(Int.self, forKey: .turns)
        self.index = try container.decode(Int.self, forKey: .index)
        self.showYields = try container.decode(Bool.self, forKey: .showYields)
        self.active = try container.decode(Bool.self, forKey: .active)
        self.toolTip = districtType.toolTip()

        super.init(queueType: .district)

        self.uuid = try container.decode(String.self, forKey: .uuid)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.uuid, forKey: .uuid)
        try container.encode(self.districtType, forKey: .districtType)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.turns, forKey: .turns)
        try container.encode(self.index, forKey: .index)
        try container.encode(self.showYields, forKey: .showYields)
        try container.encode(self.active, forKey: .active)
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.districtType.iconTexture())
    }

    func title() -> String {

        return self.districtType.name()
    }

    func turnsText() -> String {

        if self.showYields {
            return ""
        }

        if self.active {
            return ""
        }

        return "\(self.turns)"
    }

    func turnsIcon() -> NSImage {

        if self.active {
            return Globals.Icons.checkmark
        }

        return Globals.Icons.turns
    }

    func yieldValueViewModel() -> [YieldValueViewModel] {

        if !self.showYields {
            return []
        }

        return []
    }

    func fontColor() -> Color {

        if self.active {
            return .white
        } else {
            return Color(Globals.Colors.districtActive)
        }
    }

    func background() -> NSImage {

        if self.active {
            return ImageCache.shared.image(for: "grid9-button-district-active")
        } else {
            return ImageCache.shared.image(for: "grid9-button-district")
        }
    }

    func clicked() {

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        self.delegate?.clicked(on: self.districtType, at: self.index, in: gameModel)
    }
}

extension DistrictViewModel: NSItemProviderReading, NSItemProviderWriting {

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

    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> DistrictViewModel {

        let decoder = JSONDecoder()
        do {
            let queueViewModel = try decoder.decode(DistrictViewModel.self, from: data)
            return queueViewModel
        } catch {
            throw DistrictViewModelError.invalidType
        }
    }
}
