//
//  Civ5MapReader.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 02.08.19.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import BinarySwift

class Civ5MapReader {

    init() {
    }

    func load(from url: URL?) -> Civ5Map? {
        
        if let civ5MapUrl = url {
            
            do {
                let binaryData = try Data(contentsOf: civ5MapUrl, options: .mappedIfSafe)
                
                return self.load(from: binaryData)
            } catch {
                print("Error reading \(error)")
            }
        }
        
        return nil
    }
    
    private func load(from data: Data) -> Civ5Map? {

        let binaryData = BinaryData(data: data, bigEndian: false)
        let reader = BinaryDataReader(binaryData)

        do {
            let header = try Civ5MapHeader(reader: reader)
            //print("success: type=\(header.type)")
            
            let plots: Array2D<Civ5MapPlot> = Array2D<Civ5MapPlot>(width: Int(header.width), height: Int(header.height))
            
            for y in 0..<Int(header.height) {
                for x in 0..<Int(header.width) {
                    
                    let ry = Int(header.height) - y - 1
                    
                    let plot = try Civ5MapPlot(reader: reader, header: header)
                    plots[x, ry] = plot
                }
            }
            
            return Civ5Map(header: header, plots: plots)
            
        } catch {
            print("error while reading Civ5Map: \(error)")
        }
        
        return nil
    }
}
