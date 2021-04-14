//
//  CursorLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.04.21.
//

import SwiftUI
import SmartAILibrary

// https://gist.github.com/gurgeous/bc0c3d2e748c3b6fe7f2
extension CGPoint {
    
    init(x: CGFloat) {
        self.init()
        self.x = x
        self.y = 0.0
    }
    init(y: CGFloat) {
        self.init()
        self.x = 0.0
        self.y = y
    }
    func with(x: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    func with(y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    func ceil() -> CGPoint {
        return CGPoint(x: CoreGraphics.ceil(x), y: CoreGraphics.ceil(y))
    }
    func floor() -> CGPoint {
        return CGPoint(x: CoreGraphics.floor(x), y: CoreGraphics.floor(y))
    }
    func round() -> CGPoint {
        return CGPoint(x: CoreGraphics.round(x), y: CoreGraphics.round(y))
    }
    func size() -> CGSize {
        return CGSize(width: x, height: y)
    }
    func toInts() -> (x: Int, y: Int) {
        return (x: Int(x), y: Int(y))
    }
}

func *(l: CGSize, r: CGFloat) -> CGSize { return CGSize(width: l.width * r, height: l.height * r) }

public struct CursorLayerView: View {
    
    @ObservedObject
    var viewModel: CursorLayerViewModel
    
    init(viewModel: CursorLayerViewModel) {
        
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Image("cursor")
            .resizable()
            .scaledToFit()
            .frame(width: 144, height: 144, alignment: .center)
            .offset(self.viewModel.cursorOffset ?? CGSize.zero)
    }
}
