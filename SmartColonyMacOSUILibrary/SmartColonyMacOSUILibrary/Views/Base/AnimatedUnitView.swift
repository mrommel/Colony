//
//  AnimatedUnitView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI

class AnimatedUnitViewModel: ObservableObject {
    
    private let images: [NSImage]
    private let interval: Double
    private let loop: Bool
    private let loopIndex: Int
    private let iterations: Int
    
    private var imageIndex: Int
    private var iteration: Int = 1
    private var idle: Bool = false
    
    @Published
    var image: Image = Image(systemName: "sun.max.fill")
    
    init(_ images: [NSImage],
         templateImage: NSImage? = nil,
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
        
        if let template = templateImage {
            self.image = Image(nsImage: template)
        }
    }
    
    func startAnimation() {
        
        Timer.scheduledTimer(withTimeInterval: self.interval, repeats: true, block: animate(_:))
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

@available (iOS 13.0, OSX 10.15, *)
struct AnimatedUnitView: View {
    
    @ObservedObject
    var viewModel: AnimatedUnitViewModel
    
    @State
    private var started: Bool = false
    
    /// Create a AnimatedImage
    /// - Parameters:
    ///     - imagesNames: An Array of images  that will be shown.
    ///     - templateImageName: first image. If not provided, the default value will be used.
    ///     - interval: Time that each image will still shown.
    ///     - loop: Boolean that determines if the video will play on loop. If not provided, the default value false will be used.
    ///     - loopIndex: Where the video restarts when on loop. If not provided, the default value 0 will be used.
    ///     - iterations: If the video loops, how many times it will loop. For infinite loop just not use this parameter. If not provided, the default value infinite will be used.
    public init(_ images: [NSImage],
                templateImage: NSImage? = nil,
                interval: Double,
                loop: Bool = false,
                loopIndex: Int = 0,
                iterations: Int = Int.max) {
        
        self.viewModel = AnimatedUnitViewModel(images, templateImage: templateImage, interval: interval, loop: loop, loopIndex: loopIndex, iterations: iterations)
    }
    
    public var body: some View {
        Group {
            self.viewModel.image
                .resizable()
                .scaledToFit()
        }.onAppear(perform: {
            self.startAnimation()
        })
    }
    
    private func startAnimation() {
        
        self.viewModel.startAnimation()
        self.started = true
    }
}
