//
//  HillsView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.05.21.
//

import SwiftUI

struct HillsView: View {
    
    static let baseColor = Color(red: 35.0 / 255, green: 33.0 / 255, blue: 24.0 / 255)

    var body: some View {
        GeometryReader { geometry in
            
            let width: CGFloat = min(geometry.size.width, geometry.size.height)
            let height: CGFloat = width * 0.75
            let middle: CGFloat = width * 0.5
            
            Path { path in
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: width * 0.1, y: height))
                path.addCurve(to: CGPoint(x: middle, y: height * 0.9),
                              control1: CGPoint(x: width * 0.2, y: height),
                              control2: CGPoint(x: width * 0.35, y: height * 0.9))
                path.addCurve(to: CGPoint(x: width * 0.9, y: height),
                              control1: CGPoint(x: width * 0.65, y: height * 0.9),
                              control2: CGPoint(x: width * 0.8, y: height))
                path.addLine(to: CGPoint(x: width, y: height))
                
                path.move(to: CGPoint(x: 0, y: height))
                path.addCurve(to: CGPoint(x: width * 0.33, y: height * 0.8),
                              control1: CGPoint(x: width * 0.1, y: height),
                              control2: CGPoint(x: width * 0.15, y: height * 0.8))
                path.addCurve(to: CGPoint(x: middle, y: height * 0.9),
                              control1: CGPoint(x: width * 0.4, y: height * 0.8),
                              control2: CGPoint(x: width * 0.4, y: height * 0.85))
                
                path.move(to: CGPoint(x: width * 0.42, y: height * 0.85))
                path.addCurve(to: CGPoint(x: width * 0.66, y: height * 0.75),
                              control1: CGPoint(x: width * 0.6, y: height * 0.8),
                              control2: CGPoint(x: width * 0.5, y: height * 0.8))
                path.addCurve(to: CGPoint(x: width, y: height),
                              control1: CGPoint(x: width * 0.85, y: height * 0.75),
                              control2: CGPoint(x: width * 0.9, y: height * 0.95))
            }
            .stroke(lineWidth: 2)
            //.fill(Color.red)
        }
    }
}

struct HillsView_Previews: PreviewProvider {
    
    static var previews: some View {
        HillsView()
            .frame(width: 100, height: 100, alignment: .center)
    }
}
