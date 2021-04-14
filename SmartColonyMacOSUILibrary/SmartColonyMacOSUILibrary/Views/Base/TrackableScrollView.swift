//
//  TrackableScrollView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI
import SmartAILibrary

fileprivate struct TrackableScrollViewOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGPoint

    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}

extension CGPoint: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

struct Anchor: Hashable {
    
    var name: String
    var point: CGPoint
    
    static func == (lhs: Anchor, rhs: Anchor) -> Bool {
        return lhs.point == rhs.point
    }
}

struct AnchorGenerator {
    
    static func anchors(rangex: Range<Int>, rangey: Range<Int>) -> [Anchor] {
        
        var r: [Anchor] = []
        
        for x in rangex {
            for y in rangey {
                r.append(Anchor(name: "\(x),\(y)", point: HexPoint.toScreen(hex: HexPoint(x: x, y: y))))
            }
        }
        
        return r
    }
}

public struct TrackableScrollView<Content: View>: View {
    
    let axes: Axis.Set
    let showsIndicators: Bool
    
    let content: Content
    
    @Binding
    private var clickPosition: CGPoint
    
    @Binding
    private var contentScale: CGFloat
    
    @State
    private var lastScaleValue: CGFloat = 1.0
    
    @Binding
    private var contentOffset: CGPoint

    @Binding
    private var scrollTarget: Int?
    
    var anchors: [Anchor] = AnchorGenerator.anchors(rangex: 0..<20, rangey: 0..<20)
    
    public init(axes: Axis.Set = .vertical,
                showsIndicators: Bool = true,
                clickPosition: Binding<CGPoint> = .constant(.zero),
                scale: Binding<CGFloat> = .constant(1.0),
                scrollTarget: Binding<Int?> = .constant(nil),
                contentOffset: Binding<CGPoint> = .constant(.zero),
                @ViewBuilder content: () -> Content ) {
        
        self.axes = axes
        self.showsIndicators = showsIndicators
        self._clickPosition = clickPosition
        self._contentScale = scale
        self._contentOffset = contentOffset
        self._scrollTarget = scrollTarget
        
        self.content = content()
    }
    
    public var body: some View {
        
        let magnifyGesture = MagnificationGesture(minimumScaleDelta: 0.1)
            .onChanged { value in
                let delta = value.magnitude / self.lastScaleValue
                self.lastScaleValue = value.magnitude
                
                let tmpScale = self.contentScale * delta
                //let tmpScale: CGFloat = 1.0
                
                // print("magnitude: \(tmpScale)")
                
                self.contentScale = tmpScale
                self.$contentScale.wrappedValue = tmpScale
            }
            .onEnded { val in
                // without this the next gesture will be broken
                self.lastScaleValue = 1.0
            }
        
        let dragGesture = DragGesture(minimumDistance: 0)
            .onChanged { value in
                let cx = (value.location.x - self.$contentOffset.wrappedValue.x) / self.$contentScale.wrappedValue
                let cy = (value.location.y - self.$contentOffset.wrappedValue.y) / self.$contentScale.wrappedValue
                let tmpCursor = CGPoint(x: cx, y: cy)
                
                self.clickPosition = tmpCursor
                self.$clickPosition.wrappedValue = tmpCursor
            }.onEnded { value in
                //value.
            }
        
        ScrollView(axes, showsIndicators: showsIndicators) {
                
            ScrollViewReader { reader in
                
                ZStack(alignment: .top) {
                    GeometryReader { reader in
                        Color.clear.preference(
                            key: TrackableScrollViewOffsetPreferenceKey.self,
                            value: reader.frame(in: .named("scrollView")).origin
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    
                    self.content
                    
                    ForEach(anchors, id: \.self, content: { anchor in
                        Text(anchor.name)
                            .font(.caption)
                            .offset(x: CGFloat(anchor.point.x), y: CGFloat(anchor.point.y))
                            .id(anchor.point.x + 1000 * anchor.point.y)
                    })
                }
                .onPreferenceChange(TrackableScrollViewOffsetPreferenceKey.self) { value in
                    DispatchQueue.main.async {
                        self.contentOffset = value
                    }
                }
                .scaleEffect(self.contentScale)
                .onChange(of: self.scrollTarget) { target in
                    if let target = target {
                        
                        self.scrollTarget = nil
                        
                        print("focus changed to: \(target)")
                        withAnimation {
                            reader.scrollTo(target, anchor: .center)
                        }
                    }
                }
                
            }
            .gesture(dragGesture)
            .gesture(magnifyGesture)
            .coordinateSpace(name: "scrollView")
        }
    }
}
