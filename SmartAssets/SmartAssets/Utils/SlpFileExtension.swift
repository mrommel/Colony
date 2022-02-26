//
//  SlpFileExtension.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.02.22.
//

import Foundation

extension SlpFrame {

    internal func pixels(with palette: [TypeColor] = SlpPalette.default.colors) -> PixelBuffer {

        var buffer = PixelBuffer(width: Int(self.header.width), height: Int(self.header.height), color: TypeColor.clear)

        for (index, colorIndex) in self.data.indicesArray.enumerated() where colorIndex != 255 { // 255 is transparent

            let color: TypeColor = palette[Int(colorIndex)]
            buffer.set(color: color, at: index)
        }

        return buffer
    }

    public func image(with palette: [TypeColor] = SlpPalette.default.colors) -> TypeImage? {

        return self.pixels(with: palette).toNSImage()
    }
}
