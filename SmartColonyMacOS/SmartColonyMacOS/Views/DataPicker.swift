//
//  DataPicker.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 23.03.21.
//

import SwiftUI

struct DataPicker: View {
    
    let title: String
    let data: [PickerData]
    
    @Binding
    var selection: Int
    
    var body: some View {
        
        Picker(selection: $selection, label: Text(title)) {
            ForEach(0 ..< data.count) { i in
                HStack {
                    Image(nsImage: data[i].image)
                    Text(data[i].name)
                }
                .frame(minWidth: 0, maxWidth: 200)
                .padding(4)
                .tag(i)
            }
        }
        .frame(minWidth: 0, maxWidth: 350)
        .padding(4)
    }
}

struct DataPicker_Previews: PreviewProvider {

    static var previews: some View {
        let data: [PickerData] = [
            PickerData(name: "abc", image: NSImage(systemSymbolName: "arrow.right.circle.fill", accessibilityDescription: nil)!),
            PickerData(name: "def", image: NSImage(systemSymbolName: "arrow.right.circle.fill", accessibilityDescription: nil)!)]
        
        Group {
            DataPicker(title: "Title", data: data, selection: .constant(0))
            DataPicker(title: "Title", data: data, selection: .constant(0))
        }
    }
}
