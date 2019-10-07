//
//  Leader.swift
//  Colony
//
//  Created by Michael Rommel on 29.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

struct Leaders {
    
    static let alexander: Leader = Leader(name: "Alexander", civilization: .greek)
    static let elizabeth: Leader = Leader(name: "Elizabeth", civilization: .english)
    static let jaques: Leader = Leader(name: "Jaques", civilization: .french)
    static let juan: Leader = Leader(name: "Juan", civilization: .spanish)
    
    static func leader(for civilization: Civilization) -> Leader {
        
        switch civilization {
            
        case .english:
            return elizabeth
        case .french:
            return jaques
        case .spanish:
            return juan
        case .greek:
            return alexander
            
        default:
            fatalError("no leader")
        }
    }
}

class Leader: Codable {
    
    let name: String
    let civilization: Civilization
    
    init(name: String, civilization: Civilization) {
        
        self.name = name
        self.civilization = civilization
    }
}

extension Leader: Equatable {
    
    static func == (lhs: Leader, rhs: Leader) -> Bool {
        
        return lhs.name == rhs.name && lhs.civilization == rhs.civilization
    }
}

extension Leader: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.civilization)
    }
}
