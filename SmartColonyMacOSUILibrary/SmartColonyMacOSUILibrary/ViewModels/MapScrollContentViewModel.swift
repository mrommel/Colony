//
//  MapScrollContentViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 21.03.21.
//

import Foundation
import SmartAILibrary

open class MapScrollContentViewModel: ObservableObject {
    
    @Published public var map: MapModel? = nil
    @Published public var zoom: CGFloat
    
    public var didChange: ((HexPoint) -> ())? = nil
    public var shouldRedraw: (() -> ())? = nil

    public init() {
        self.zoom = 1.0
    }
    
    open func setFocus(to tile: AbstractTile?) {
    }
    
    open func options() -> MapDisplayOptions {
        
        return MapDisplayOptions(showFeatures: true, showResources: true, showBorders: true, showStartPositions: false, showInhabitants: false, showSupportedPeople: false)
    }
    
    open func draw(at point: HexPoint) {

        guard let map = self.map else {
            return
        }
        
        // draw
    }
}
