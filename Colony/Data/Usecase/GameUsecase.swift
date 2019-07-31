//
//  GameUsecase.swift
//  Colony
//
//  Created by Michael Rommel on 04.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class GameUsecase {

    let scoreRepository: ScoreRepository
    let userRepository: UserRepository
    let gameRepository: GameRepository

    init() {
        self.scoreRepository = ScoreRepository()
        self.userRepository = UserRepository()
        self.gameRepository = GameRepository()
    }

    func set(score: Int32, levelScore: LevelScore, for level: Int32) {

        guard let user = self.userRepository.getCurrentUser() else {
            fatalError("can't find current user")
        }

        let scoreEntry = self.scoreRepository.getScoreFor(level: level, and: user)

        if scoreEntry != nil {
            scoreEntry?.score = score
            scoreEntry?.levelScore = levelScore.rawValue
            self.scoreRepository.save(score: scoreEntry)
        } else {
            self.scoreRepository.create(with: level, score: score, levelScore: levelScore, user: user)
        }
    }

    func levelScore(for level: Int32) -> LevelScore? {

        guard let user = self.userRepository.getCurrentUser() else {
            //fatalError("can't find current user")
            return .none
        }

        let scoreEntry = self.scoreRepository.getScoreFor(level: level, and: user)

        if let levelScore = scoreEntry?.levelScore {
            return LevelScore(rawValue: levelScore)
        }

        return nil
    }

    func backup(game: Game?) {

        guard let user = self.userRepository.getCurrentUser() else {
            fatalError("can't find current user")
        }

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let gamePayload: Data = try encoder.encode(game)
            self.gameRepository.create(with: gamePayload, user: user)
        } catch {
            fatalError("Can't store game temporarily")
        }
    }

    func restoreGame() -> Game? {

        guard let user = self.userRepository.getCurrentUser() else {
            //fatalError("can't find current user")
            return nil
        }

        if let gameEntity = self.gameRepository.getOnlyBackup(for: user) {

            do {
                guard let jsonData = gameEntity.data else {
                    fatalError("Can't get data - wierd")
                }
                
                return try JSONDecoder().decode(Game.self, from: jsonData)
            } catch {
                print("Error reading \(error)")
            }
        }

        // there is no game stored
        return nil
    }

    func deleteBackup() {

        guard let user = self.userRepository.getCurrentUser() else {
            fatalError("can't find current user")
        }

        self.gameRepository.deleteBackup(for: user)
    }
}
