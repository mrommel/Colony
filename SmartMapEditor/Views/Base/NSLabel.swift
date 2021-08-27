//
//  File.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 28.11.20.
//

import Cocoa

open class NSLabel: NSTextField {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.isBezeled = false
        self.drawsBackground = false
        self.isEditable = false
        self.isSelectable = false
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        self.isBezeled = false
        self.drawsBackground = false
        self.isEditable = false
        self.isSelectable = false
    }

    var text: String {
        get {
            return self.stringValue
        }
        set {
            self.stringValue = newValue
        }
    }
}
