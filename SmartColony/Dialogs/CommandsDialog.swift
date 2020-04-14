//
//  CommandsDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 12.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit
import SmartAILibrary

extension CommandType {
    
    func dialogResult() -> DialogResultType {
        
        switch self {
            
        case .found: return .commandFound
        case .buildFarm: return .commandBuildFarm
        case .buildMine: return .commandBuildMine
        case .buildRoute: return .commandBuildRoute
        case .pillage: return .commandPillage
        case .fortify: return .commandFortify
        case .hold: return .commandHold
        case .garrison: return .commandGarrison
        }
    }
}

class CommandsDialog: Dialog {
    
    init(for commands: [Command]) {
        
        let uiParser = UIParser()
        guard var commandsDialogConfiguration = uiParser.parse(from: "CommandsDialog") else {
            fatalError("cant load commandsDialogConfiguration configuration")
        }
        
        var y: CGFloat = 0.0
        for command in commands {
            commandsDialogConfiguration.items.item.append(DialogItemConfiguration(identifier: UUID.init().uuidString, type: .button, title: command.title(), fontSize: 18.0, result: command.type.dialogResult(), offsetx: 20, offsety: y + 10.0, anchorx: 0.5, anchory: 0.5, width: 100, height: 20, image: nil, selectedIndex: nil, items: nil))
            y += 25
        }
        
        commandsDialogConfiguration.items.item.append(DialogItemConfiguration(identifier: UUID.init().uuidString, type: .button, title: "Cancel", fontSize: 18.0, result: .cancel, offsetx: 20, offsety: y + 10, anchorx: 0.5, anchory: 0.5, width: 100, height: 20, image: nil, selectedIndex: nil, items: nil))
        
        super.init(from: commandsDialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
