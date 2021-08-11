//
//  EditMetaDataViewModel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 19.12.20.
//

import SmartAILibrary
import SmartAssets

class EditMetaDataViewModel: ObservableObject {
    
    typealias ClosedHandler = () -> Void
    
    private let map: MapModel?
    
    @Published
    var name: String
    
    @Published
    var summary: String
    
    @Published
    var sizeString: String
    
    var closed: ClosedHandler? = nil
    
    init(of map: MapModel?) {
        
        self.map = map
        
        self.name = self.map?.name ?? "no name"
        self.summary = self.map?.summary ?? "no summary"
        self.sizeString = self.map?.size.name() ?? "no size"
    }
    
    func cancel() {
        
        print("cancel")
        self.closed?()
    }
    
    func save() {
        
        print("save")
        
        self.map?.name = self.name
        self.map?.summary = self.summary
        
        self.closed?()
    }
}
