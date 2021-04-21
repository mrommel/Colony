//
//  ScrollableView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.04.21.
//

import SwiftUI

struct ScrollableView<Content:View>: NSViewControllerRepresentable {
    
    typealias NSViewControllerType = NSScrollViewController<Content>
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Binding
    var scrollToPosition: CGPoint?
    
    @Binding
    var clickOnPosition: CGPoint?
    
    @Binding
    var magnification: CGFloat
    
    var hasScrollbars : Bool
    var content: () -> Content
    
    init(hasScrollbars: Bool = true,
         scrollTo: Binding<CGPoint?> = .constant(.zero),
         clickOn: Binding<CGPoint?> = .constant(.zero),
         magnification: Binding<CGFloat> = .constant(1.0),
         @ViewBuilder content: @escaping () -> Content) {
        
        // bindings
        self._scrollToPosition = scrollTo
        self._clickOnPosition = clickOn
        self._magnification = magnification
        
        self.hasScrollbars = hasScrollbars
        self.content = content
    }
    
    func makeNSViewController(context: NSViewControllerRepresentableContext<Self>) -> NSViewControllerType {
        
        let scrollViewController = NSScrollViewController(rootView: self.content())
        
        scrollViewController.scrollView.hasVerticalScroller = hasScrollbars
        scrollViewController.scrollView.hasHorizontalScroller = hasScrollbars
        
        scrollViewController.scrollView.delegate = self
        
        context.coordinator.scrollableView = scrollViewController.scrollView
        //context.coordinator.hostingView = hostingView
        
        return scrollViewController
    }
    
    func updateNSViewController(_ viewController: NSViewControllerType, context: NSViewControllerRepresentableContext<Self>) {
        
        viewController.hostingController.rootView = self.content()
        
        if let scrollPosition = self.$scrollToPosition.wrappedValue {
            viewController.scrollView.contentView.scroll(scrollPosition)
            
            DispatchQueue.main.async {
                self.$scrollToPosition.wrappedValue = nil
            }
        }
        
        if viewController.scrollView.magnification != self.magnification {
            viewController.scrollView.magnification = self.magnification
        }
        
        viewController.hostingController.view.frame.size = viewController.hostingController.view.intrinsicContentSize
    }
    
    public func makeCoordinator() -> ScrollableView.Coordinator {
        
        //Coordinator(scrollableView: self)
        return Coordinator(scrollableView: self)
    }

    final public class Coordinator: NSObject /*, GameViewDelegate*/ {
        
        private var scrollObserver: AnyObject?
        private var magnifyObserver: AnyObject?
        
        private var internScrollableView: ScrollableView?
        
        fileprivate init(scrollableView: ScrollableView?) {
            
            self.internScrollableView = scrollableView
        }
        
        fileprivate var scrollableView: NSScrollView? {
            didSet {
                if oldValue === self.scrollableView {
                    return
                }
            
                // add scoll observer
                if let observer = self.scrollObserver {
                    NotificationCenter.default.removeObserver(observer)
                }
                
                if let scrollView = self.scrollableView {
                    self.scrollObserver = NotificationCenter.default.addObserver(forName: NSScrollView.didEndLiveScrollNotification, object: scrollView, queue: nil) { (notification) in
                        
                        if let scrollView: NSScrollView = notification.object as? NSScrollView {
                            let visibleRect = scrollView.contentView.visibleRect
                            
                            print("update visibleRect: \(visibleRect)")
                            self.internScrollableView?.gameEnvironment.change(visibleRect: visibleRect)
                        }
                    }
                }
                
                // add magnify observer
                if let observer = self.magnifyObserver {
                    NotificationCenter.default.removeObserver(observer)
                }
                
                if let scrollView = self.scrollableView {
                    self.scrollObserver = NotificationCenter.default.addObserver(forName: NSScrollView.didEndLiveMagnifyNotification, object: scrollView, queue: nil) { (notification) in
                        
                        if let scrollView: NSScrollView = notification.object as? NSScrollView {
                            let visibleRect = scrollView.contentView.visibleRect
                            
                            print("update magnification: \(scrollView.magnification)")
                            self.internScrollableView?.magnification = scrollView.magnification
                            
                            print("update visibleRect: \(visibleRect)")
                            self.internScrollableView?.gameEnvironment.change(visibleRect: visibleRect)
                        }
                    }
                }
            }
        }
        
        deinit {
            if let observer = self.scrollObserver {
                NotificationCenter.default.removeObserver(observer)
            }
            if let observer = self.magnifyObserver {
                NotificationCenter.default.removeObserver(observer)
            }
        }
    }
}

extension ScrollableView: TrackedScrollViewDelegate {
    
    // this point is already in content space
    func clicked(on point: CGPoint) {
        
        //print("mouse click: \(point.x), \(point.y)")
        self.clickOnPosition = point
    }
}

class NSScrollViewController<Content: View> : NSViewController, ObservableObject {
    
    var scrollView = TrackedScrollView()
    var scrollPosition: Binding<CGPoint>? = nil
    var hostingController: NSHostingController<Content>! = nil
    
    override func loadView() {
        self.scrollView.documentView = hostingController.view
        self.scrollView.allowsMagnification = true
        
        self.view = self.scrollView
    }
    
    init(rootView: Content) {
        self.hostingController = NSHostingController<Content>(rootView: rootView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func scrollViewDidScroll(_ notification: Notification) {
        if let scrollView: NSScrollView = notification.object as? NSScrollView {
            let visibleRect = scrollView.contentView.visibleRect
            
            print("visibleRect: \(visibleRect)")
            // todo: minimap
        }
    }
    
    @objc func scrollViewDidMagnify(_ notification: Notification) {
        if let scrollView: NSScrollView = notification.object as? NSScrollView {
            let visibleRect = scrollView.contentView.visibleRect
            
            print("visibleRect: \(visibleRect)")
            // todo: minimap
        }
    }
}

protocol TrackedScrollViewDelegate {
    
    func clicked(on point: CGPoint)
}

class TrackedScrollView: NSScrollView {
    
    var delegate: TrackedScrollViewDelegate?
    
    override func awakeFromNib() {
        let area = NSTrackingArea(rect: bounds, options: [.inVisibleRect, .activeAlways, .mouseMoved], owner: self, userInfo: nil)
        self.addTrackingArea(area)
    }
    
    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
    }
    
    override func mouseDown(with event: NSEvent) {
        
        var pointInView = convert(event.locationInWindow, from: nil) / self.magnification
        
        pointInView.x += documentVisibleRect.origin.x
        pointInView.y += documentVisibleRect.origin.y
        
        self.delegate?.clicked(on: pointInView)
    }
    
    override func mouseMoved(with event: NSEvent) {
        
        /*var pointInView = convert(event.locationInWindow, from: nil)
        
        pointInView.x += documentVisibleRect.origin.x
        pointInView.y += documentVisibleRect.origin.y*/
        
        //print("visible rect: \(pointInView.x), \(pointInView.y)")
    }
}
