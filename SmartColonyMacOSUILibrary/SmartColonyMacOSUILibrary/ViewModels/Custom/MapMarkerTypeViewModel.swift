//
//  MapMarkerTypeViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 29.04.22.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

public class MapMarkerTypeViewModel: ObservableObject, Identifiable {

    public let id: UUID = UUID()

    @Published
    var type: MapMarkerType = .none

    init(type: MapMarkerType) {

        self.type = type
    }

    func toolTip() -> NSAttributedString {

        let toolTipText = NSMutableAttributedString(string: "")

        let title = NSAttributedString(
            string: type.name().localized(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        /*let effects = NSAttributedString(
            string: "\n\nDescription \(Int.random(number: 10))",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(effects)*/

        return toolTipText
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.type.iconTexture())
    }
}

extension MapMarkerTypeViewModel: Hashable {

    public static func == (lhs: MapMarkerTypeViewModel, rhs: MapMarkerTypeViewModel) -> Bool {

        return lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {

        hasher.combine(self.type)
    }
}
