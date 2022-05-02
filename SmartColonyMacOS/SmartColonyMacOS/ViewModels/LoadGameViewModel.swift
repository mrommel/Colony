//
//  LoadGameViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 29.04.22.
//

import Foundation
import AppKit
import SmartAssets
import SmartAILibrary

class SaveGameViewModel: ObservableObject {

    @Published
    var filename: String

    @Published
    var selected: Bool

    init(filename: String) {

        self.filename = filename
        self.selected = false
    }
}

extension SaveGameViewModel: Hashable {

    static func == (lhs: SaveGameViewModel, rhs: SaveGameViewModel) -> Bool {

        return lhs.filename == rhs.filename && lhs.selected == rhs.selected
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.filename)
        hasher.combine(self.selected)
    }
}

protocol LoadGameViewModelDelegate: AnyObject {

    func load(filename: String)
    func canceled()
}

class LoadGameViewModel: ObservableObject {

    @Published
    var previewLoading: Bool = false

    @Published
    var saveGameViewModels: [SaveGameViewModel] = []

    @Published
    var gamePreviewTurn: String = "-"

    @Published
    var gamePreviewDate: String = "-"

    @Published
    var gamePreviewViewModel: GamePreviewViewModel

    @Published
    var mapSize: String = "-"

    var preloaded: Bool = false

    weak var delegate: LoadGameViewModelDelegate?

    init() {

        self.gamePreviewViewModel = GamePreviewViewModel()
    }

    func update() {

        if !self.preloaded {
            // preload asset
            self.loadAssets()

            // load filenames
            self.loadFilenames()

            self.preloaded = true
        }
    }

    private func loadAssets() {

        let bundle = Bundle.init(for: Textures.self)

        let leaderTypeTextureNames = LeaderType.all.map { $0.iconTexture() } + ["leader-random"]
        print("- load \(leaderTypeTextureNames.count) leader type textures")
        for textureName in leaderTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let civilizationTypeTextureNames =
            (CivilizationType.all + [CivilizationType.free, CivilizationType.barbarian, CivilizationType.cityState(type: .akkad)])
            .map { $0.iconTexture() }
        print("- load \(civilizationTypeTextureNames.count) civilization type textures")
        for textureName in civilizationTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let handicapTypeTextureNames = HandicapType.all.map { $0.iconTexture() }
        print("- load \(handicapTypeTextureNames.count) handicap textures")
        for textureName in handicapTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        ImageCache.shared.add(
            image: bundle.image(forResource: "speed-standard"),
            for: "speed-standard"
        )
    }

    private func loadFilenames() {

        do {
            let applicationSupport = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )

            let bundleID = "SmartColonyMacOS"
            let appSupportSubDirectory = applicationSupport.appendingPathComponent(bundleID, isDirectory: true)

            var isDirectory: ObjCBool = true
            if !FileManager.default.fileExists(atPath: appSupportSubDirectory.path, isDirectory: &isDirectory) {
                try FileManager.default.createDirectory(at: appSupportSubDirectory, withIntermediateDirectories: true, attributes: nil)
            }

            for filename in try FileManager.default.contentsOfDirectory(atPath: appSupportSubDirectory.path) {

                guard filename.hasSuffix(".clny") else {
                    continue
                }

                self.saveGameViewModels.append(SaveGameViewModel(filename: filename))
            }

        } catch {
            print("could not load file names")
        }
    }

    func select(filename: String) {

        self.previewLoading = true
        var tmpSaveGameViewModels: [SaveGameViewModel] = []

        DispatchQueue.global(qos: .background).async {

            for saveGameViewModel in self.saveGameViewModels {

                let viewModel = SaveGameViewModel(filename: saveGameViewModel.filename)
                if saveGameViewModel.filename == filename {
                    viewModel.selected = true

                    // update preview
                    self.updatePreview(for: filename)
                }

                tmpSaveGameViewModels.append(viewModel)
            }

            DispatchQueue.main.async {
                self.saveGameViewModels = tmpSaveGameViewModels
                self.previewLoading = false
            }
        }
    }

    func updatePreview(for filename: String) {

        do {
            let applicationSupport = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )

            let bundleID = "SmartColonyMacOS"
            var appSupportSubDirectory = applicationSupport.appendingPathComponent(bundleID, isDirectory: true)

            var isDirectory: ObjCBool = true
            if !FileManager.default.fileExists(atPath: appSupportSubDirectory.path, isDirectory: &isDirectory) {
                try FileManager.default.createDirectory(at: appSupportSubDirectory, withIntermediateDirectories: true, attributes: nil)
            }

            appSupportSubDirectory.appendPathComponent(filename)

            let attrs = try FileManager.default.attributesOfItem(atPath: appSupportSubDirectory.path) as NSDictionary

            let reader = GameLoader()
            guard let gameModel = reader.load(from: appSupportSubDirectory) else {
                fatalError("cant get game")
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human player")
            }

            self.gamePreviewTurn = gameModel.turnYear()
            if #available(macOS 12.0, *) {
                self.gamePreviewDate = attrs.fileCreationDate()?.ISO8601Format() ?? "-"
            }

            self.gamePreviewViewModel.civilization = humanPlayer.leader.civilization()
            self.gamePreviewViewModel.leader = humanPlayer.leader
            self.gamePreviewViewModel.handicap = gameModel.handicap

            self.mapSize = gameModel.mapSize().name().localized()
        } catch {
            print("cant load preview: \(error)")
        }
    }

    func closeDialog() {

        self.delegate?.canceled()
    }

    func closeAndSelectDialog() {

        for saveGameViewModel in self.saveGameViewModels where saveGameViewModel.selected {

            self.delegate?.load(filename: saveGameViewModel.filename)
            return
        }
    }
}
