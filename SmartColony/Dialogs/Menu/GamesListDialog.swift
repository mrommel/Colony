//
//  GamesListDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 02.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

class GamesListDialogViewModel {

    let storedGames: [String]

    init() {

        self.storedGames = GameStorage.listGames()
    }
}

class GamesListDialog: Dialog {

    // MARK: properties

    let viewModel: GamesListDialogViewModel

    // MARK: nodes

    var scrollNode: ScrollNode?
    var gameNodes: [MessageBoxButtonNode?] = []

    fileprivate var resultHandler: ((_ gameName: String) -> Void)?

    // MARK: constructors

    init(with viewModel: GamesListDialogViewModel) {

        self.viewModel = viewModel

        let uiParser = UIParser()
        guard let gamesListDialogConfiguration = uiParser.parse(from: "GamesListDialog") else {
            fatalError("cant load GamesListDialog configuration")
        }

        super.init(from: gamesListDialogConfiguration)

        // scroll area
        self.scrollNode = ScrollNode(size: CGSize(width: 250, height: 300), contentSize: CGSize(width: 250, height: 350))
        self.scrollNode?.position = CGPoint(x: 0, y: -20)
        self.scrollNode?.zPosition = 199
        self.addChild(self.scrollNode!)

        for gameEntry in self.viewModel.storedGames {

            let gameLabelNode = GameLoadButtonNode(gameNamed: gameEntry,
                                                   buttonAction: { gameName in
                                                       // print("clicked: \(gameName)")

                                                       self.resultHandler?(gameName)
                                                   })
            gameLabelNode.zPosition = self.zPosition + 2

            self.scrollNode?.addScrolling(child: gameLabelNode)

            gameNodes.append(gameLabelNode)
        }

        self.calculateContentSize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addGameLoadingHandler(handler: @escaping (_ gameName: String) -> Void) {

        self.resultHandler = handler
    }

    private func calculateContentSize() {

        var calculatedHeight: CGFloat = 0.0

        for gameNode in gameNodes {

            gameNode?.position = CGPoint(x: 0, y: calculatedHeight)

            calculatedHeight += 50
        }

        self.scrollNode?.contentSize.height = calculatedHeight
    }
}
