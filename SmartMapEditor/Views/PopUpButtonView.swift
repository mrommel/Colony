//
//  PopUpButtonView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import SwiftUI
import Cocoa

struct PopUpButtonView: NSViewRepresentable {

    func makeNSView(context: Context) -> NSPopUpButton {
        NSPopUpButton(frame: .zero)
    }

    func updateNSView(_ popUpButton: NSPopUpButton, context: Context) {
        // print(popUpButton.frame)
    }
}
