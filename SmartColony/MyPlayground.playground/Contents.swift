import AppKit
import SwiftUI

// Delete this line if not using a playground
import PlaygroundSupport

import Combine

struct SnapPointPreferenceData {
    let frame: Anchor<CGRect>
}

struct SnapPointPreferenceKey: PreferenceKey {
    typealias Value = SnapPointPreferenceData?

    static var defaultValue: SnapPointPreferenceData?

    static func reduce(value: inout SnapPointPreferenceData?, nextValue: () -> SnapPointPreferenceData?) {
        value = value ?? nextValue()
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

struct ScrollEndTarget<ID>: Hashable where ID: Hashable {
    let id: ID?
    let offset: CGPoint
}

/// This view attempts to detect end of scrolling and make it possible (with more code) to move the nearest item to
/// the chosen snap point.
///
/// As a result, it includes workarounds using a simultaneous drag onChanged and a publisher to "detect" end of scrolling
/// to then call `scrollTo`. See the first revision of this gist for the version demonstrating the goals but without the workaround.
struct ScrollViewSnap: View {
    @State var scrollEndTarget = ScrollEndTarget<String>(id: nil, offset: .zero)
    @State var debugColor: Color = .yellow

    let items: [String]
    let targetOffsetSubject: PassthroughSubject<ScrollEndTarget<String>, Never>
    let debouncedTargetOffsetPublisher: AnyPublisher<ScrollEndTarget<String>, Never>

    init(items: [String]) {
        // We use this just to fake detection of "scrollViewWillEndDragging" and this is flawed
        // because it lags behind the user expectation, and also can trigger while they are dragging.
        // We can probably get more fancy here but there's always the problem that they stop dragging without
        // releasing and without an `onEnded` event happening we can't do anything about that
        targetOffsetSubject = PassthroughSubject<ScrollEndTarget<String>, Never>()
        debouncedTargetOffsetPublisher = targetOffsetSubject.debounce(for: 1, scheduler: DispatchQueue.main).eraseToAnyPublisher()
        self.items = items
    }

    var body: some View {
        ZStack {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack {
                        ForEach(items, id: \.self) { item in
                            VStack(alignment: .leading) {
                                Text(item)
                                .multilineTextAlignment(.leading)
                                .font(.largeTitle)
                                .padding(25)

                                Divider()
                                .background(Color.black)
                            }
                            .background(Color(white: 0.9))
                            .onTapGesture {
                                withAnimation {
                                    scrollProxy.scrollTo(item, anchor: UnitPoint(x: 0.5, y: 0.5) )
                                }
                            }
                            // Add this to detect when the user ends the scrolling.
                            // onChanged fires but onEnded does not on this simultaneous gesture - is this a bug?
                            .simultaneousGesture(DragGesture().onChanged({ value in
                                print("change: \(item)")
                                // Show that the interactive scroll is in progress
                                self.debugColor = .yellow

                                let scrollEndTarget = ScrollEndTarget(id: item, offset: value.predictedEndLocation)
                                targetOffsetSubject.send(scrollEndTarget)
                                // This is the part where we would need real calculations based on the anchor and the cell
                                // geometry. We'd need to:
                                //
                                // 1. capture all child view geometry
                                // 2. use `value.predictedEndLocation` to work out which child we think is nearest the line
                                // 3. scroll to a specific Y offset OR tell it to scroll so that "ID" has
                                // a given anchor (e.g. top) aligned to a specific Y offset.
                                //
                                // This kind of thing doesn't seem to be possible yet:
                                // scrollProxy.scrollTo(item, anchor: ...something indicating where in the scrollview coordinate system the view should be....)
                            }))
                        }
                    }
                }
                .onReceive(self.debouncedTargetOffsetPublisher) { scrollEndTarget in
                    print("scrollTo: \(scrollEndTarget.id!)")
                    withAnimation {
                        // Updated this, seems we need to unwrap the optional id here or scrollTo fails to match ID :(
                        // Not sure if that is an API bug?
                        //
                        // This will scroll the desired item (in this case the one they started scrolling -
                        // ultimately we would use a lookup to find which item is at predictedEndLocation and use that)
                        // but it will only scroll it to the top, bottom or center of the scroll view (or some
                        // variation thereof). What we would like is to say "scroll item <ID> to be at offset Y"
                        scrollProxy.scrollTo(scrollEndTarget.id!, anchor: UnitPoint(x: 0.5, y: 0.5) )
                    }
                    // Show that the scroll has been performed
                    self.debugColor = .green
                }
            }

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Text("WE WANT TO SNAP TO HERE")
                    .foregroundColor(Color.white)
                    .font(Font.body.smallCaps())

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.8))
                .anchorPreference(
                    key: SnapPointPreferenceKey.self,
                    value: .bounds,
                    transform: { SnapPointPreferenceData(frame: $0) }
                )
                .offset(y: -230)

                Spacer()
            }

        }
        .overlayPreferenceValue(SnapPointPreferenceKey.self) { value in
            GeometryReader { proxy in
                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        Text("We want scroll end to snap the nearest item to y = \(value == nil ? 0 : proxy[value!.frame].minY, specifier: "%.0f")")

                        Spacer()
                    }
                    .padding()
                    .background(self.debugColor)
                    .frame(maxWidth: .infinity)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ScrollViewSnap_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewSnap(items: [
            "WWDC20 is here",
            "SwiftUI improvements are great",
            "Yet we can't snap a ScrollView",
            "And this is a really horrible issue",
            "With no workaround we can find",
            "And we can't make our app use just SwiftUI",
            "If this remains the case.",
            "Take pity on us?",
            "It is my birthday on Friday",
            "Please? 🎉"
        ])
    }
}

// Present the view in Playground
// Delete this line if not using a playground
// PlaygroundPage.current.liveView = NSHostingController(rootView: ContentView())
