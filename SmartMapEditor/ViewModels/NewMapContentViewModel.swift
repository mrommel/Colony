//
//  NewMapContentViewModel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 07.12.20.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

/*enum MapType: String {
    
    case empty = "Empty"
    case continent = "Continent"
    
    static var all: [MapType] {
        return [.empty, .continent]
    }
    
    public static func from(name: String) -> MapType? {
        
        for mapType in MapType.all {
            if mapType.rawValue == name {
                return mapType
            }
        }
        
        return nil
    }
}*/

class NewMapContentViewModel: ObservableObject {
    
    @Published
    var type: String
    private var typeValue: MapType
    
    @Published
    var size: String
    private var sizeValue: MapSize
    
    @Published
    var map: MapModel? = nil
    
    init() {
        
        self.typeValue = .empty
        self.type = self.typeValue.name()
        
        self.sizeValue = .tiny
        self.size = self.sizeValue.name()
    }
    
    func setSize(to newSizeString: String) {
        
        if let sizeValue = MapSize.from(name: newSizeString) {
            self.sizeValue = sizeValue
            self.size = self.sizeValue.name()
        }
    }
    
    func setType(to newTypeString: String) {
        
        if let typeValue = MapType.from(name: newTypeString) {
            self.typeValue = typeValue
            self.type = self.typeValue.name()
        }
    }
}
