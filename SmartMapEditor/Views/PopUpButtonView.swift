//
//  PopUpButtonView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import SwiftUI
import Cocoa

final class PopUpButtonView: NSObject, NSViewRepresentable {

    var onSelect: ((_ key: String) -> Void)?
    @Binding var options: [String]

    init(options: Binding<[String]>, onSelect: ((_ key: String) -> Void)?) {
        
        self._options = options
        self.onSelect = onSelect
    }
    
    func makeNSView(context: Context) -> NSPopUpButton {
        
        let popup = NSPopUpButton(frame: .zero)
        
        let menu = NSMenu(title: "drop")
        for item in self.options {
            menu.items.append(NSMenuItem(title: item, action: nil, keyEquivalent: ""))
        }
        
        popup.menu = menu
        
        popup.target = self
        popup.action = #selector(PopUpButtonView.itemSelected(_:))
        
        return popup
    }

    func updateNSView(_ popUpButton: NSPopUpButton, context: Context) {
        // print(popUpButton.frame)
    }
    
    @objc func itemSelected(_ sender: AnyObject) {

        print("selected: \(sender.selectedItem?.title ?? "---")")
        self.onSelect?(sender.selectedItem?.title ?? "")
    }
}
