//
//  ViewController.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 26.11.20.
//

import Cocoa
import SmartAILibrary

open class NSLabel: NSTextField {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.isBezeled = false
        self.drawsBackground = false
        self.isEditable = false
        self.isSelectable = false
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.isBezeled = false
        self.drawsBackground = false
        self.isEditable = false
        self.isSelectable = false
    }
    
    var text: String {
        get {
            return self.stringValue
        }
        set {
            self.stringValue = newValue
        }
    }
}

class ViewController: NSViewController {
    
    @IBOutlet weak var scrollingView: NSScrollView!
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var popUpOutlet: NSPopUpButton!
    @IBOutlet weak var positionValue: NSLabel!
    @IBOutlet weak var terrainValue: NSLabel!
    @IBOutlet weak var hillValue: NSLabel!
    
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
        
        //NSLog("scaleAction title = %@", String(sender.title))
       // NSLog("scaleAction tag   = %d", Int(sender.selectedTag()))
        
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
        
        //print("moveBy(\(dx), \(dy)")
        self.scrollingView.contentView.bounds.origin = self.scrollingView.contentView.bounds.origin - CGPoint(x: dx, y: dy)
    }
    
    func focus(on tile: AbstractTile) {
        
        self.positionValue.text = "\(tile.point.x), \(tile.point.y)"
        self.terrainValue.text = tile.terrain().name()
        self.hillValue.text = tile.hasHills() ? "true" : "false"
    }
}
