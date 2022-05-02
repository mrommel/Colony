//
//  MapMarkerItemViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 29.04.22.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

protocol MapMarkerItemViewModelDelegage: AnyObject {

    func clickedCenter(at location: HexPoint)
    func clickedRemove(at location: HexPoint)
}

public class MapMarkerItemViewModel: ObservableObject, Identifiable {

    public let id: UUID = UUID()

    let markerType: MapMarkerType
    let markerTitle: String
    let markerLocation: HexPoint

    weak var delegate: MapMarkerItemViewModelDelegage?

    init(markerType: MapMarkerType, markerTitle: String, markerLocation: HexPoint) {

        self.markerType = markerType
        self.markerTitle = markerTitle.isEmpty ? markerType.name() : markerTitle
        self.markerLocation = markerLocation
    }

    init(marker: MapMarker) {

        self.markerType = marker.type
        self.markerTitle = marker.name.isEmpty ? marker.type.name() : marker.name
        self.markerLocation = marker.location
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.markerType.iconTexture())
    }

    func removeImage() -> NSImage {

        return ImageCache.shared.image(for: "remove")
    }

    func centerImage() -> NSImage {

        return ImageCache.shared.image(for: "jump-to")
    }

    func clickedRemove() {

        self.delegate?.clickedRemove(at: self.markerLocation)
    }

    func clickedCenter() {

        self.delegate?.clickedCenter(at: self.markerLocation)
    }
}

extension MapMarkerItemViewModel: Hashable {

    public static func == (lhs: MapMarkerItemViewModel, rhs: MapMarkerItemViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
