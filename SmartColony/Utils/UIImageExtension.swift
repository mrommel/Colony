//
//  UIImageExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import UIKit

extension UIImage {

    func resizeRasterizedTo(targetSize: CGSize) -> UIImage? {

        let size = self.size

        let widthRatio = targetSize.width / self.size.width
        let heightRatio = targetSize.height / self.size.height

        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        guard let scaledContext = UIGraphicsGetCurrentContext() else {
            fatalError("Can't create graphics context")
        }
        scaledContext.interpolationQuality = .none

        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    // https://stackoverflow.com/questions/20021478/add-transparent-space-around-a-uiimage
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right, height:
                    self.size.height + insets.top + insets.bottom), false, self.scale)
        //let context = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}
