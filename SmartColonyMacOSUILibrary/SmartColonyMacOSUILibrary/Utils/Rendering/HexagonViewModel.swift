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
    let screenPoint: CGPoint

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
    var improvementImage: NSImage
    private let improvementTextureName: String?

    @Published
    var resourceImage: NSImage
    private let resourceTextureName: String?

    @Published
    var actionImage: NSImage
    private var tileActionTextureName: String?

    @Published
    var costText: String

    weak var delegate: HexagonViewModelDelegate?

    init(at point: HexPoint,
         screenPoint: CGPoint,
         tileColor: NSColor,
         mountains mountainsTextureName: String?,
         hills hillsTextureName: String?,
         forest forestTextureName: String?,
         resource resourceTextureName: String?,
         city cityTextureName: String?,
         improvement improvementTextureName: String?,
         tileActionTextureName: String?,
         cost: Int?,
         showCitizenIcons: Bool) {

        self.point = point
        self.screenPoint = screenPoint
        self.tileColor = tileColor
        self.mountainsTextureName = mountainsTextureName
        self.hillsTextureName = hillsTextureName
        self.forestTextureName = forestTextureName
        self.cityTextureName = cityTextureName
        self.improvementTextureName = improvementTextureName
        self.resourceTextureName = resourceTextureName
        self.tileActionTextureName = tileActionTextureName

        if let costValue = cost {
            self.costText = "\(costValue)"
        } else {
            self.costText = ""
        }

        self.showCitizenIcons = showCitizenIcons

        // images
        if let texture = mountainsTextureName {
            self.mountainsImage = ImageCache.shared.image(for: texture)
        } else {
            self.mountainsImage = NSImage()
        }

        if let texture = hillsTextureName {
            self.hillsImage = ImageCache.shared.image(for: texture)
        } else {
            self.hillsImage = NSImage()
        }

        if let texture = forestTextureName {
            self.forestImage = ImageCache.shared.image(for: texture)
        } else {
            self.forestImage = NSImage()
        }

        if let texture = cityTextureName {
            self.cityImage = ImageCache.shared.image(for: texture)
        } else {
            self.cityImage = NSImage()
        }

        if let textureName = improvementTextureName {
            self.improvementImage = ImageCache.shared.image(for: textureName)
        } else {
            self.improvementImage = NSImage()
        }

        if let textureName = resourceTextureName {
            self.resourceImage = ImageCache.shared.image(for: textureName)
        } else {
            self.resourceImage = NSImage()
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

        return CGSize(fromPoint: CGPoint(x: self.screenPoint.x, y: -self.screenPoint.y))
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
