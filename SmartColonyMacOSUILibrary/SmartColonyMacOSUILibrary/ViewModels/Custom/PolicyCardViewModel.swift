//
//  PolicyCardViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 10.05.21.
//

import Cocoa
import SmartAILibrary
import SmartAssets

enum PolicyCardState {

    case selected
    case active
    case disabled

    case none

    func textureName() -> String {

        switch self {

        case .none: return "checkbox-none"

        case .selected: return "checkbox-checked"
        case .active: return "checkbox-unchecked"
        case .disabled: return "checkbox-disabled"
        }
    }
}

protocol PolicyCardViewModelDelegate: AnyObject {

    func updateSelection()
}

class PolicyCardViewModel: ObservableObject {

    // variables
    let policyCardType: PolicyCardType

    @Published
    var state: PolicyCardState

    @Published
    var selected: Bool {
        didSet {

            if self.state != .disabled {

                if self.selected {
                    self.state = .selected
                } else {
                    self.state = .active
                }

                self.delegate?.updateSelection()
            }
        }
    }

    weak var delegate: PolicyCardViewModelDelegate?

    init(policyCardType: PolicyCardType, state: PolicyCardState) {

        self.policyCardType = policyCardType
        self.state = state

        self.selected = state == .selected
    }

    func title() -> String {

        return self.policyCardType.name().localized()
    }

    func summary() -> String {

        return self.policyCardType.bonus().localized()
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: self.policyCardType.iconTexture())
    }
}

extension PolicyCardViewModel: Hashable {

    static func == (lhs: PolicyCardViewModel, rhs: PolicyCardViewModel) -> Bool {

        return lhs.policyCardType == rhs.policyCardType
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.policyCardType)
    }
}
