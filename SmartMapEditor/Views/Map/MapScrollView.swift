//
//  MapScrollView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 02.12.20.
//

import Cocoa

class MapScrollView: NSScrollView {

    override init(frame: NSRect) {

        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    func scrollBy(dx: CGFloat, dy: CGFloat) {
        
        self.contentView.bounds.origin = self.contentView.bounds.origin - CGPoint(x: dx, y: dy)
    }
}
