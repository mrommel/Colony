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

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    let bundle = Bundle.init(for: Textures.self)

    public var body: some View {

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
        .frame(width: 200, height: 132)
        .onReceive(gameEnvironment.visibleRect) { rect in
            print("visible rect changed: \(rect)")
        }
        .onReceive(gameEnvironment.game) { game in
            print(" - game changed - ")
            self.viewModel.assign(game: game)
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
}

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
