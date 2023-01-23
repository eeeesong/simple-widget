//
//  SimpleWidget.swift
//  SimpleWidget
//
//  Created by song-lee on 2023/01/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let imageName: String
    let city: String
    let date: Date
    let temperature: Int
    let tours: [(date: Date, name: String)]
    let configuration: ConfigurationIntent
    
    init(configuration: ConfigurationIntent) {
        imageName = "aus"
        city = "브리즈번"
        date = Calendar.current.date(byAdding: .day, value: 24, to: Date()) ?? Date()
        temperature = 25
        tours = [(date: SimpleEntry.randomDate(), name: "코알라 보호구역 투어"),
                 (date: SimpleEntry.randomDate(), name: "열대우림 가이드 투어"),
                 (date: SimpleEntry.randomDate(), name: "모래섬 액티비티 캠핑")]
        self.configuration = configuration
    }
    
    static func randomDate() -> Date {
        return Calendar.current.date(byAdding: .day, value: Int.random(in: 24...40), to: Date()) ?? Date()
    }
}

struct SimpleWidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            ZStack {
                Image(entry.imageName)
                    .resizable()
                    .scaledToFill()
                Color(red: 0, green: 0, blue: 0, opacity: 0.2)
                VStack(alignment: .leading) {
                    Text("\(entry.city) 여행까지")
                        .bold()
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Text(dDay(from: entry.date) + " ✈️")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                    Spacer()
                    Text("현재 \(entry.city) 기온 \(entry.temperature)°C")
                        .bold()
                        .font(.footnote)
                        .foregroundColor(.white)
                }
                .padding(30)
            }
        case .systemMedium:
            ZStack {
                Image(entry.imageName)
                    .resizable()
                    .scaledToFill()
                Color(red: 0, green: 0, blue: 0, opacity: 0.2)
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(entry.city) 여행까지")
                            .bold()
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Text(dDay(from: entry.date) + " ✈️")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .bold()
                            .padding([.bottom])
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        Text("현재 \(entry.city) 기온 \(entry.temperature)°C")
                            .bold()
                            .font(.footnote)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                    VStack(alignment: .leading) {
                        ForEach(entry.tours.sorted(by: { item1, item2 in
                            item1.date < item2.date
                        }), id: \.self.name) { item in
                            ZStack {
                                Color(.darkGray)
                                    .cornerRadius(30)
                                HStack(alignment: .center) {
                                    Color(.green)
                                        .cornerRadius(4)
                                        .frame(width: 8, height: 8)
                                    Text(dDay(from: item.date))
                                        .bold()
                                        .foregroundColor(.white)
                                        .font(.caption2)
                                    Text(item.name)
                                        .foregroundColor(.white)
                                        .font(.caption2)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                }
                            }
                            .frame(height: 32)
                        }
                    }
                }
                .padding(20)
            }
        @unknown default:
            VStack {
                
            }
        }
    }
    
    private func dDay(from date: Date) -> String {
        let day = Calendar.current.dateComponents([.day], from: date, to: Date()).day
        guard let day else {
            return "D-??"
        }
        return "D\(day - 1)"
    }
}

struct SimpleWidget: Widget {
    let kind: String = "SimpleWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SimpleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("나의 여행 위젯")
        .description("당신이 브리즈번으로 떠난다면 이런 위젯!")
        .supportedFamilies([.systemSmall,.systemMedium])
    }
}

struct SimpleWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SimpleWidgetEntryView(entry: SimpleEntry(configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            SimpleWidgetEntryView(entry: SimpleEntry(configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
        
    }
}
