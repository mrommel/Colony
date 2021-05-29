//
//  MountainView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.05.21.
//

import SwiftUI

struct MountainView: View {
    
    static let baseColor = Color(red: 35.0 / 255, green: 33.0 / 255, blue: 24.0 / 255)

    var body: some View {
        GeometryReader { geometry in
            
            let width: CGFloat = min(geometry.size.width, geometry.size.height)
            let height: CGFloat = width * 0.75
            let spacing: CGFloat = 0.0 // width * 0.030
            let middle: CGFloat = width * 0.5
            let topWidth: CGFloat = width * 0.226
            let topHeight: CGFloat = height * 0.488
            
            ZStack {
                Path { path in

                    path.addLines([
                        CGPoint(x: middle, y: spacing),
                        CGPoint(x: middle - topWidth, y: topHeight - spacing),
                        CGPoint(x: middle, y: topHeight / 2 + spacing),
                        CGPoint(x: middle + topWidth, y: topHeight - spacing),
                        CGPoint(x: middle, y: spacing)
                    ])
                }
                .fill(Color.white)
                
                Path { path in
                    
                    path.move(to: CGPoint(x: middle, y: topHeight / 2 + spacing * 3))
                    path.addLines([
                        CGPoint(x: middle - topWidth, y: topHeight + spacing),
                        CGPoint(x: spacing, y: height - spacing),
                        CGPoint(x: width - spacing, y: height - spacing),
                        CGPoint(x: middle + topWidth, y: topHeight + spacing),
                        CGPoint(x: middle, y: topHeight / 2 + spacing * 3)
                    ])
                }
                .fill(Self.baseColor)
            }
        }
    }
}

struct MountainView_Previews: PreviewProvider {
    
    static var previews: some View {
        MountainView()
    }
}
