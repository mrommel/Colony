//
//  PopupButton.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 06.12.20.
//

import Foundation
import SwiftUI

// https://github.com/kubedoctor/kubedoctor/blob/e145e666e3cae7a80c4470d65146ca24f50fb8d5/macOS/KubeDoctor/View/PopupButton.swift
struct PopupButton<T: Hashable>: NSViewRepresentable {
    @Binding var selectedValue: T
    @Binding var items: [T]

    private let onChange: ((T) -> Void)?

    init(selectedValue: Binding<T>, items: [T], onChange: ((T) -> Void)? = nil) {
        self._selectedValue = selectedValue
        self._items = Binding.constant(items)
        self.onChange = onChange
    }

    func makeNSView(context: Context) -> NSPopUpButton {
        let button = NSPopUpButton(frame: .zero, pullsDown: false)
        button.bezelStyle = .texturedRounded
        button.target = context.coordinator
        button.action = #selector(Coordinator.valueChanged(_:))
        button.addItems(withTitles: self.items.map({ String(describing: $0) }))
        let index = self.items.firstIndex(of: self.selectedValue) ?? 0
        button.selectItem(at: index)
        return button
    }

    func updateNSView(_ view: NSPopUpButton, context: Context) {
        context.coordinator.items = self.items
        view.removeAllItems()
        view.addItems(withTitles: self.items.map({ String(describing: $0) }))
        let index = self.items.firstIndex(of: self.selectedValue) ?? 0
        view.selectItem(at: index)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(binding: self.$selectedValue, items: self.items, onChange: self.onChange)
    }

    final class Coordinator: NSObject {
        let binding: Binding<T>
        var items: [T]

        let onChange: ((T) -> Void)?

        init(binding: Binding<T>, items: [T], onChange: ((T) -> Void)?) {
            self.binding = binding
            self.items = items
            self.onChange = onChange
        }

        @objc func valueChanged(_ sender: NSPopUpButton) {
            self.binding.wrappedValue = self.items[sender.indexOfSelectedItem]
            self.onChange?(self.binding.wrappedValue)
        }
    }
}
