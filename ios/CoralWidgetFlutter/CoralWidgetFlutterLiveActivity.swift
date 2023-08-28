//
//  CoralWidgetFlutterLiveActivity.swift
//  CoralWidgetFlutter
//
//  Created by Thanistha Bisalputra on 8/8/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CoralWidgetFlutterAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var countdownTimer: ClosedRange<Date>
        var countdownText: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
    var collectorName: String
}

struct CoralWidgetFlutterLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CoralWidgetFlutterAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack{
                                        Image("coral_logo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25, height: 25, alignment: .center)
                                        VStack{
                                            Text("Hi \(context.attributes.collectorName),")
                                                .font(.headline)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("your \(context.attributes.name) \(context.state.countdownText)")
                                                .font(.headline)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        
                                    }
                                    HStack {
                                        VStack {
                                            Divider().frame(height: 6).overlay(.blue).cornerRadius(5)
                                        }
                                        Image(systemName: "sailboat.fill").foregroundColor(.blue)
                                        VStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(.secondary, style: StrokeStyle(lineWidth: 1, dash: [5]))
                                                .frame(height: 6)
                                        }
                                        Text(timerInterval: context.state.countdownTimer, countsDown: true)
                                        VStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(.secondary, style: StrokeStyle(lineWidth: 1, dash: [5]))
                                                .frame(height: 6)
                                        }
                                        Image(systemName: "house.fill").foregroundColor(.green)
                                    }
                                }.padding(.trailing, 25)
                            }.padding(5)
                            Text("Collect what you love 💙").font(.caption).foregroundColor(.secondary)
                        }.padding(15)
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Image("coral_collect")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 50, alignment: .leading)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Label {
                    Text(timerInterval: context.state.countdownTimer, countsDown: true)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 50)
                            .monospacedDigit()
                            .font(.caption2)
                    } icon: {
                        Image(systemName: "timer")
                    }
                    .font(.title2)
                }
                DynamicIslandExpandedRegion(.center) {
                    Label("View NFT", systemImage: "bag")
                        .font(.subheadline)
                        .lineLimit(1)
                        .foregroundColor(.cyan)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("your \(context.attributes.name) \(context.state.countdownText)")
                        .lineLimit(1)
                        .font(.subheadline)
                }
            } compactLeading: {
                Label {
                    Text("\(context.attributes.name)")
                } icon: {
                    Image("coral_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20, alignment: .center)
                }
                .font(.caption2)
            } compactTrailing: {
                Text(timerInterval: context.state.countdownTimer, countsDown: true)
                     .multilineTextAlignment(.center)
                     .frame(width: 40)
                     .font(.caption2)
            } minimal: {
                Image("coral_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20, alignment: .center)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.cyan)
        }
    }
}

extension CoralWidgetFlutterAttributes {
    fileprivate static var preview: CoralWidgetFlutterAttributes {
        CoralWidgetFlutterAttributes(name: "Whale", collectorName: "Amy")
    }
}

extension CoralWidgetFlutterAttributes.ContentState {
    fileprivate static var countdown: CoralWidgetFlutterAttributes.ContentState {
        CoralWidgetFlutterAttributes.ContentState(countdownTimer: Date()...Date().addingTimeInterval(60 * 60), countdownText: "is on the way")
     }
    fileprivate static var countdowntime: CoralWidgetFlutterAttributes.ContentState {
        CoralWidgetFlutterAttributes.ContentState(countdownTimer: Date()...Date().addingTimeInterval(0 * 60), countdownText: "is HERE!")
     }
}

#Preview("Notification", as: .content, using: CoralWidgetFlutterAttributes.preview) {
   CoralWidgetFlutterLiveActivity()
} contentStates: {
    CoralWidgetFlutterAttributes.ContentState.countdown
    CoralWidgetFlutterAttributes.ContentState.countdowntime
}

#Preview("Island Compact", as: .dynamicIsland(.compact), using: CoralWidgetFlutterAttributes.preview) {
    CoralWidgetFlutterLiveActivity()
} contentStates: {
    CoralWidgetFlutterAttributes.ContentState.countdown
}

#Preview("Island Expanded", as: .dynamicIsland(.expanded), using: CoralWidgetFlutterAttributes.preview) {
    CoralWidgetFlutterLiveActivity()
} contentStates: {
    CoralWidgetFlutterAttributes.ContentState.countdown
    CoralWidgetFlutterAttributes.ContentState.countdowntime
}

#Preview("Minimal", as: .dynamicIsland(.minimal), using: CoralWidgetFlutterAttributes.preview) {
    CoralWidgetFlutterLiveActivity()
} contentStates: {
    CoralWidgetFlutterAttributes.ContentState.countdown
}
