//
//  HeaderButtonViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI

enum HeaderButtonType {

    case science
    case culture
    case government
    case log

    case ranking
    case tradeRoutes

    func iconTexture(for state: Bool) -> String {

        switch self {

        case .science:
            return state ? "header-button-science-active" : "header-button-science-disabled"
        case .culture:
            return state ? "header-button-culture-active" : "header-button-culture-disabled"
        case .government:
            return state ? "header-button-government-active" : "header-button-government-disabled"
        case .log:
            return state ? "header-button-log-active" : "header-button-log-disabled"
        case .ranking:
            return state ? "header-button-log-active" : "header-button-log-disabled"
        case .tradeRoutes:
            return state ? "header-button-tradeRoutes-active" : "header-button-tradeRoutes-disabled"
        }
    }
}

protocol HeaderButtonViewModelDelegate: AnyObject {

    func clicked(on type: HeaderButtonType)
}

class HeaderButtonViewModel: ObservableObject {

    let type: HeaderButtonType

    @Published
    var active: Bool = true

    weak var delegate: HeaderButtonViewModelDelegate?

    init(type: HeaderButtonType) {

        self.type = type
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.type.iconTexture(for: self.active))
    }

    func clicked() {

        print("clicked on header: \(self.type)")
        self.delegate?.clicked(on: self.type)
    }
}
