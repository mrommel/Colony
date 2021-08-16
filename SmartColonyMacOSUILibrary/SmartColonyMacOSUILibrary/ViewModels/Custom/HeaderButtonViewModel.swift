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
            return state ? "header-science-button-active" : "header-science-button-disabled"
        case .culture:
            return state ? "header-culture-button-active" : "header-culture-button-disabled"
        case .government:
            return state ? "header-government-button-active" : "header-government-button-disabled"
        case .log:
            return state ? "header-log-button-active" : "header-log-button-disabled"
        case .ranking:
            return state ? "header-log-button-active" : "header-log-button-disabled"
        case .tradeRoutes:
            return state ? "header-log-button-active" : "header-log-button-disabled"
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
