import Foundation

public enum TribeType: String, Codable {
    
    case none
    
    case mongols
    case saxons
    case frisian
    case dane
    case frank
    case alamann
    case celtican
    case goth
    case breton
    case corsican
    case occitan
    case tatar
    case etruscan
    case basc
    case norse
    
    static var all: [TribeType] = [
        .mongols, .saxons, .frisian, .dane, .frank, .alamann, .celtican, .goth, .breton, .corsican, .occitan, .tatar, .etruscan, .basc, .norse
    ]
}

public class TribeItem: Codable {
    
    let type: TribeType
    var ratio: Float
    
    init(type: TribeType) {
        
        self.type = type
        self.ratio = 1.0
    }
}

public class TribeTileInfo: Codable {
    
    enum CodingKeys: CodingKey {
        
        case items
        case inhabitants
    }
    
    let maxTribes = 10
    var items: [TribeItem] = []
    var inhabitants: Int = 0
    var foodBasket: Int = 0
    
    public init() {
        
        //self.items.append(TribeItem(type: .none))
    }
    
    public init(type: TribeType) {
        
        self.items.append(TribeItem(type: type))
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.items = try container.decode([TribeItem].self, forKey: .items)
        self.inhabitants = try container.decode(Int.self, forKey: .inhabitants)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.items, forKey: .items)
        try container.encode(self.inhabitants, forKey: .inhabitants)
    }
    
    func population(of type: TribeType) -> Int {
        
        if let item = self.items.first(where: { $0.type == type }) {
            return Int(item.ratio * Float(self.inhabitants))
        }
        
        return 0
    }
    
    func update() {
        
        var sum: Float = 0.0
        
        for item in self.items {
            sum += item.ratio
        }
        
        if self.inhabitants == 0 {
            self.items.removeAll()
            return
        }
        
        if sum == 0 {
            self.items.removeAll()
        } else {
            var tribesToRemove: [TribeType] = []
            
            for item in self.items {
                if item.ratio == 0.0 {
                    tribesToRemove.append(item.type)
                }
                
                item.ratio /= sum
            }
            
            self.items = self.items.filter({ !tribesToRemove.contains($0.type) })
        }
    }
}
