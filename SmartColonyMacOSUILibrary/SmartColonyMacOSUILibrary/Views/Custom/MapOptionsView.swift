//
//  MapOptionsView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 08.05.22.
//

import SwiftUI
import SmartAssets

struct MapOptionsView: View {

    @ObservedObject
    var viewModel: MapOptionsViewModel

    private let cornerRadius: CGFloat = 5

    init(viewModel: MapOptionsViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .center, spacing: 4) {

            Text("Options".localized())

            ScrollView(.vertical, showsIndicators: true, content: {

                VStack(alignment: .leading, spacing: 4) {
                    Toggle(isOn: self.$viewModel.toggleShowGrid) {
                        Text("Show Grid")
                    }
                    .toggleStyle(CheckboxSquareToggleStyle())

                    Toggle(isOn: self.$viewModel.toggleShowResourceIcons) {
                        Text("Show Resource Icons")
                    }
                    .toggleStyle(CheckboxSquareToggleStyle())

                    Toggle(isOn: self.$viewModel.toggleShowYieldIcons) {
                        Text("Show Yield Icons")
                    }
                    .toggleStyle(CheckboxSquareToggleStyle())
                    
                    #if DEBUG
                    Divider()

                    Toggle(isOn: self.$viewModel.toggleShowHexCoords) {
                        Text("Show Hex Coords")
                    }
                    .toggleStyle(CheckboxSquareToggleStyle())

                    Toggle(isOn: self.$viewModel.toggleShowCompleteMap) {
                        Text("Show Complete Map")
                    }
                    .toggleStyle(CheckboxSquareToggleStyle())
                    #endif
                }

            })
                .frame(width: 150, height: 150)
        }
            .frame(width: 150)
            .padding(.all, 4)
            .background(
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .strokeBorder(Color.white, lineWidth: 1)
                    .background(Color(Globals.Colors.dialogBackground))
            )
    }
}

/*
struct MapOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        MapOptionsView()
    }
}
*/
