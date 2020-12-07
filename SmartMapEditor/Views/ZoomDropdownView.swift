//
//  PopUpButtonView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import SwiftUI
import Cocoa

struct ZoomDropdownView: NSViewRepresentable {

    @ObservedObject
    var viewModel: EditorContentViewModel

    //var onSelect: ((_ key: String) -> Void)?
    let options: [String] = ["0.5", "1.0", "2.0"]

    func makeNSView(context: Context) -> NSPopUpButton {

        let popup = NSPopUpButton(frame: CGRect(x: 0, y: 0, width: 48, height: 24), pullsDown: true)
        popup.menu!.autoenablesItems = false
        return popup
    }

    func updateNSView(_ popUpButton: NSPopUpButton, context: Context) {

        popUpButton.removeAllItems()

        let iconItem = NSMenuItem()
        let iconImage = NSImage(named: "gear-icon")
        iconImage?.size = NSSize(width: 12, height: 12)
        iconItem.image = iconImage

        let halfItem = NSMenuItem(title: "0.5", action: #selector(Coordinator.scaleHalfAction(_:)), keyEquivalent: "")
        halfItem.representedObject = self.viewModel
        halfItem.target = context.coordinator

        let normalItem = NSMenuItem(title: "1.0", action: #selector(Coordinator.scaleNormalAction(_:)), keyEquivalent: "")
        normalItem.representedObject = self.viewModel
        normalItem.target = context.coordinator
        
        let doubleItem = NSMenuItem(title: "2.0", action: #selector(Coordinator.scaleDoubleAction(_:)), keyEquivalent: "")
        doubleItem.representedObject = self.viewModel
        doubleItem.target = context.coordinator

        popUpButton.menu?.insertItem(iconItem, at: 0)
        popUpButton.menu?.insertItem(halfItem, at: 1)
        popUpButton.menu?.insertItem(normalItem, at: 2)
        popUpButton.menu?.insertItem(doubleItem, at: 3)

        let cell = popUpButton.cell as? NSButtonCell
        cell?.imagePosition = .imageOnly
        cell?.bezelStyle = .texturedRounded

        popUpButton.wantsLayer = true
        popUpButton.layer?.backgroundColor = NSColor.clear.cgColor
        popUpButton.isBordered = false
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject {
        
        var parent: ZoomDropdownView?
        
        init(parent: ZoomDropdownView?) {
            self.parent = parent
        }
        
        @objc func scaleHalfAction(_ sender: NSMenuItem) {
            let viewModel = sender.representedObject as! EditorContentViewModel
            viewModel.setZoom(to: 0.5)
            //self.parent?.onSelect?("0.5")
        }
        
        @objc func scaleNormalAction(_ sender: NSMenuItem) {
            let viewModel = sender.representedObject as! EditorContentViewModel
            viewModel.setZoom(to: 1.0)
            //self.parent?.onSelect?("1.0")
        }
        
        @objc func scaleDoubleAction(_ sender: NSMenuItem) {
            let viewModel = sender.representedObject as! EditorContentViewModel
            viewModel.setZoom(to: 2.0)
            //self.parent?.onSelect?("2.0")
        }
    }
}
