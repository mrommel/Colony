//
//  PageControlView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.11.21.
//

import SwiftUI

public class NSPageControl: NSView {

    public var numberOfPages: Int = 0
    public var currentPage: Int = 0 {
        didSet(oldValue) {
            if currentPage < 0 {
                currentPage = 0
            }
            if currentPage > numberOfPages - 1 {
                currentPage = numberOfPages - 1
            }
            didSetCurrentPage(oldValue, newlySelectedPage: currentPage)
        }
    }
    public var hidesForSinglePage: Bool = true
    public var pageIndicatorTintColor: NSColor = NSColor.darkGray
    public var currentPageIndicatorTintColor: NSColor = NSColor.white
    public var animationDuration: CFTimeInterval = 0.04
    public var dotLength: CGFloat = 8.0
    public var dotMargin: CGFloat = 12.0

    private var dotLayers: [CAShapeLayer] = []

    // MARK: - lifecycle
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let dotWidthSum: CGFloat = dotLength * CGFloat(numberOfPages)
        let marginWidthSum: CGFloat = dotMargin * CGFloat((numberOfPages - 1))
        let minimumRequiredWidth: CGFloat = dotWidthSum + marginWidthSum

        let hasEnoughHeight: Bool = dirtyRect.height >= dotLength
        let hasEnoughWidth: Bool = dirtyRect.width >= minimumRequiredWidth
        if !hasEnoughWidth || !hasEnoughHeight {
            Swift.print("dirtyRect doesn't have enough space to draw all dots")
            Swift.print("current Rect: \(dirtyRect)")
            Swift.print("required Size: \(CGSize(width: minimumRequiredWidth, height: dotLength))")
        }

        for layer in dotLayers {
            layer.removeFromSuperlayer()
        }
        dotLayers = []
        self.layer = CALayer()
        self.wantsLayer = true

        for index: Int in 0..<numberOfPages {
            let minX: CGFloat = (dirtyRect.width - minimumRequiredWidth) / 2
            let indexOffset: CGFloat = (dotLength + dotMargin) * CGFloat(index)
            let x: CGFloat = minX + indexOffset
            let verticalCenter: CGFloat = (dirtyRect.height - dotLength) / 2
            let y: CGFloat = verticalCenter - dotLength / 2
            let rect: CGRect = NSRect(x: x, y: y, width: dotLength, height: dotLength)
            let cgPath: CGMutablePath = CGMutablePath()
            cgPath.addEllipse(in: rect)

            let fillColor: NSColor = (index == currentPage) ? currentPageIndicatorTintColor : pageIndicatorTintColor
            let shapeLayer: CAShapeLayer = CAShapeLayer()
            shapeLayer.path = cgPath
            shapeLayer.fillColor = fillColor.cgColor

            layer?.addSublayer(shapeLayer)
            dotLayers.append(shapeLayer)
        }
    }

    // MARK: - private
    private func didSetCurrentPage(_ selectedPage: Int, newlySelectedPage: Int) {

        if selectedPage == newlySelectedPage {
            return
        }

        let oldPageAnimation: CABasicAnimation = fillColorAnimation(with: pageIndicatorTintColor)
        dotLayers[selectedPage].add(oldPageAnimation, forKey: "oldPageAnimation")
        let newPageAnimation: CABasicAnimation = fillColorAnimation(with: currentPageIndicatorTintColor)
        dotLayers[newlySelectedPage].add(newPageAnimation, forKey: "newPageAnimation")
    }

    private func fillColorAnimation(with color: NSColor) -> CABasicAnimation {

        let fillColorAnimation: CABasicAnimation = CABasicAnimation(keyPath: "fillColor")
        fillColorAnimation.toValue = color.cgColor
        fillColorAnimation.duration = animationDuration
        fillColorAnimation.fillMode = CAMediaTimingFillMode.forwards
        fillColorAnimation.isRemovedOnCompletion = false
        return fillColorAnimation
    }
}

struct PageControlView: NSViewRepresentable {

    @Binding
    var current: Int

    let pages: Int

    init(current: Binding<Int>, pages: Int) {

        self._current = current
        self.pages = pages
    }

    func makeNSView(context: NSViewRepresentableContext<PageControlView>) -> NSPageControl {

        let page = NSPageControl()
        page.currentPageIndicatorTintColor = .black
        page.numberOfPages = self.pages
        page.pageIndicatorTintColor = .gray
        return page
    }

    func updateNSView(_ uiView: NSPageControl, context: NSViewRepresentableContext<PageControlView>) {

        uiView.currentPage = self.current
    }
}
