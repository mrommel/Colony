//
//  ScrollableView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.04.21.
//

import SwiftUI

public struct CustomScrollView<Content: View>: NSViewRepresentable  {
    
    private let axes: Axis.Set
    private let showsIndicators: Bool
    
    @Binding
    private var scrollPosition: CGPoint
    
    @Binding
    private var magnification: CGFloat
    
    @Binding
    private var magnificationTarget: CGFloat?
    
    private let content: Content
    
    public init(axes: Axis.Set = [.vertical, .horizontal],
                showsIndicators: Bool = true,
                scrollPosition: Binding<CGPoint>,
                magnification: Binding<CGFloat> = .constant(1.0),
                magnificationTarget: Binding<CGFloat?> = .constant(nil),
                @ViewBuilder content: () -> Content) {
        
        self.axes = axes
        self.showsIndicators = showsIndicators
        
        // Bindings
        self._scrollPosition = scrollPosition
        self._magnification = magnification
        self._magnificationTarget = magnificationTarget
        
        self.content = content()
    }
    
    public func makeNSView(context: Context) -> NSScrollView {
        
        let scrollView = NSScrollView(frame: .zero)
        scrollView.drawsBackground = false
        
        scrollView.borderType = .noBorder
        scrollView.focusRingType = .none
        
        scrollView.hasVerticalScroller = self.showsIndicators
        scrollView.hasHorizontalScroller = self.showsIndicators
        //scrollView.verticalScrollElasticity = .automatic // <== remove?
        //scrollView.horizontalScrollElasticity = .automatic // <== remove?
        scrollView.usesPredominantAxisScrolling = false
        scrollView.allowsMagnification = true

        let hostingView = NSHostingView(rootView: self.content)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.documentView = hostingView

        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: scrollView.contentView.topAnchor),
            hostingView.leadingAnchor.constraint(equalTo: scrollView.contentView.leadingAnchor),
        ])
        
        if !self.axes.contains(.horizontal) {
            let constraint = hostingView.widthAnchor.constraint(equalTo: scrollView.contentView.widthAnchor)
            constraint.priority = .defaultHigh
            constraint.isActive = true
        }
        
        if !self.axes.contains(.vertical) {
            let constraint = hostingView.heightAnchor.constraint(equalTo: scrollView.contentView.heightAnchor)
            constraint.priority = .defaultHigh
            constraint.isActive = true
        }
        
        context.coordinator.scrollView = scrollView
        context.coordinator.hostingView = hostingView
        
        return scrollView
    }
    
    public func updateNSView(_ scrollView: NSScrollView, context: Context) {
        
        guard let hostingView = context.coordinator.hostingView else {
            return
        }
        
        hostingView.rootView = self.content
        
        let contentView = scrollView.contentView
        if contentView.bounds.origin != self.scrollPosition {
            contentView.scroll(to: self.scrollPosition)
            scrollView.reflectScrolledClipView(contentView)
        }
        
        if let magnificationTarget = self._magnificationTarget.wrappedValue {
            if scrollView.magnification != magnificationTarget {
                scrollView.magnification = magnificationTarget
                self.magnification = magnificationTarget
                // reset
                self.magnificationTarget = nil
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(scrollPosition: self.$scrollPosition,
                           magnification: self.$magnification)
    }
    
    public class Coordinator: NSObject {
        
        @Binding
        private var scrollPosition: CGPoint
        
        @Binding
        private var magnification: CGFloat
        
        private var scrollObserver: AnyObject?
        private var magnifyObserver: AnyObject?
        
        fileprivate var scrollView: NSScrollView? {
            didSet {
                if oldValue === self.scrollView {
                    return
                }
                
                self.connectEventListeners()
            }
        }
        
        fileprivate var hostingView: NSHostingView<Content>?

        fileprivate init(scrollPosition: Binding<CGPoint>, magnification: Binding<CGFloat>) {
            
            print("make a new coordinator")
            self._scrollPosition = scrollPosition
            self._magnification = magnification
        }
        
        deinit {
            if let observer = self.scrollObserver {
                NotificationCenter.default.removeObserver(observer)
            }
            if let observer = self.magnifyObserver {
                NotificationCenter.default.removeObserver(observer)
            }
        }
        
        fileprivate func connectEventListeners() {
            
            if let observer = self.scrollObserver {
                NotificationCenter.default.removeObserver(observer)
            }
            if let contentView = self.scrollView?.contentView {
                contentView.postsBoundsChangedNotifications = true
                self.scrollObserver = NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification, object: contentView, queue: nil) { (notification) in
                    
                    DispatchQueue.main.async {
                        let newScrollPosition = self.scrollView?.contentView.bounds.origin ?? .zero
                        if self.scrollPosition != newScrollPosition {
                            self.scrollPosition = newScrollPosition
                        }
                    }
                }
                
                self.magnifyObserver = NotificationCenter.default.addObserver(forName: NSScrollView.didEndLiveMagnifyNotification, object: self.scrollView, queue: nil) { (notification) in
                    
                    if let scrollView: NSScrollView = notification.object as? NSScrollView {
                        
                        // print("update magnification: \(scrollView.magnification)")
                        self.magnification = scrollView.magnification
                        
                        /*let visibleRect = scrollView.contentView.visibleRect
                        
                        print("update magnification: \(scrollView.magnification)")
                        self.internScrollableView?.magnification = scrollView.magnification
                        
                        //print("update visibleRect: \(visibleRect)")
                        self.internScrollableView?.gameEnvironment.change(visibleRect: visibleRect)*/
                    }
                }
            }
        }
    }
}

/*struct ScrollableView<Content:View>: NSViewControllerRepresentable {
    
    typealias NSViewControllerType = NSScrollViewController<Content>
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Binding
    var scrollToPosition: CGPoint?
    
    @Binding
    var magnification: CGFloat
    
    var hasScrollbars : Bool
    var content: () -> Content
    
    init(hasScrollbars: Bool = true,
         scrollTo: Binding<CGPoint?> = .constant(.zero),
         magnification: Binding<CGFloat> = .constant(1.0),
         @ViewBuilder content: @escaping () -> Content) {
        
        // bindings
        self._scrollToPosition = scrollTo
        self._magnification = magnification
        
        self.hasScrollbars = hasScrollbars
        self.content = content
    }
    
    func makeNSViewController(context: NSViewControllerRepresentableContext<Self>) -> NSViewControllerType {
        
        let scrollViewController = NSScrollViewController(rootView: self.content())
        
        scrollViewController.scrollView.hasVerticalScroller = hasScrollbars
        scrollViewController.scrollView.hasHorizontalScroller = hasScrollbars
        
        //scrollViewController.scrollView.delegate = self
        
        context.coordinator.scrollableView = scrollViewController.scrollView
        
        return scrollViewController
    }
    
    func updateNSViewController(_ viewController: NSViewControllerType, context: NSViewControllerRepresentableContext<Self>) {
        
        viewController.hostingController.rootView = self.content()
        
        if let scrollPosition = self.$scrollToPosition.wrappedValue {
            viewController.scrollView.contentView.scroll(scrollPosition / self.magnification)
            
            DispatchQueue.main.async {
                self.$scrollToPosition.wrappedValue = nil
            }
        }
        
        if viewController.scrollView.magnification != self.magnification {
            viewController.scrollView.magnification = self.magnification
        }
        
        if viewController.hostingController.view.frame.size != viewController.hostingController.view.intrinsicContentSize {
            viewController.hostingController.view.frame.size = viewController.hostingController.view.intrinsicContentSize
        }
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
                            
                            //print("update visibleRect: \(visibleRect)")
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
                            
                            //print("update visibleRect: \(visibleRect)")
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
}*/

/*extension ScrollableView: TrackedScrollViewDelegate {
    
    // this point is already in content space
    func clicked(on point: CGPoint) {
        
        //print("mouse click: \(point.x), \(point.y)")
        //self.clickOnPosition = point
    }
}*/

/*class NSScrollViewController<Content: View> : NSViewController, ObservableObject {
    
    var scrollView = NSScrollView() //TrackedScrollView()
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
}*/

/*protocol TrackedScrollViewDelegate {
    
    func clicked(on point: CGPoint)
}*/

/*class TrackedScrollView: NSScrollView {
    
    var delegate: TrackedScrollViewDelegate?
    
    override func awakeFromNib() {
        let area = NSTrackingArea(rect: bounds, options: [.inVisibleRect, .activeAlways, .mouseMoved], owner: self, userInfo: nil)
        self.addTrackingArea(area)
    }
}*/
