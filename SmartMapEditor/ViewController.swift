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
    @IBOutlet weak var positionLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        
        //self.scrollingView.documentView = self.mapView
        self.scrollingView.setAccessibilityEnabled(true)
        self.scrollingView.hasVerticalScroller = true
        self.scrollingView.hasHorizontalScroller = true
        
        // self.autoLayout(contentView: self.mapView!)
        
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
