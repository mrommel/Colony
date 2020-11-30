//
//  ContentView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import SwiftUI
import Cocoa
import SmartAILibrary

struct ContentView: View {

    @State private var mapFocus: AbstractTile? = nil

    var body: some View {
        HStack {
            VStack {
                /*MapScrollContentView().trackingMouse { location in
                    self.point = location
                }*/
                MapScrollContentView(focus: $mapFocus)

                Text("\(String(format: "X = %.0f, Y = %.0f", self.mapFocus?.point.x ?? 0.0, self.mapFocus?.point.y ?? 0.0))")
            }

            VStack {
                HStack {
                    Text("Zoom")
                    PopUpButtonView().frame(width: 70, height: 20, alignment: .center)
                }
            }
        }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
#endif
