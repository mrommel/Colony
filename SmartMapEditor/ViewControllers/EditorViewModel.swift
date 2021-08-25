//
//  EditorViewModel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 28.02.21.
//

import SmartAILibrary

class EditorViewModel {
    
    typealias MapChangeHandler = (MapModel?) -> Void
    typealias OptionChangeHandler = (Bool) -> Void
    
    private var map: MapModel?
    var mapChanged: MapChangeHandler?
    var showStartLocationsChanged: OptionChangeHandler?
    var showInhabitantsChanged: OptionChangeHandler?
    var showSupportedPeopleChanged: OptionChangeHandler?
    
    func set(map: MapModel?) {

        self.map = map
        self.mapChanged?(map)
    }
    
    func currentMap() -> MapModel? {
        
        return self.map
    }
    
    // MARK: Options
    
    func setShowStartLocations(to value: Bool) {
        
        self.showStartLocationsChanged?(value)
    }
    
    func setShowInhabitants(to value: Bool) {
        
        self.showInhabitantsChanged?(value)
    }
    
    func setShowSupportedPeople(to value: Bool) {
        
        self.showSupportedPeopleChanged?(value)
    }
}
