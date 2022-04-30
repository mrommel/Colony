//
//  MapMarkerView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 30.04.22.
//

import SwiftUI
import SmartAssets

struct MapMarkerView: View {

    @ObservedObject
    var viewModel: MapMarkerViewModel

    private let cornerRadius: CGFloat = 5

    init(viewModel: MapMarkerViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .center, spacing: 4) {

            Text("Marker".localized())

            ForEach(self.viewModel.items, id: \.self) { mapMarkerViewModel in

                HStack(alignment: .center) {

                    Image(nsImage: mapMarkerViewModel.image())
                        .resizable()
                        .frame(width: 16, height: 16)

                    Text(mapMarkerViewModel.markerTitle)
                        .frame(width: 120)

                    // remove + edit buttons
                }
                .frame(width: 140)
                .onTapGesture {
                    self.viewModel.clicked(on: mapMarkerViewModel.markerLocation)
                }
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

/*struct MapMarkerView_Previews: PreviewProvider {
    static var previews: some View {
        MapMarkerView()
    }
}*/
