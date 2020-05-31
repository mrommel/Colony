//
//  PediaViewController.swift
//  SmartColony
//
//  Created by Michael Rommel on 14.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import UIKit
import SpriteKit
import SmartAILibrary

class PediaViewController: UIViewController {

    var pediaScene: PediaScene?
    
    private var currentGame: GameModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }

        self.pediaScene = PediaScene(size: view.frame.size)
        self.pediaScene?.pediaDelegate = self
        self.pediaScene?.scaleMode = .resizeFill

        view.presentScene(self.pediaScene)
        view.ignoresSiblingOrder = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == R.segue.pediaViewController.gotoGame.identifier {
            let gameViewController = segue.destination as? GameViewController

            if self.currentGame != nil {
                gameViewController?.viewModel = GameViewModel(with: self.currentGame)
            }
        }
    }
}

extension PediaViewController: PediaDelegate {

    func exit() {
        self.navigationController?.popViewController(animated: true)
    }

    func start(game: GameModel?) {

        self.currentGame = game
        self.performSegue(withIdentifier: R.segue.pediaViewController.gotoGame.identifier, sender: nil)
    }
}
