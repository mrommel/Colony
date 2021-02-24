import Foundation

public class TribeArray2D: Codable {
    
    enum CodingKeys: CodingKey {
        
        case width
        case height
        case array
    }
    
    public let width: Int
    public let height: Int
    fileprivate var array: [TribeTileInfo?] = [TribeTileInfo?]()

    init(size: MapSize) {
        
        self.width = size.width()
        self.height = size.height()
        self.array = [TribeTileInfo?](repeating: nil, count: self.height * self.width)
    }
    
    public init(width: Int, height: Int) {
        
        self.width = width
        self.height = height
        self.array = [TribeTileInfo?](repeating: nil, count: height * width)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.array = try container.decode([TribeTileInfo?].self, forKey: .array)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.width, forKey: .width)
        try container.encode(self.height, forKey: .height)
        
        let wrappedTiles: [TribeTileInfo?] = self.array.map { $0 as? TribeTileInfo }
        try container.encode(wrappedTiles, forKey: .array)
    }
    
    // MARK methods

    public subscript(column: Int, row: Int) -> TribeTileInfo? {
        get {
            precondition(column < self.width, "Column \(column) Index is out of range. Array<T>(columns: \(self.width), rows:\(self.height))")
            precondition(row < self.height, "Row \(row) Index is out of range. Array<T>(columns: \(self.width), rows:\(self.height))")
            return array[row * self.width + column]
        }
        set {
            precondition(column < self.width, "Column \(column) Index is out of range. Array<T>(columns: \(self.width), rows:\(self.height))")
            precondition(row < self.height, "Row \(row) Index is out of range. Array<T>(columns: \(self.width), rows:\(self.height))")
            array[row * self.width + column] = newValue
        }
    }
}

// MARK: fill methods

extension TribeArray2D {

    func fill(with value: TribeTileInfo) {
        
        for x in 0..<self.width {
            for y in 0..<self.height {
                self[x, y] = value
            }
        }
    }

    func fill(with function: (Int, Int) -> TribeTileInfo) {
        
        for x in 0..<self.width {
            for y in 0..<self.height {
                self[x, y] = function(x, y)
            }
        }
    }

    func filter(where condition: @escaping (TribeTileInfo?) -> Bool) -> [TribeTileInfo?] {
        
        return self.array.filter(condition)
    }

    func count(where condition: @escaping (TribeTileInfo?) -> Bool) -> Int {
        
        return self.array.count(where: condition)
    }
}
