//
//  BottomRightBarViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 01.12.21.
//

import SwiftUI
import SmartAILibrary

protocol BottomRightBarViewModelDelegate: AnyObject {

    func focus(on point: HexPoint)
}

public class BottomRightBarViewModel: ObservableObject {

    @Published
    var mapOverviewViewModel: MapOverviewViewModel

    weak var delegate: BottomRightBarViewModelDelegate?

    public init() {

        self.mapOverviewViewModel = MapOverviewViewModel()

        self.mapOverviewViewModel.delegate = self
    }

    func refreshTile(at point: HexPoint) {

        self.mapOverviewViewModel.changed(at: point)
    }

    func updateRect(at point: HexPoint, size: CGSize) {

        self.mapOverviewViewModel.updateRect(at: point, size: size)
    }
}

extension BottomRightBarViewModel: MapOverviewViewModelDelegate {

    func minimapClicked(on point: HexPoint) {

        self.delegate?.focus(on: point)
    }
}
