//
//  MapMarkerPickerView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 29.04.22.
//

import SwiftUI
import SmartAssets

struct MapMarkerPickerView: View {

    private var gridItemLayout = [
        GridItem(.fixed(24)), GridItem(.fixed(24)),
        GridItem(.fixed(24)), GridItem(.fixed(24)),
        GridItem(.fixed(24)), GridItem(.fixed(24))
    ]

    private let cornerRadius: CGFloat = 5

    @ObservedObject
    var viewModel: MapMarkerPickerViewModel

    init(viewModel: MapMarkerPickerViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .center, spacing: 4) {

            Text("Add Marker".localized())

            TextField("name ...", text: self.$viewModel.name)

            Text("Districts".localized())

            LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 2) {

                ForEach(Array(self.viewModel.districtMarkerViewModels.enumerated()), id: \.element) { index, markerViewModel in

                    Image(nsImage: markerViewModel.image())
                        .resizable()
                        .frame(width: 24, height: 24)
                        .border(Color(self.viewModel.selectionColor(of: markerViewModel.type)), width: 1, cornerRadius: 4)
                        .onTapGesture {
                            self.viewModel.selectedType = markerViewModel.type
                        }
                        .zIndex(Double(400 - index))
                        .tooltip(markerViewModel.toolTip())
                }
            }

            Text("Wonders".localized())

            LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 2) {

                ForEach(Array(self.viewModel.wonderMarkerViewModels.enumerated()), id: \.element) { index, markerViewModel in

                    Image(nsImage: markerViewModel.image())
                        .resizable()
                        .frame(width: 24, height: 24)
                        .border(Color(self.viewModel.selectionColor(of: markerViewModel.type)), width: 1, cornerRadius: 4)
                        .onTapGesture {
                            self.viewModel.selectedType = markerViewModel.type
                        }
                        .zIndex(Double(200 - index))
                        .tooltip(markerViewModel.toolTip())
                }
            }

            HStack(alignment: .center, spacing: 4) {

                Button(
                    action: { self.viewModel.cancelClicked() },
                    label: { Text("Cancel".localized()) }
                )
                    .buttonStyle(DialogButtonStyle(width: 90))

                Button(
                    action: { self.viewModel.okayClicked() },
                    label: { Text("Ok".localized()) }
                )
                .buttonStyle(DialogButtonStyle(state: .highlighted, width: 90))
            }
        }
            .frame(width: 190)
            .padding(.all, 4)
            .background(
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .strokeBorder(Color.white, lineWidth: 1)
                    .background(Color(Globals.Colors.dialogBackground))
            )
    }
}

/*struct MapMarkerPickerView_Previews: PreviewProvider {

    static var previews: some View {
        MapMarkerPickerView()
    }
}*/
