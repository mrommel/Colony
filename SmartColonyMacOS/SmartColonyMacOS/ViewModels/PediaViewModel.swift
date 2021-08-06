//
//  PediaViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 06.08.21.
//

import SmartAssets
import Cocoa
import SmartAILibrary
import SmartMacOSUILibrary

protocol PediaViewModelDelegate: AnyObject {
    
    func canceled()
}

class PediaViewModel: ObservableObject {
    
    weak var delegate: PediaViewModelDelegate?
    
    func cancel() {
        
        self.delegate?.canceled()
    }
}
