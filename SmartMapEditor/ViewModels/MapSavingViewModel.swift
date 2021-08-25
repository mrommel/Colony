//
//  MapSavingViewModel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 10.12.20.
//

import Foundation
import SmartAILibrary

class MapSavingViewModel: ObservableObject {
    
    typealias MapSavedHandler = (Bool) -> Void
    
    @Published
    var saving: Bool
    
    var mapSaved: MapSavedHandler?
    
    init(map: MapModel?, to url: URL?) {
        
        self.saving = false
        
        self.saveMap(map: map, to: url)
    }
    
    func saveMap(map: MapModel?, to url: URL?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            
            self.saving = true
            
            DispatchQueue.global(qos: .background).async {
                
                let mapWriter = MapWriter()
                let written = mapWriter.write(map: map, to: url)
                
                DispatchQueue.main.async {
                    
                    self.saving = false
                    self.mapSaved?(written)
                }
            }
        })
    }
}
