//
//  ContentView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 21.03.21.
//

import SwiftUI
import CoreData
import SmartColonyMacOSUILibrary

struct ContentView: View {
    
    var viewModel: MapScrollContentViewModel = MapScrollContentViewModel()

    var body: some View {
        HStack {
            Label("Brush", systemImage: "paintbrush.fill")
            
            MapScrollContentView(viewModel: viewModel).frame(width: 1000, height: 500, alignment: .center)
        }
        .toolbar {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }

    private func addItem() {

    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
