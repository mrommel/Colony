//
//  MapMarkerWaitingView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 30.04.22.
//

import SwiftUI
import SmartAssets

struct MapMarkerWaitingView: View {

    private let cornerRadius: CGFloat = 5

    @ObservedObject
    var viewModel: MapMarkerWaitingViewModel

    init(viewModel: MapMarkerWaitingViewModel) {

        self.viewModel = viewModel
    }
    var body: some View {

        VStack(alignment: .center, spacing: 4) {

            Text("Select Marker Location".localized())

            Button(
                action: { self.viewModel.cancelClicked() },
                label: { Text("Cancel".localized()) }
            )
            .buttonStyle(DialogButtonStyle(width: 120))
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

/*struct MapMarkerWaitingView_Previews: PreviewProvider {
    static var previews: some View {
        MapMarkerWaitingView()
    }
}
*/
