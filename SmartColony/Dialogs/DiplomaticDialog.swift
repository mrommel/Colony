//
//  DiplomaticDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 13.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit
    
class DiplomaticDialog: Dialog {
    
    let humanPlayer: AbstractPlayer?
    let otherPlayer: AbstractPlayer?
    
    // MARK: Constructors
    
    init(for humanPlayer: AbstractPlayer?, and otherPlayer: AbstractPlayer?, data: DiplomaticData?) {
        
        self.humanPlayer = humanPlayer
        self.otherPlayer = otherPlayer
        
        let uiParser = UIParser()
        guard let diplomaticDialogConfiguration = uiParser.parse(from: "DiplomaticDialog") else {
            fatalError("cant load DiplomaticDialog configuration")
        }

        super.init(from: diplomaticDialogConfiguration)
        
        guard let otherPlayer = self.otherPlayer else {
            fatalError("cant get otherPlayer")
        }
        
        guard let humanPlayer = self.humanPlayer else {
            fatalError("cant get humanPlayer")
        }
        
        guard let data = data else {
            fatalError("cant get data")
        }
        
        // style items
        /*if let button1 = self.button(with: "reponse_positive_button") {
            button1.size = CGSize(width: 300, height: 80)
        }
        if let button2 = self.button(with: "reponse_busy_button") {
            button2.size = CGSize(width: 300, height: 80)
        }*/
        
        // fill items
        self.set(imageNamed: otherPlayer.leader.iconTexture(), identifier: "player_image")
        self.set(text: otherPlayer.leader.name(), identifier: "player_name")
        
        self.set(text: data.message, identifier: "player_message")

        self.set(text: "It is an honor to meet you.", identifier: "reponse_positive_button")
        self.set(text: "Well met stranger, but I'm afraid we are too busy to stay and chat.", identifier: "reponse_busy_button")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
