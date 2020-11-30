//
//  MapEditorToolbar.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import Cocoa

class MapEditorToolbar: NSToolbar {

    override init(identifier: NSToolbar.Identifier) {
        super.init(identifier: identifier)

        self.delegate = self
    }
}

extension MapEditorToolbar: NSToolbarDelegate {

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        return nil
    }
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.print, .showColors, .flexibleSpace, . space] // Whatever items you want to allow
    }
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.flexibleSpace, .showColors] // Whatever items you want as default
    }
}
