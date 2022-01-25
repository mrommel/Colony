//
//  HexagonViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol HexagonViewModelDelegate: AnyObject {

    func clicked(on point: HexPoint)
}

class HexagonViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var showCitizenIcons: Bool

    let point: HexPoint

    @Published
    var tileColor: NSColor

    @Published
    var mountainsImage: NSImage
    private let mountainsTextureName: String?

    @Published
    var hillsImage: NSImage
    private let hillsTextureName: String?

    @Published
    var forestImage: NSImage
    private let forestTextureName: String?

    @Published
    var cityImage: NSImage
    private let cityTextureName: String?

    @Published
    var actionImage: NSImage
    private var tileActionTextureName: String?

    @Published
    var costText: String

    weak var delegate: HexagonViewModelDelegate?

    init(at point: HexPoint,
         tileColor: NSColor,
         mountains: String?,
         hills: String?,
         forest: String?,
         city: String?,
         tileActionTextureName: String?,
         cost: Int?,
         showCitizenIcons: Bool) {

        self.point = point
        self.tileColor = tileColor
        self.mountainsTextureName = mountains
        self.hillsTextureName = hills
        self.forestTextureName = forest
        self.cityTextureName = city
        self.tileActionTextureName = tileActionTextureName
        if let costValue = cost {
            self.costText = "\(costValue)"
        } else {
            self.costText = ""
        }

        self.showCitizenIcons = showCitizenIcons

        // images
        if let texture = mountains {
            self.mountainsImage = ImageCache.shared.image(for: texture)
        } else {
            self.mountainsImage = NSImage()
        }

        if let texture = hills {
            self.hillsImage = ImageCache.shared.image(for: texture)
        } else {
            self.hillsImage = NSImage()
        }

        if let texture = forest {
            self.forestImage = ImageCache.shared.image(for: texture)
        } else {
            self.forestImage = NSImage()
        }

        if let texture = city {
            self.cityImage = ImageCache.shared.image(for: texture)
        } else {
            self.cityImage = NSImage()
        }

        if let texture = tileActionTextureName {
            self.actionImage = ImageCache.shared.image(for: texture)
        } else {
            self.actionImage = NSImage()
        }
    }

    func update(tileAction: String?, and cost: Int?) {

        self.tileActionTextureName = tileAction

        if let texture = tileAction {
            self.actionImage = ImageCache.shared.image(for: texture)
        } else {
            self.actionImage = NSImage()
        }

        if let costValue = cost {
            self.costText = "\(costValue)"
        } else {
            self.costText = ""
        }
    }

    func offset() -> CGSize {

        let screenPoint = HexPoint.toScreen(hex: self.point)
        return CGSize(fromPoint: CGPoint(x: screenPoint.x, y: -screenPoint.y))
    }

    func showMountains() -> Bool {

        return self.mountainsTextureName != nil
    }

    func showHills() -> Bool {

        return self.hillsTextureName != nil
    }

    func showForest() -> Bool {

        return self.forestTextureName != nil
    }

    func showCity() -> Bool {

        return self.cityTextureName != nil
    }

    func clicked() {

        self.delegate?.clicked(on: self.point)
    }
}

extension HexagonViewModel: Hashable {

    static func == (lhs: HexagonViewModel, rhs: HexagonViewModel) -> Bool {

        return lhs.point == rhs.point
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.point)
    }
}
