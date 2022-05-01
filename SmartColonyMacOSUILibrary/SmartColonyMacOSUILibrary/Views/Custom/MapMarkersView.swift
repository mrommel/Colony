//
//  MapMarkersView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 30.04.22.
//

import SwiftUI
import SmartAssets

struct MapMarkersView: View {

    @ObservedObject
    var viewModel: MapMarkersViewModel

    private let cornerRadius: CGFloat = 5

    init(viewModel: MapMarkersViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .center, spacing: 4) {

            Text("Marker".localized())

            ForEach(self.viewModel.items, id: \.self) { mapMarkerItemViewModel in

                MapMarkerItemView(viewModel: mapMarkerItemViewModel)
            }

            Button(
                action: { self.viewModel.addMarkerClicked() },
                label: { Text("Add Marker".localized()) }
            )
                .buttonStyle(DialogButtonStyle(width: 120))

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

/*struct MapMarkersView_Previews: PreviewProvider {
    static var previews: some View {
        MapMarkersView()
    }
}*/
