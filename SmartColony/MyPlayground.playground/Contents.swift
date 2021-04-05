import AppKit
import SwiftUI

// Delete this line if not using a playground
import PlaygroundSupport

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        let value1 = nextValue()
        print("OffsetPreferenceKey.reduce: \(value1)")
        value = CGPoint(x: value.x + value1.x, y: value.y + value1.y)
    }
}

struct MapView: View {
    
    let colors: [Color] = [.red, .green, .blue, .yellow, .orange, .pink, .purple]
    
    var body: some View {
        
        VStack {
            GeometryReader { reader in
                Color.clear.preference(
                    key: OffsetPreferenceKey.self,
                    value: reader.frame(in: .global).origin)
            }
            
            HStack {
                Rectangle()
                    .fill(self.colors[0])
                    .frame(width: 400, height: 400)
                
                Rectangle()
                    .fill(self.colors[1])
                    .frame(width: 400, height: 400)
            }
            
            HStack {
                Rectangle()
                    .fill(self.colors[2])
                    .frame(width: 400, height: 400)
                
                Rectangle()
                    .fill(self.colors[3])
                    .frame(width: 400, height: 400)
            }
        }
    }
}

struct ContentView: View {
    
    @Binding
    private var cursor: CGPoint
    
    @State
    private var scale: CGFloat = 1.0
    
    @State
    private var lastScaleValue: CGFloat = 1.0
    
    init(cursor: Binding<CGPoint> = .constant(.zero)) {
        
        self._cursor = cursor
    }
    
    var body: some View {
        
        let magnifyGesture = MagnificationGesture(minimumScaleDelta: 0.0)
            .onChanged { value in
                let delta = value.magnitude / self.lastScaleValue
                self.lastScaleValue = value.magnitude
                
                let tmpScale = self.scale * delta
                //let tmpScale: CGFloat = 1.0
                
                print("magnitude: \(tmpScale)")
                
                self.scale = tmpScale
                self.$scale.wrappedValue = tmpScale
            }
            .onEnded { val in
                // without this the next gesture will be broken
                self.lastScaleValue = 1.0
            }
        
        let dragGesture = DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.cursor = CGPoint(x: value.location.x, y: value.location.y)
                print("location: \(value.location)")
            }.onEnded { value in
                //value.
            }

        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            
            MapView()
                .scaleEffect(self.scale)
                .gesture(dragGesture)
                .offset(x: self._cursor.wrappedValue.x, y: self._cursor.wrappedValue.y)
                .gesture(magnifyGesture)
        }
        .coordinateSpace(name: "ScrollView")
        .frame(width: 500, height: 500)
        .background(Color.red.opacity(0.5))
    }
}

// Present the view in Playground
// Delete this line if not using a playground
PlaygroundPage.current.liveView = NSHostingController(rootView: ContentView())
