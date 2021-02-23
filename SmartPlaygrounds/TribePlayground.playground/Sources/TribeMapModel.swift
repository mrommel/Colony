import Foundation
import SmartAILibrary

public class TribeMapModel: MapModel {
    
    let tribeArray: TribeArray2D
    
    public override init(size: MapSize) {
        
        self.tribeArray = TribeArray2D(size: size)
            
        super.init(size: size)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
