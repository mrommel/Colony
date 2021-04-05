//
//  TrackableScrollView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI

fileprivate struct TrackableScrollViewOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGPoint

    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}

public struct TrackableScrollView<Content: View>: View {
    
    let axes: Axis.Set
    let showsIndicators: Bool

    let content: Content
    
    @Binding
    private var cursor: CGPoint
    
    @Binding
    private var contentScale: CGFloat
    
    @State
    private var lastScaleValue: CGFloat = 1.0
    
    @Binding
    private var contentOffset: CGPoint
    
    public init(axes: Axis.Set = .vertical,
         showsIndicators: Bool = true,
         cursor: Binding<CGPoint> = .constant(.zero),
         scale: Binding<CGFloat> = .constant(1.0),
         contentOffset: Binding<CGPoint> = .constant(.zero),
         @ViewBuilder content: () -> Content ) {
        
        self.axes = axes
        self.showsIndicators = showsIndicators
        self._cursor = cursor
        self._contentScale = scale
        self._contentOffset = contentOffset
        
        self.content = content()
    }
    
    public var body: some View {
        
        let magnifyGesture = MagnificationGesture(minimumScaleDelta: 0.1)
            .onChanged { value in
                let delta = value.magnitude / self.lastScaleValue
                self.lastScaleValue = value.magnitude
                
                let tmpScale = self.contentScale * delta
                //let tmpScale: CGFloat = 1.0
                
                print("magnitude: \(tmpScale)")
                
                self.contentScale = tmpScale
                self.$contentScale.wrappedValue = tmpScale
            }
            .onEnded { val in
                // without this the next gesture will be broken
                self.lastScaleValue = 1.0
            }
        
        let dragGesture = DragGesture(minimumDistance: 0)
            .onChanged { value in
                //self.cursor = CGPoint(x: value.location.x, y: value.location.y)
                let cx = (value.location.x - self.$contentOffset.wrappedValue.x) / self.$contentScale.wrappedValue
                let cy = (value.location.y - self.$contentOffset.wrappedValue.y) / self.$contentScale.wrappedValue
                let tmpCursor = CGPoint(x: cx, y: cy)
                
                self.cursor = tmpCursor
                self.$cursor.wrappedValue = tmpCursor
                
                print("cursor: \(self.cursor)")
            }.onEnded { value in
                //value.
            }
        
        SwiftUI.ScrollView(axes, showsIndicators: showsIndicators) {
        
            VStack(spacing: 0) {
                GeometryReader { reader in
                    Color.clear.preference(
                        key: TrackableScrollViewOffsetPreferenceKey.self,
                        value: reader.frame(in: .named("scrollView")).origin
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: 1)

                self.content
            }
            .onPreferenceChange(TrackableScrollViewOffsetPreferenceKey.self) { value in
                DispatchQueue.main.async {
                    self.contentOffset = value
                }
            }
            .scaleEffect(self.contentScale)
        }
        .gesture(dragGesture)
        .gesture(magnifyGesture)
        .coordinateSpace(name: "scrollView")
    }
}
