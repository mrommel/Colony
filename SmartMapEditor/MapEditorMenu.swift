//
//  MapEditorMenu.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import Cocoa
import AppKit
import SmartAILibrary

class MapEditorMenu: NSMenu {

    private lazy var applicationName = ProcessInfo.processInfo.processName

    override init(title: String) {
        super.init(title: title)

        let mainMenu = NSMenuItem()
        mainMenu.submenu = NSMenu(title: "MainMenu")
        mainMenu.submenu?.items = [
            NSMenuItem(title: "About \(applicationName)", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Preferences...", action: nil, keyEquivalent: ","),
            NSMenuItem.separator(),
            NSMenuItem(title: "Hide \(applicationName)", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h"),
            NSMenuItem(title: "Hide Others", target: self, action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h", modifier: .init(arrayLiteral: [.command, .option])),
            NSMenuItem(title: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Quit \(applicationName)", action: #selector(NSApplication.shared.terminate(_:)), keyEquivalent: "q")
        ]

        let fileMenu = NSMenuItem()
        fileMenu.submenu = NSMenu(title: "File")
        fileMenu.submenu?.items = [
            NSMenuItem(title: "New", target: self, action: #selector(MapEditorMenu.newMap(_:)), keyEquivalent: "n"),
            NSMenuItem(title: "Open", target: self, action: #selector(MapEditorMenu.openMap(_:)), keyEquivalent: "o"),
            NSMenuItem.separator(),
            NSMenuItem(title: "Import Civ5 Map", target: self, action: #selector(MapEditorMenu.importCiv5Map(_:)), keyEquivalent: "i"),
            NSMenuItem.separator(),
            //NSMenuItem(title: "Save", action: #selector(NSDocument.save(_:)), keyEquivalent: "s"),
            NSMenuItem(title: "Save As...", target: self, action: #selector(MapEditorMenu.saveMap(_:)), keyEquivalent: "S"),
            //NSMenuItem(title: "Revert to Saved...", action: #selector(NSDocument.revertToSaved(_:)), keyEquivalent: ""),
            //NSMenuItem.separator(),
            //NSMenuItem(title: "Export", action: nil, keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w"),
        ]

        let editMenu = NSMenuItem()
        editMenu.submenu = NSMenu(title: "Edit")
        editMenu.submenu?.items = [
            NSMenuItem(title: "Undo", action: #selector(UndoManager.undo), keyEquivalent: "z"),
            NSMenuItem(title: "Redo", action: #selector(UndoManager.redo), keyEquivalent: "Z"),
            NSMenuItem.separator(),
            NSMenuItem(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x"),
            NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c"),
            NSMenuItem(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v"),
            NSMenuItem.separator(),
            NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a"),
            NSMenuItem.separator(),
            NSMenuItem(title: "Delete", target: self, action: nil, keyEquivalent: "⌫", modifier: .init()),
            NSMenuItem(title: "Duplicate", action: #selector(NSApplication.copy), keyEquivalent: "d"),
        ]

        let viewMenu = NSMenuItem()
        viewMenu.submenu = NSMenu(title: "Map")
        viewMenu.submenu?.items = [
            NSMenuItem(title: "Edit Meta Data", target: self, action: #selector(MapEditorMenu.editMetaData(_:)), keyEquivalent: "e"),
            NSMenuItem.separator(),
            NSMenuItem(title: "Debug HeightMap", target: self, action: #selector(MapEditorMenu.debugHeightMap(_:)), keyEquivalent: "d"),
        ]

        let windowMenu = NSMenuItem()
        windowMenu.submenu = NSMenu(title: "Window")
        windowMenu.submenu?.items = [
            NSMenuItem(title: "Minmize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m"),
            NSMenuItem(title: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Show All", action: #selector(NSApplication.arrangeInFront(_:)), keyEquivalent: "m")
        ]

        let helpMenu = NSMenuItem()
        let helpMenuSearch = NSMenuItem()
        helpMenuSearch.view = NSTextField()
        helpMenu.submenu = NSMenu(title: "Help")
        helpMenu.submenu?.items = [
            helpMenuSearch,
            NSMenuItem(title: "Documentation", target: self, action: #selector(openDocumentation(_:)), keyEquivalent: ""),
        ]

        self.items = [mainMenu, fileMenu, editMenu, viewMenu, windowMenu, helpMenu]
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapEditorMenu {

    @objc fileprivate func newMap(_ sender: AnyObject) {

        if let window = NSApplication.shared.windows.first,
            let editorViewController = window.contentViewController as? EditorViewController {

            let newMapViewController = NewMapViewController()
            editorViewController.presentAsSheet(newMapViewController)
        }
    }

    @objc fileprivate func openMap(_ sender: AnyObject) {

        let dialog = NSOpenPanel()

        dialog.title = "Choose a .map file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = true
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes = ["map"]

        if dialog.runModal() == NSApplication.ModalResponse.OK {

            guard dialog.url?.path != nil else {
                print("no path")
                return
            }

            if let window = NSApplication.shared.windows.first,
                let editorViewController = window.contentViewController as? EditorViewController {

                let mapLoadingViewController = MapLoadingViewController(url: dialog.url)
                editorViewController.presentAsSheet(mapLoadingViewController)
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }

    @objc fileprivate func importCiv5Map(_ sender: AnyObject) {

        let dialog = NSOpenPanel()

        dialog.title = "Choose a .Civ5Map file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = true
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes = ["Civ5Map"]

        if dialog.runModal() == NSApplication.ModalResponse.OK {

            guard dialog.url?.path != nil else {
                print("no path")
                return
            }

            if let window = NSApplication.shared.windows.first,
                let editorViewController = window.contentViewController as? EditorViewController {

                let civ5mapImportingViewController = Civ5MapImportingViewController(url: dialog.url)
                editorViewController.presentAsSheet(civ5mapImportingViewController)
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }

    @objc fileprivate func saveMap(_ sender: AnyObject) {

        let dialog = NSSavePanel()

        dialog.nameFieldStringValue = "new.map"

        if dialog.runModal() == NSApplication.ModalResponse.OK {

            if let window = NSApplication.shared.windows.first,
                let editorViewController = window.contentViewController as? EditorViewController {

                if let map = editorViewController.viewModel.currentMap() {

                    let mapSavingViewController = MapSavingViewController(map: map, to: dialog.url)
                    editorViewController.presentAsSheet(mapSavingViewController)
                } else {
                    print("no map")
                }
            }
        }
    }

    @objc fileprivate func editMetaData(_ sender: AnyObject) {

        if let window = NSApplication.shared.windows.first,
            let editorViewController = window.contentViewController as? EditorViewController {

            if let map = editorViewController.viewModel.currentMap() {

                let editMetaDataViewController = EditMetaDataViewController(of: map)
                editorViewController.presentAsSheet(editMetaDataViewController)
            }
        }
    }

    @objc fileprivate func debugHeightMap(_ sender: AnyObject) {

        if let window = NSApplication.shared.windows.first,
            let editorViewController = window.contentViewController as? EditorViewController {

            let debugHeightMapViewController = DebugHeightMapViewController()
            editorViewController.presentAsSheet(debugHeightMapViewController)
        }
    }

    @objc fileprivate func openDocumentation(_ sender: AnyObject) {
        NSWorkspace.shared.open(URL(string: "https://github.com/mrommel/Colony/wiki")!)
    }
}
