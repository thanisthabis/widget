//
//  CoralWidgetFlutter.swift
//  CoralWidgetFlutter
//
//  Created by Thanistha Bisalputra on 8/8/23.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), remainingDays: Int())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), remainingDays: Int())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date() //now
        let calendar = Calendar.current
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let remainingDays = calendar.dateComponents([.day], from: currentDate, to: entryDate).day ?? 0
            let entry = SimpleEntry(date: entryDate, configuration: configuration, remainingDays: remainingDays)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let remainingDays: Int
}

struct CountdownOverlay: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple, .clear]), startPoint: .leading, endPoint: .trailing)
            VStack(alignment: .leading) {
                Text("\(entry.remainingDays)")
                    .foregroundColor(.white)
                    .font(.system(size: 35))
                    .fontWeight(.heavy)
                    .frame(width: 100, height: 30, alignment: .topLeading)
                    .padding(.top, 20)
                Text("days left")
                    .frame(width: 100, height: 20, alignment: .topLeading)
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                Text("Blue Whale")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                    .frame(width: 100, height: 75, alignment: .bottomLeading)
                    .padding(.top, -25)
                HStack{
                    Text("Fish Collection")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .frame(width: 80, height: 25, alignment: .top)
                        .padding(.top, -10)
                    Text("11.08.23")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .frame(width: 50, height: 25, alignment: .top)
                        .padding(.top, -10)
                }
            }
        }
    }
}

struct CountdownMediumOverlay: View {
    var entry: Provider.Entry
    let countdown: Date?
    
    var body: some View {
        ZStack(alignment: .leading) {
            LinearGradient(gradient: Gradient(colors: [.blue, .clear]), startPoint: .leading, endPoint: .trailing)
            VStack(alignment: .leading) {
                    Text(countdown!, style: .timer)
                        .foregroundColor(.white)
                        .font(.system(size: 35))
                        .fontWeight(.heavy)
                        .frame(width: 150, height: 30, alignment: .topLeading)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                HStack{
                    Text("minute")
                        .frame(width: 35, height: 20, alignment: .topLeading)
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    Text("second")
                        .frame(width: 50, height: 20, alignment: .topLeading)
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                }
                Text("SpongeBob")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                    .frame(width: 100, height: 75, alignment: .bottomLeading)
                    .padding(.top, -25)
                    .padding(.leading, 20)
                HStack{
                    Text("Pacific Ocean Collection")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .frame(width: 200, height: 25, alignment: .topLeading)
                        .padding(.top, -10)
                        .padding(.leading, 20)
                    Text("11.08.23")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .frame(width: 50, height: 25, alignment: .topTrailing)
                        .padding(.top, -10)
                        .padding(.leading, 20)
                }
            }
        }
    }
}

struct CoralWidgetFlutterEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            Image("coral_small")
                .resizable()
                .foregroundColor(.blue)
                .animation(.linear(duration: 2.0).repeatForever(autoreverses: false))
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200, alignment: .center)
                .overlay(CountdownOverlay(entry: entry), alignment: .center)
            
        case .systemMedium:
            Image("coral_medium")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 350, height: 350, alignment: .center)
                .overlay(CountdownMediumOverlay(entry: entry, countdown: Date()), alignment: .center)
        case .systemLarge:
            Image("coral_large")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 1000, height: 1000, alignment: .center)
        default:
            Text("Some other WidgetFamily in the future.")
        }
    }
}

struct CoralWidgetFlutter: Widget {
    let kind: String = "CoralWidgetFlutter"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CoralWidgetFlutterEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview("Small", as: .systemSmall) {
    CoralWidgetFlutter()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, remainingDays: 7)
    SimpleEntry(date: .now, configuration: .starEyes, remainingDays: 7)
}

#Preview("Medium", as: .systemMedium) {
    CoralWidgetFlutter()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, remainingDays: 7)
    SimpleEntry(date: .now, configuration: .starEyes, remainingDays: 0)
}

#Preview("Large", as: .systemLarge) {
    CoralWidgetFlutter()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, remainingDays: 7)
    SimpleEntry(date: .now, configuration: .starEyes, remainingDays: 7)
}
