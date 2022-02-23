//
//  SlpFileExtension.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.02.22.
//

import Foundation

extension SlpFrame {

    internal func pixels() -> PixelBuffer {

        var buffer = PixelBuffer(width: Int(self.header.width), height: Int(self.header.height), color: TypeColor.clear)
        let palette = Palette.aoe2_palette

        for (index, colorIndex) in self.data.indicesArray.enumerated() where colorIndex != 255 { // 255 is transparent

            let color: TypeColor = palette[Int(colorIndex)]
            buffer.set(color: color, at: index)
        }

        return buffer
    }

    public func image() -> TypeImage? {

        return self.pixels().toNSImage()
    }
}
