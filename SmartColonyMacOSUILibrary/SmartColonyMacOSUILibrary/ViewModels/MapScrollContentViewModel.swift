//
//  MapScrollContentViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 21.03.21.
//

import Foundation
import SmartAILibrary

public class MapScrollContentViewModel: ObservableObject {
    
    @Published var map: MapModel? = nil
    @Published var zoom: CGFloat
    
    var didChange: ((HexPoint) -> ())? = nil
    var shouldRedraw: (() -> ())? = nil

    public init() {
        self.zoom = 1.0
    }
    
    func setFocus(to tile: AbstractTile?) {
    }
    
    func options() -> MapDisplayOptions {
        
        return MapDisplayOptions(showFeatures: true, showResources: true, showBorders: true, showStartPositions: false, showInhabitants: false, showSupportedPeople: false)
    }
    
    func draw(at point: HexPoint) {

        guard let map = self.map else {
            return
        }
        
        // draw
    }
}
