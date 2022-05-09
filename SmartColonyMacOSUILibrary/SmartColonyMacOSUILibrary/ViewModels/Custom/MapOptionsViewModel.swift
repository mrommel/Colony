//
//  MapOptionsViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 08.05.22.
//

import SwiftUI

protocol MapOptionsViewModelDelegate: AnyObject {

    func changeShowGrid(to value: Bool)
    func changeShowResourceIcons(to value: Bool)
    func changeShowYieldsIcons(to value: Bool)

    // debug
    func changeShowHexCoords(to value: Bool)
    func changeShowCompleteMap(to value: Bool)
}

public class MapOptionsViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var toggleShowGrid: Bool {
        didSet {
            self.delegate?.changeShowGrid(to: self.toggleShowGrid)
        }
    }

    @Published
    var toggleShowResourceIcons: Bool {
        didSet {
            self.delegate?.changeShowResourceIcons(to: self.toggleShowResourceIcons)
        }
    }

    @Published
    var toggleShowYieldIcons: Bool {
        didSet {
            self.delegate?.changeShowYieldsIcons(to: self.toggleShowYieldIcons)
        }
    }

    // debug

    @Published
    var toggleShowHexCoords: Bool {
        didSet {
            self.delegate?.changeShowHexCoords(to: self.toggleShowHexCoords)
        }
    }

    @Published
    var toggleShowCompleteMap: Bool {
        didSet {
            self.delegate?.changeShowCompleteMap(to: self.toggleShowCompleteMap)
        }
    }

    weak var delegate: MapOptionsViewModelDelegate?

    init() {

        self.toggleShowGrid = false
        self.toggleShowResourceIcons = true
        self.toggleShowYieldIcons = false

        self.toggleShowHexCoords = false
        self.toggleShowCompleteMap = false
    }
}
