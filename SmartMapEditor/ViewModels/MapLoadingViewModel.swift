//
//  MapLoadingViewModel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 09.12.20.
//

import SmartAILibrary

class MapLoadingViewModel: ObservableObject {
    
    typealias MapLoadedHandler = (MapModel?) -> Void
    
    @Published
    var loading: Bool
    
    var mapLoaded: MapLoadedHandler?
    
    init(url: URL?) {
        
        self.loading = false
        
        self.loadMap(from: url)
    }
    
    func loadMap(from url: URL?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            
            self.loading = true
            
            DispatchQueue.global(qos: .background).async {
                
                let mapLoader = MapLoader()
                if let map = mapLoader.load(from: url, for: .alexander) {
                    
                    DispatchQueue.main.async {
                        
                        self.loading = false
                        self.mapLoaded?(map)
                    }
                } else {
                    fatalError("cant load \(url?.path ?? "none")")
                }
            }
        })
    }
}
