//
//  ViewController.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 26.11.20.
//

import Cocoa
import SmartAILibrary

class ViewController: NSViewController {
    
    @IBOutlet weak var scrollingView: NSScrollView!
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var popUpOutlet: NSPopUpButton!
    @IBOutlet weak var positionValue: NSLabel!
    @IBOutlet weak var terrainValue: NSLabel!
    @IBOutlet weak var hillValue: NSLabel!
    @IBOutlet weak var featureValue: NSLabel!
    @IBOutlet weak var resourceValue: NSLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollingView.setAccessibilityEnabled(true)
        self.scrollingView.hasVerticalScroller = true
        self.scrollingView.hasHorizontalScroller = true
        
        self.mapView.delegate = self
        
        // load map
        DispatchQueue.global(qos: .background).async {
            
            let mapOptions = MapOptions(withSize: MapSize.tiny, leader: .alexander, handicap: .settler)
            mapOptions.enhanced.sealevel = .low

            let generator = MapGenerator(with: mapOptions)
            generator.progressHandler = { progress, text in
                //mapLoadingDialog.showProgress(value: progress, text: text)
                print("map - progress: \(progress)")
            }
            
            if let map = generator.generate() {
                
                // ensure that this runs on UI thread
                DispatchQueue.main.async {
                    self.mapView.map = map
                    
                    // show okay button
                    print("map - progress: ready")
                }
            }
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func scaleAction(_ sender: AnyObject) {

        switch Int(sender.selectedTag()) {
        
        case 0:
            self.mapView.setViewSize(0.5)
            break
        case 1:
            self.mapView.setViewSize(1.0)
            break
        case 2:
            self.mapView.setViewSize(2.0)
            break
        default:
            self.mapView.setViewSize(1.0)
        }
    }
}

extension ViewController: MapViewDelegate {
    
    func moveBy(dx: CGFloat, dy: CGFloat) {

        self.scrollingView.contentView.bounds.origin = self.scrollingView.contentView.bounds.origin - CGPoint(x: dx, y: dy)
    }
    
    func focus(on tile: AbstractTile) {
        
        self.positionValue.text = "\(tile.point.x), \(tile.point.y)"
        self.terrainValue.text = tile.terrain().name()
        self.hillValue.text = tile.hasHills() ? "true" : "false"
        self.featureValue.text = tile.feature().name()
        self.resourceValue.text = tile.resource(for: nil).name()
    }
}
