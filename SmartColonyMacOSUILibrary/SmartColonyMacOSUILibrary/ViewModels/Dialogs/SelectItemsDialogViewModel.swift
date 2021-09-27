//
//  SelectItemsDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.09.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol SelectItemViewModelDelegate: AnyObject {

    func selected(index: Int)
}

struct SelectItemViewModel: Identifiable {

    var id = UUID()

    var iconTextureName: String?
    var title: String
    var subtitle: String

    weak var delegate: SelectItemViewModelDelegate?

    private let index: Int

    init(item: SelectableItem, index: Int) {

        self.iconTextureName = item.iconTexture
        self.title = item.title
        self.subtitle = item.subtitle

        self.index = index
    }

    func icon() -> NSImage {

        if let textureName = self.iconTextureName {
            return ImageCache.shared.image(for: textureName)
        }

        return NSImage()
    }

    func selected() {

        self.delegate?.selected(index: self.index)
    }
}

extension SelectItemViewModel: Hashable {

    static func == (lhs: SelectItemViewModel, rhs: SelectItemViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}

class SelectItemsDialogViewModel: ObservableObject {

    typealias SelectItemsCompletionBlock = (Int) -> Void

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var itemViewModels: [SelectItemViewModel]

    weak var delegate: GameViewModelDelegate?
    private var completion: SelectItemsCompletionBlock?

    init() {

        self.title = "Title"
        self.itemViewModels = [
            SelectItemViewModel(item: SelectableItem(title: "Title 0"), index: 0),
            SelectItemViewModel(item: SelectableItem(title: "Title 1"), index: 1)
        ]
    }

    func update(title: String, items: [SelectableItem], completion: @escaping SelectItemsCompletionBlock) {

        self.title = title
        self.itemViewModels = items.enumerated().map { (index, element) in
            var selectItemViewModel = SelectItemViewModel(item: element, index: index)
            selectItemViewModel.delegate = self
            return selectItemViewModel
        }
        self.completion = completion
    }
}

extension SelectItemsDialogViewModel: SelectItemViewModelDelegate {

    func selected(index: Int) {

        self.completion?(index)
    }
}

extension SelectItemsDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
