//
//  Civ5MapImportingViewModel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 16.12.20.
//

import SmartAILibrary

class Civ5MapImportingViewModel: ObservableObject {
    
    typealias Civ5MapImportedHandler = (MapModel?) -> Void
    
    @Published
    var loading: Bool
    
    var mapImported: Civ5MapImportedHandler? = nil
    
    init(url: URL?) {
        
        self.loading = false
        
        self.importMap(from: url)
    }
    
    func importMap(from url: URL?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            
            self.loading = true
            
            DispatchQueue.global(qos: .background).async {
                
                let civ5MapLoader = Civ5MapReader()
                let civ5Map = civ5MapLoader.load(from: url)

                if let map = civ5Map?.toMap() {
                    
                    DispatchQueue.main.async {
                        
                        self.loading = false
                        self.mapImported?(map)
                    }
                } else {
                    fatalError("cant load \(url?.path ?? "none")")
                }
            }
        })
    }
}
