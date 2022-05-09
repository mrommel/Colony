//
//  MapOverviewView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

extension Image {

    func mapOverview() -> some View {
        self
            .resizable()
            .frame(width: 156, height: 94)
    }
}

public struct MapOverviewView: View {

    @ObservedObject
    var viewModel: MapOverviewViewModel

    private let cornerRadius: CGFloat = 5

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    let bundle = Bundle.init(for: Textures.self)

    public var body: some View {

        VStack {

            Group {
                self.mapMarkerPickerView

                self.mapMarkerWaitingView

                self.mapMarkersView

                self.mapOptionsView
            }

            self.legendView

            self.optionPickerView

            ZStack(alignment: .bottomTrailing) {

                Image(nsImage: self.viewModel.canvasImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 112, alignment: .bottomTrailing) // 400 × 224

                self.viewModel.image
                    .mapOverview()
                    .offset(x: -8.0, y: -2.0)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded({ (value) in
                                self.viewModel.clicked(on: value.location)
                            })
                    )

                Path { path in
                    path.move(to: self.viewModel.topLeft)
                    path.addLine(to: self.viewModel.topRight)
                    path.addLine(to: self.viewModel.bottomRight)
                    path.addLine(to: self.viewModel.bottomLeft)
                    path.addLine(to: self.viewModel.topLeft)
                }
                .stroke(Color.white, lineWidth: 1)
                .offset(x: -8.0, y: -2.0)

                self.optionsView
            }
            .frame(width: 200, height: 120)
            .onReceive(gameEnvironment.visibleRect) { rect in
                print("visible rect changed: \(rect)")
            }
            .onReceive(gameEnvironment.game) { game in
                print(" - game changed - ")
                if game != nil {
                    self.viewModel.assign(game: game)
                }
            }
        }
    }

    var optionsView: some View {

        HStack {

            Image(nsImage: self.viewModel.mapMarkerImage())
                .resizable()
                .scaledToFit()
                .frame(width: 29.9, height: 25.35)
                .onTapGesture {
                    self.viewModel.mapMarkerClicked()
                }

            Image(nsImage: self.viewModel.mapOptionImage())
                .resizable()
                .scaledToFit()
                .frame(width: 29.9, height: 25.35)
                .onTapGesture {
                    self.viewModel.mapOptionClicked()
                }

            Image(nsImage: self.viewModel.mapLensImage())
                .resizable()
                .scaledToFit()
                .frame(width: 29.9, height: 25.35)
                .onTapGesture {
                    self.viewModel.mapLensClicked()
                }
        }
        .offset(x: -8.0, y: -93.0)
    }

    var optionPickerView: some View {

        if self.viewModel.showMapLens {
            return AnyView(
                VStack(alignment: .center, spacing: 4) {
                    Text("Lenses")

                    ScrollView(.vertical, showsIndicators: true, content: {
                        Picker("", selection: self.$viewModel.selectedMapLens, content: {
                            ForEach(MapLensType.all) { mapLens in
                                Text(mapLens.title())
                                    .tag(mapLens)
                                    .frame(width: 130, alignment: .leading)
                                    .padding(.leading, 4)
                            }
                        })
                            .pickerStyle(RadioGroupPickerStyle())

                    })
                        .frame(width: 150, height: 150)
                }
                    .padding(.all, 4)
                    .background(
                        RoundedRectangle(cornerRadius: self.cornerRadius)
                            .strokeBorder(Color.white, lineWidth: 1)
                            .background(Color(Globals.Colors.dialogBackground))
                    )
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    var legendView: some View {

        if self.viewModel.showMapLens {
            return AnyView(
                VStack(alignment: .center, spacing: 4) {
                    Text("Legend")

                    ForEach(self.viewModel.mapLensLegendViewModel.items, id: \.self) { legendItemViewModel in

                        MapLensLegendItemView(viewModel: legendItemViewModel)
                    }
                }
                    .frame(width: 150)
                    .padding(.all, 4)
                    .background(
                        RoundedRectangle(cornerRadius: self.cornerRadius)
                            .strokeBorder(Color.white, lineWidth: 1)
                            .background(Color(Globals.Colors.dialogBackground))
                    )
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    var mapOptionsView: some View {

        if self.viewModel.showMapOptions {
            return AnyView(
                MapOptionsView(viewModel: self.viewModel.mapOptionsViewModel)
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    var mapMarkersView: some View {

        if self.viewModel.showMapMarker {
            return AnyView(
                MapMarkersView(viewModel: self.viewModel.mapMarkersViewModel)
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    var mapMarkerWaitingView: some View {

        if self.viewModel.showMapMarkerWaiting {
            return AnyView(
                MapMarkerWaitingView(viewModel: self.viewModel.mapMarkerWaitingViewModel)
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    var mapMarkerPickerView: some View {

        if self.viewModel.showMapMarkerPicker {
            return AnyView(
                MapMarkerPickerView(viewModel: self.viewModel.mapMarkerPickerViewModel)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}

#if DEBUG
struct MapOverviewView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)

        let viewModel = MapOverviewViewModel()
        MapOverviewView(viewModel: viewModel)
            .environment(\.gameEnvironment, environment)
    }
}
#endif
