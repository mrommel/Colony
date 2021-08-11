//
//  AnimatedImageView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI

@available (iOS 13.0, OSX 10.15, *)
struct AnimatedImageView: View {
    
    @ObservedObject
    var viewModel: AnimatedImageViewModel
    
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
                stillImage: NSImage? = nil,
                interval: Double,
                loop: Bool = false,
                loopIndex: Int = 0,
                iterations: Int = Int.max) {
        
        self.viewModel = AnimatedImageViewModel(images, stillImage: stillImage, interval: interval, loop: loop, loopIndex: loopIndex, iterations: iterations)
    }
    
    public init(viewModel: AnimatedImageViewModel) {
        
        self.viewModel = viewModel
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
