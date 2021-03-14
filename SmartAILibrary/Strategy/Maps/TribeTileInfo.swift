import Foundation

public class TribeTileInfo: Codable {
    
    enum CodingKeys: CodingKey {
        
        case type
        case inhabitants
    }
    
    var type: CivilizationType? = nil
    var inhabitants: Int = 0
    // var ratio: Float = 1.0
    // var foodBasket: Int = 0
    
    public init() {

    }
    
    func setup(with type: CivilizationType) {
        
        self.type = type
        
        if self.inhabitants == 0 {
            self.inhabitants = 1000 // start with a thousand people
        }
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try container.decodeIfPresent(CivilizationType.self, forKey: .type)
        self.inhabitants = try container.decode(Int.self, forKey: .inhabitants)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.type, forKey: .type)
        try container.encode(self.inhabitants, forKey: .inhabitants)
    }
    
    func population(of type: CivilizationType) -> Int {
        
        if self.type == type {
            return self.inhabitants
        }
        
        return 0
    }
    
    func update() {
        
        if self.inhabitants == 0 {
            self.type = nil
            return
        }
    }
}