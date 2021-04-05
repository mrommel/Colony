//
//  ActivityIndicator.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 07.12.20.
//

import SwiftUI

public struct ActivityIndicator: NSViewRepresentable {

    @Binding public var isAnimating: Bool
    public let style: NSProgressIndicator.Style
    public let controlSize: NSControl.ControlSize
    public let hideWhenNotAnimating: Bool

    public init(isAnimating: Binding<Bool>, style: NSProgressIndicator.Style, controlSize: NSControl.ControlSize = .small, hideWhenNotAnimating: Bool = true) {
        
        self._isAnimating = isAnimating
        self.style = style
        self.controlSize = controlSize
        self.hideWhenNotAnimating = hideWhenNotAnimating
    }

    public func makeNSView(context: Context) -> NSProgressIndicator {
        let progressView = NSProgressIndicator()
        progressView.style = style
        progressView.controlSize = controlSize
        return progressView
    }

    public func updateNSView(_ progressView: NSProgressIndicator, context: Context) {

        if self.isAnimating {
            if hideWhenNotAnimating {
                progressView.isHidden = false
            }
            progressView.startAnimation(nil)
        } else {
            progressView.stopAnimation(nil)
            if hideWhenNotAnimating {
                progressView.isHidden = true
            }
        }
    }
}
