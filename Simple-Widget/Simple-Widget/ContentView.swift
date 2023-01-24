//
//  ContentView.swift
//  Simple-Widget
//
//  Created by song-lee on 2023/01/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var travelData = TravelData.shared
    @State var isAnimating = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack(alignment: .leading) {
                Text("\(travelData.travel.city) 여행")
                    .font(.largeTitle)
                    .bold()
                    .padding([.top, .bottom], 10)
                HStack {
                    ZStack {
                        Color.gray
                            .frame(width: 120, height: 50)
                            .cornerRadius(25)
                        Text(travelData.travel.startAt.convertToString())
                            .font(.body)
                            .bold()
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("✈️")
                        .offset(x: isAnimating ? 40 : -40)
                        .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
                        .onAppear {
                            isAnimating = true
                        }
                    Spacer()
                    ZStack {
                        Color.gray
                            .frame(width: 120, height: 50)
                            .cornerRadius(25)
                        Text(travelData.travel.endAt.convertToString())
                            .font(.body)
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                }.padding([.bottom], 10)
                ZStack {
                    Image(travelData.travel.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150, alignment: .center)
                        .clipped()
                        .cornerRadius(30)
                    Text(travelData.travel.startAt.dDayString())
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading) {
                    ForEach(travelData.tours.sorted(by: { item1, item2 in
                        item1.date < item2.date
                    }), id: \.self.name) { item in
                        ZStack(alignment: .leading) {
                            Color.mint
                                .cornerRadius(30)
                            HStack(alignment: .center) {
                                Text(item.date.dDayString())
                                    .bold()
                                    .padding([.leading], 30)
                                Spacer()
                                Text(item.name)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.6)
                                    .padding([.trailing], 30)
                            }
                        }
                        .frame(height: 100)
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
