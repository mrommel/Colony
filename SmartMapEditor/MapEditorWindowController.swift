//
//  MapEditorWindowController.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 29.11.20.
//

import Cocoa

extension NSImage.Name {
    static let calendar = "calendar"
    static let today = "clock"
}

extension NSToolbarItem.Identifier {
    static let calendar = NSToolbarItem.Identifier(rawValue: "ShowCalendar")
    static let today = NSToolbarItem.Identifier(rawValue: "GoToToday")
}

extension NSToolbar {
    static let taskListToolbar: NSToolbar = {
        let toolbar = NSToolbar(identifier: "TaskListToolbar")
        toolbar.displayMode = .iconAndLabel

        return toolbar
    }()
}


class MapEditorWindowController: NSWindowController {

    override func windowDidLoad() {

        NSToolbar.taskListToolbar.delegate = self

        if #available(OSX 10.14, *) {
            self.window?.appearance = NSAppearance(named: .darkAqua)
        }

        window?.title = "SmartMapEditor"
        window?.toolbar = .taskListToolbar
        //window?.titleVisibility = .hidden

        /*let customToolbar = NSToolbar()
        
        customToolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier(rawValue: "generate"), at: 0)
        
        window?.toolbar = customToolbar*/
    }

    @IBAction override func newWindowForTab(_ sender: Any?) {

        // Implementing this will display the button already
        let newWindowController = self.storyboard!.instantiateInitialController() as! MapEditorWindowController
        let newWindow = newWindowController.window!
        newWindow.windowController = self
        self.window!.addTabbedWindow(newWindow, ordered: .above)
    }

    @IBAction func newMap(_ sender: AnyObject) {

        print("new map")
    }
}

extension MapEditorWindowController: NSToolbarDelegate {

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.today, .calendar]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.today, .calendar]
    }

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {

        switch itemIdentifier {
        case NSToolbarItem.Identifier.calendar:
            let button = NSButton(image: NSImage(named: .calendar)!, target: nil, action: nil)
            button.bezelStyle = .texturedRounded
            return customToolbarItem(itemIdentifier: .calendar, label: "Calendar", paletteLabel: "Calendar", toolTip: "Show day picker", itemContent: button)
        case NSToolbarItem.Identifier.today:
            let button = NSButton(title: "Today", target: nil, action: nil)
            button.bezelStyle = .texturedRounded
            return customToolbarItem(itemIdentifier: .calendar, label: "Today", paletteLabel: "Today", toolTip: "Go to today", itemContent: button)
        default:
            return nil
        }
    }

    /**
         Mostly base on Apple sample code: https://developer.apple.com/documentation/appkit/touch_bar/integrating_a_toolbar_and_touch_bar_into_your_app
         */
    func customToolbarItem(itemIdentifier: NSToolbarItem.Identifier, label: String, paletteLabel: String, toolTip: String, itemContent: NSButton) -> NSToolbarItem? {

        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)

        toolbarItem.label = label
        toolbarItem.paletteLabel = paletteLabel
        toolbarItem.toolTip = toolTip

        toolbarItem.view = itemContent

        // We actually need an NSMenuItem here, so we construct one.
        let menuItem: NSMenuItem = NSMenuItem()
        menuItem.submenu = nil
        menuItem.title = label
        menuItem.target = self

        toolbarItem.menuFormRepresentation = menuItem

        return toolbarItem
    }
}
