//
//  Textures.swift
//  SmartAssets
//
//  Created by Michael Rommel on 28.11.20.
//

import SmartAILibrary

public class Textures {

    let gameModel: GameModel?

    public init(game gameModel: GameModel?) {

        self.gameModel = gameModel
    }

    public func terrainTexture(at point: HexPoint) -> String {

        guard let gameModel = self.gameModel else {
            fatalError("cant get game")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        var textureName = ""
        if let coastTexture = self.coastTexture(at: point) {
            textureName = coastTexture
        } else {
            if tile.hasHills() {
                textureName = tile.terrain().textureNamesHills().item(from: point)
            } else {
                textureName = tile.terrain().textureNames().item(from: point)
            }
        }

        return textureName
    }

    public func coastTexture(at point: HexPoint) -> String? {

        guard let game = self.gameModel else {
            fatalError("cant get game")
        }

        if let tile = game.tile(at: point) {
            if tile.terrain().isLand() {
                return nil
            }
        }

        var texture = "beach" // "beach-n-ne-se-s-sw-nw"
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)

            if let neighborTile = game.tile(at: neighbor) {

                if neighborTile.terrain().isLand() {
                    texture += ("-" + direction.short())
                }
            }
        }

        if texture == "beach" {
            return nil
        }

        return texture
    }

    public func snowTexture(at point: HexPoint) -> String? {

        guard let game = self.gameModel else {
            fatalError("cant get game")
        }

        var texture = "snow" // "snow-n-ne-se-s-sw-nw"

        if let tile = game.tile(at: point) {
            if tile.terrain().isWater() {
                texture = "snow-to-water"
            }
        }

        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)

            if let neighborTile = game.tile(at: neighbor) {

                if neighborTile.terrain() == .snow {
                    texture += ("-" + direction.short())
                }
            }
        }

        if texture == "snow" || texture == "snow-to-water" {
            return nil
        }

        return texture
    }

    public func mountainsTexture(at point: HexPoint) -> String? {

        guard let game = self.gameModel else {
            fatalError("cant get game")
        }

        var texture = "feature-mountains" // "mountains-n-ne-se-s-sw-nw"

        for direction in [HexDirection.north, HexDirection.northeast, HexDirection.northwest] {
            let neighbor = point.neighbor(in: direction)

            if let neighborTile = game.tile(at: neighbor) {

                if neighborTile.has(feature: .mountains) {
                    texture += ("-" + direction.short())
                }
            }
        }

        if texture == "feature-mountains" {
            return nil
        }

        // limit to only some existing textures
        if texture != "feature-mountains-n-ne" &&
            texture != "feature-mountains-n" &&
            texture != "feature-mountains-ne" &&
            texture != "feature-mountains-n-nw" &&
            texture != "feature-mountains-nw" &&
            texture != "feature-mountains-n-ne-nw" {

            return nil
        }

        return texture
    }

    public func iceTexture(at point: HexPoint) -> String? {

        guard let game = self.gameModel else {
            fatalError("cant get game")
        }

        var texture = "feature_ice" // "snow-n-ne-se-s-sw-nw"

        if let tile = game.tile(at: point) {
            if tile.terrain().isWater() {
                texture = "feature_ice-to-water"
            }
        }

        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)

            if let neighborTile = game.tile(at: neighbor) {

                if neighborTile.has(feature: .ice) {
                    texture += ("-" + direction.short())
                }
            }
        }

        if texture == "feature_ice" || texture == "feature_ice-to-water" {
            return nil
        }

        return texture
    }

    public func featureTexture(for tile: AbstractTile) -> String? {

        let feature: FeatureType = tile.feature()

        if feature == .none {
            return nil
        }

        let textureName: String
        if tile.terrain() == .tundra && feature == .forest {
            textureName = ["feature-pine1", "feature-pine2"].item(from: tile.point)
        } else {
            textureName = feature.textureNames().item(from: tile.point)
        }

        return textureName
    }

    public func featureTextureIsUpper(for tile: AbstractTile) -> Bool {

        let feature: FeatureType = tile.feature()

        if feature == .forest || feature == .rainforest {
            return true
        }

        return false
    }

    public func riverTexture(at point: HexPoint) -> String? {

        guard let game = self.gameModel else {
            fatalError("cant get game")
        }

        guard let tile = game.tile(at: point) else {
            return nil
        }

        if !tile.isRiver() {

            // river deltas can be at ocean only
            if tile.terrain() == .shore || tile.terrain() == .ocean {

                let southwestNeightbor = point.neighbor(in: .southwest)
                if let southwestTile = game.tile(at: southwestNeightbor) {

                    // 1. river end west
                    if southwestTile.isRiverInNorth() {
                        return "river-mouth-w"
                    }

                    // 2. river end south west
                    if southwestTile.isRiverInSouthEast() {
                        return "river-mouth-sw"
                    }
                }

                let northwestNeightbor = point.neighbor(in: .northwest)
                if let northwestTile = game.tile(at: northwestNeightbor) {

                    // 3
                    if northwestTile.isRiverInNorthEast() {
                        return "river-mouth-nw"
                    }
                }

                let northNeightbor = point.neighbor(in: .north)
                if let northTile = game.tile(at: northNeightbor) {

                    // 4
                    if northTile.isRiverInSouthEast() {
                        return "river-mouth-ne"
                    }
                }

                let southeastNeightbor = point.neighbor(in: .southeast)
                if let southeastTile = game.tile(at: southeastNeightbor) {

                    // 5
                    if southeastTile.isRiverInNorth() {
                        return "river-mouth-e"
                    }
                }

                let southNeightbor = point.neighbor(in: .south)
                if let southTile = game.tile(at: southNeightbor) {

                    // 6
                    if southTile.isRiverInNorthEast() {
                        return "river-mouth-se"
                    }
                }
            }

            return nil
        }

        var texture = "river" // "river-n-ne-se-s-sw-nw"
        for flow in FlowDirection.all {

            if tile.isRiverIn(flow: flow) {
                texture += ("-" + flow.short)
            }
        }

        if texture == "river" {
            return nil
        }

        return texture
    }

    public func borderMainTexture(at point: HexPoint, in area: HexArea) -> String? {

        guard let gameModel = self.gameModel else {
            fatalError("cant get game")
        }

        var textureName = "border-main"

        if !area.contains(where: { $0 == gameModel.wrap(point: point.neighbor(in: .north)) }) {
            textureName += "-n"
        }

        if !area.contains(where: { $0 == gameModel.wrap(point: point.neighbor(in: .northeast)) }) {
            textureName += "-ne"
        }

        if !area.contains(where: { $0 == gameModel.wrap(point: point.neighbor(in: .southeast)) }) {
            textureName += "-se"
        }

        if !area.contains(where: { $0 == gameModel.wrap(point: point.neighbor(in: .south)) }) {
            textureName += "-s"
        }

        if !area.contains(where: { $0 == gameModel.wrap(point: point.neighbor(in: .southwest)) }) {
            textureName += "-sw"
        }

        if !area.contains(where: { $0 == gameModel.wrap(point: point.neighbor(in: .northwest)) }) {
            textureName += "-nw"
        }

        if textureName == "border-main" {
            return "border-main-all"
        }

        return textureName
    }

    public func borderAccentTexture(at point: HexPoint, in area: HexArea) -> String? {

        guard let gameModel = self.gameModel else {
            fatalError("cant get game")
        }

        var textureName = "border-accent"

        if !area.contains(where: { $0 == gameModel.wrap(point: point.neighbor(in: .north)) }) {
            textureName += "-n"
        }

        if !area.contains(where: { $0 == gameModel.wrap(point: point.neighbor(in: .northeast)) }) {
            textureName += "-ne"
        }

        if !area.contains(where: { $0 == gameModel.wrap(point: point.neighbor(in: .southeast)) }) {
            textureName += "-se"
        }

        if !area.contains(where: { $0 == gameModel.wrap(point: point.neighbor(in: .south)) }) {
            textureName += "-s"
        }

        if !area.contains(where: { $0 == gameModel.wrap(point: point.neighbor(in: .southwest)) }) {
            textureName += "-sw"
        }

        if !area.contains(where: { $0 == gameModel.wrap(point: point.neighbor(in: .northwest)) }) {
            textureName += "-nw"
        }

        if textureName == "border-accent" {
            return "border-accent-all"
        }

        return textureName
    }

    public func foodTexture(for yields: Yields) -> String? {

        let food = Int(yields.food)

        if food == 0 {
            return nil
        }

        return "yield-food-\(food)"
    }

    public func productionTexture(for yields: Yields) -> String? {

        let production = Int(yields.production)

        if production == 0 {
            return nil
        }

        return "yield-production-\(production)"
    }

    public func goldTexture(for yields: Yields) -> String? {

        let gold = Int(yields.gold)

        if gold == 0 {
            return nil
        }

        return "yield-gold-\(gold)"
    }

    public func calderaTexure(at hex: HexPoint) -> String? {

        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }

        let calderaIsSouth = hex.y == gameModel.mapSize().height() - 1
        let calderaIsEast = gameModel.wrappedX() ? false : hex.x == gameModel.mapSize().width() - 1

        if calderaIsSouth || calderaIsEast {
            if calderaIsSouth && calderaIsEast {
                return "board-se-s-sw"
            }

            if calderaIsSouth {
                return "board-s-sw"
            }

            if hex.y % 2 == 1 {
                return "board-se"
            }

            return "board-se-s"
        }

        if !gameModel.wrappedX() && hex.x == 0 && hex.y % 2 == 1 {
            return "board-sw"
        }

        return nil
    }

    public func roadTexture(at point: HexPoint) -> String? {

        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }

        if let tile = gameModel.tile(at: point) {
            if tile.route() == .none {
                return nil
            }
        }

        var texture = "road" // "road-n-ne-se-s-sw-nw"
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)

            if let neighborTile = gameModel.tile(at: neighbor) {

                if neighborTile.route() != .none {
                    texture += ("-" + direction.short())
                }
            }
        }

        if texture == "road" {
            return nil
        }

        return texture
    }
}
