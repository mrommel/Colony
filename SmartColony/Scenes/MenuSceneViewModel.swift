//
//  MenuSceneViewModel.swift
//  SmartColony
//
//  Created by Michael Rommel on 02.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

class MenuSceneViewModel {
    
    weak var scene: BaseScene?
    
    init(scene: BaseScene?) {
        
        self.scene = scene
    }
    
    func handleLoadGameClicked() {

        let viewModel = GamesListDialogViewModel()
        
        let gamesListDialog = GamesListDialog(with: viewModel)
        gamesListDialog.zPosition = 250
        
        gamesListDialog.addGameLoadingHandler(handler: { gameName in
            
            self.scene?.rootNode.sharpWith(completion: {
                gamesListDialog.close()
            })
            
            if let menuScene = self.scene as? MenuScene {
                
                let game = GameStorage.loadGame(named: gameName)
                menuScene.menuDelegate?.resume(game: game)
            }
        })

        gamesListDialog.addCancelAction(handler: {
            
            self.scene?.rootNode.sharpWith(completion: {
                gamesListDialog.close()
            })
        })

        self.scene?.cameraNode.add(dialog: gamesListDialog)
    }
}
