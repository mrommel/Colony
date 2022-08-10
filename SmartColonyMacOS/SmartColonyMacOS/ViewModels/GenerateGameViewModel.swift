//
//  GenerateGameViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 23.03.21.
//

import Cocoa
import SmartAILibrary
import SmartAssets

protocol GenerateGameViewModelDelegate: AnyObject {

    func created(game: GameModel?)
}

class GenerateGameViewModel: ObservableObject {

    @Published
    var progressValue: CGFloat

    @Published
    var progressText: String

    weak var delegate: GenerateGameViewModelDelegate?

    init(initialProgress: CGFloat = 0.0, initialText: String = "") {

        self.progressValue = initialProgress
        self.progressText = initialText
    }

    func start(with leader: LeaderType, on handicap: HandicapType, with mapType: MapType, and mapSize: MapSize, with seed: Int) {

        switch mapType {

        case .continents:
            self.generatingContinents(with: mapSize, with: leader, on: handicap, with: seed)

        case .archipelago:
            self.generatingArchipelago(with: mapSize, with: leader, on: handicap, with: seed)

        default:
            self.generatingEmpty(with: mapSize, with: leader, on: handicap, with: seed)
        }
    }

    func generatingContinents(with mapSize: MapSize, with leader: LeaderType, on handicap: HandicapType, with seed: Int) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {

            self.progressValue = 0.0
            self.progressText = "Start"

            DispatchQueue.global(qos: .background).async {

                // generate map
                let mapOptions = MapOptions(withSize: mapSize, type: .continents, leader: leader, handicap: handicap, seed: seed)

                let generator = MapGenerator(with: mapOptions)
                generator.progressHandler = { progress, text in
                    DispatchQueue.main.async {
                        self.progressValue = CGFloat(progress)
                        self.progressText = text.localized()
                    }
                }

                let map = generator.generate()

                self.generateGame(map: map, with: leader, on: handicap)
            }
        })
    }

    func generatingArchipelago(with mapSize: MapSize, with leader: LeaderType, on handicap: HandicapType, with seed: Int) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {

            self.progressValue = 0.0
            self.progressText = "Start"

            DispatchQueue.global(qos: .background).async {

                // generate map
                let mapOptions = MapOptions(withSize: mapSize, type: .archipelago, leader: leader, handicap: handicap, seed: seed)

                let generator = MapGenerator(with: mapOptions)
                generator.progressHandler = { progress, text in
                    DispatchQueue.main.async {
                        self.progressValue = CGFloat(progress)
                        self.progressText = text.localized()
                    }
                }

                let map = generator.generate()

                self.generateGame(map: map, with: leader, on: handicap)
            }
        })
    }

    func generatingEmpty(with mapSize: MapSize, with leader: LeaderType, on handicap: HandicapType, with seed: Int) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {

            self.progressValue = 0.0
            self.progressText = "Start"

            DispatchQueue.global(qos: .background).async {

                self.progressValue = 1.0
                self.progressText = "End"

                let map = MapModel(width: mapSize.width(), height: mapSize.height(), seed: seed)

                self.generateGame(map: map, with: leader, on: handicap)
            }
        })
    }

    func generateGame(map: MapModel?, with leader: LeaderType, on handicap: HandicapType) {

        let gameGenerator = GameGenerator()
        let game = gameGenerator.generate(map: map, with: leader, on: handicap)

        // cheat
        // MapUtils.discover(mapModel: &map, by: playerBarbar, in: self.game)

        DispatchQueue.main.async {

            self.progressValue = 1.0
            self.progressText = "Ready"

            self.delegate?.created(game: game)
        }
    }
}
