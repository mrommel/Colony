//
//  MenuViewController.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import UIKit
import SmartAILibrary
import SpriteKit

class MenuViewController: UIViewController {

    var menuScene: MenuScene?

    private var currentMap: MapModel?
    private var currentHandicap: HandicapType = .settler
    private var currentLeader: LeaderType = .none
    // -- or --
    private var currentGame: GameModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }

        self.menuScene = MenuScene(size: view.frame.size)
        self.menuScene?.menuDelegate = self
        self.menuScene?.scaleMode = .resizeFill

        view.presentScene(self.menuScene)
        view.ignoresSiblingOrder = false
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        self.menuScene?.updateLayout()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == R.segue.menuViewController.gotoGame.identifier {
            let gameViewController = segue.destination as? GameViewController

            if self.currentMap != nil {
                gameViewController?.viewModel = GameViewModel(with: self.currentMap, handicap: self.currentHandicap)
            }

            if self.currentGame != nil {
                gameViewController?.viewModel = GameViewModel(with: self.currentGame)
            }
        }

        /*if segue.identifier == R.segue.menuViewController.gotoOptions.identifier {
            // NOOP
        }
        
        if segue.identifier == R.segue.menuViewController.gotoQuests.identifier {
            // NOOP
        }
        
        if segue.identifier == R.segue.menuViewController.gotoStore.identifier {
            // NOOP
        }
        
        if segue.identifier == R.segue.menuViewController.gotoPedia.identifier {
            // NOOP
        }*/
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension MenuViewController: MenuDelegate {

    func startTutorials() {

    }

    func resume(game: GameModel?) {

        self.currentMap = nil
        self.currentHandicap = .settler
        self.currentLeader = .none
        // -- or --
        self.currentGame = game

        self.performSegue(withIdentifier: R.segue.menuViewController.gotoGame.identifier, sender: nil)
    }

    /// the scene gives us a map
    func startWith(map: MapModel?, leader: LeaderType, handicap: HandicapType) {

        self.currentMap = map // store for handover
        self.currentHandicap = handicap // store for handover
        self.currentLeader = leader // store for handover
        // -- or --
        self.currentGame = nil

        self.performSegue(withIdentifier: R.segue.menuViewController.gotoGame.identifier, sender: nil)
    }

    func startOptions() {

    }

    func startStore() {

    }

    func startPedia() {

        self.performSegue(withIdentifier: R.segue.menuViewController.gotoPedia.identifier, sender: nil)
    }
}
