//
//  MapProgressViewModel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 07.12.20.
//

import SwiftUI
import SmartAILibrary

class MapProgressViewModel: ObservableObject {
    
    typealias MapCreatedHandler = (MapModel?) -> Void
    
    @Published
    var generating: Bool
    
    @Published
    var progress: String
    
    var mapCreated: MapCreatedHandler? = nil
    
    init(mapType: MapType, mapSize: MapSize) {

        self.generating = false
        self.progress = ""
        
        switch mapType {
        
        case .continents:
            self.generatingContinents(with: mapSize)
            
        case .earth, .pangaea, .archipelago, .inlandsea, .custom:
            self.generatingEmpty(with: mapSize)
            
        case .empty:
            self.generatingEmpty(with: mapSize)
        }
    }
    
    func generatingContinents(with mapSize: MapSize) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            
            self.generating = true
            
            DispatchQueue.global(qos: .background).async {
                
                // generate map
                let mapOptions = MapOptions(withSize: mapSize, leader: .alexander, handicap: .settler)
                mapOptions.enhanced.sealevel = .low

                let generator = MapGenerator(with: mapOptions)
                generator.progressHandler = { progress, text in
                    DispatchQueue.main.async {
                        self.progress = text
                    }
                }

                let map = generator.generate()
                
                DispatchQueue.main.async {
                    
                    self.generating = false
                    self.mapCreated?(map)
                }
            }
        })
    }
    
    func generatingEmpty(with mapSize: MapSize) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            
            self.generating = true
            
            DispatchQueue.global(qos: .background).async {

                let map = MapModel(width: mapSize.width(), height: mapSize.height())
                
                DispatchQueue.main.async {
                    
                    self.generating = false
                    self.mapCreated?(map)
                }
            }
        })
    }
}
