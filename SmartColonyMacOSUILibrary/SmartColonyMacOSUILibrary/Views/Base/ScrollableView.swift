//
//  ScrollableView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.04.21.
//

import SwiftUI

public struct ScrollableView<Content: View>: NSViewRepresentable  {
    
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
        scrollView.usesPredominantAxisScrolling = false
        //scrollView.allowsMagnification = true

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
        
        /*if let magnificationTarget = self._magnificationTarget.wrappedValue {
            if scrollView.magnification != magnificationTarget {
                scrollView.magnification = magnificationTarget
                self.magnification = magnificationTarget
                // reset
                self.magnificationTarget = nil
            }
        }*/
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
                        //self.magnification = scrollView.magnification
                        
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
