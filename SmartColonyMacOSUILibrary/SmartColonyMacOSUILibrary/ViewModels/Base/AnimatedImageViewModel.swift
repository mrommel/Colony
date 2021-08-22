//
//  AnimatedImageViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 31.05.21.
//

import SwiftUI

class AnimatedImageViewModel: ObservableObject {

    // animation
    private var images: [NSImage]
    private var interval: Double
    private var loop: Bool
    private var loopIndex: Int
    private var iterations: Int

    // internal
    private var imageIndex: Int
    private var iteration: Int = 1
    private var idle: Bool = false

    @Published
    var image: Image

    init(image stillImage: NSImage) {

        self.images = []
        self.interval = 1.0
        self.loop = false
        self.loopIndex = 0
        self.iterations = 0

        self.imageIndex = 0

        self.image = Image(nsImage: stillImage)
    }

    init(_ images: [NSImage],
         stillImage: NSImage? = nil,
         interval: Double,
         loop: Bool = false,
         loopIndex: Int = 0,
         iterations: Int = Int.max) {

        self.images = images
        self.interval = interval
        self.loop = loop
        self.loopIndex = loopIndex
        self.iterations = iterations

        self.imageIndex = loopIndex

        if let template = stillImage {
            self.image = Image(nsImage: template)
        } else if !images.isEmpty {
            self.image = Image(nsImage: images[0])
        } else {
            self.image = Image(systemName: "sun.max.fill")
        }
    }

    func playAnimation(images: [NSImage],
                       interval: Double,
                       loop: Bool = false,
                       loopIndex: Int = 0,
                       iterations: Int = Int.max) {

        self.images = images
        self.interval = interval
        self.loop = loop
        self.loopIndex = loopIndex
        self.iterations = iterations

        self.imageIndex = loopIndex

        self.startAnimation()
    }

    func show(image stillImage: NSImage) {

        self.images = []
        self.interval = 1.0
        self.loop = false
        self.loopIndex = 0
        self.iterations = 0

        self.imageIndex = 0

        self.image = Image(nsImage: stillImage)
    }

    func startAnimation() {

        if !self.images.isEmpty {
            Timer.scheduledTimer(withTimeInterval: self.interval, repeats: true, block: animate(_:))
        }
    }

    /// Create a video sensation
    ///
    /// Use this method to iterate through the images to look like a video
    private func animate(_ timer: Timer) {

        if self.imageIndex < self.images.count {

            self.image = Image(nsImage: self.images[imageIndex])
            self.imageIndex += 1

            if self.imageIndex == self.images.count && self.loop && self.iteration != self.iterations {
                self.imageIndex = self.loopIndex

                if self.iterations != Int.max {
                    self.iteration += 1
                }

                if !idle {
                    idle = true
                }
            }
        }

        if !self.loop && idle && self.iteration == self.iterations {
            timer.invalidate()
        }
    }
}
