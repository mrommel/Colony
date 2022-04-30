//
//  MapMarkerWaitingViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 30.04.22.
//

import SwiftUI
import SmartAILibrary

protocol MapMarkerWaitingViewModelDelegate: AnyObject {

    func cancelWaiting()
}

public class MapMarkerWaitingViewModel: ObservableObject {

    weak var delegate: MapMarkerWaitingViewModelDelegate?

    init() {

    }

    func cancelClicked() {

        self.delegate?.cancelWaiting()
    }
}
