//
//  main.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 29.11.20.
//

import Foundation
import Cocoa

let delegate = AppDelegate()
let menu = MapEditorMenu()

NSApplication.shared.delegate = delegate
NSApplication.shared.mainMenu = menu
let _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
