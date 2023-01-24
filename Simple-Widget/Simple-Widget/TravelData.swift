//
//  TravelData.swift
//  Simple-Widget
//
//  Created by song-lee on 2023/01/24.
//

import Foundation

final class TravelData: ObservableObject {
    static let shared = TravelData()
    
    @Published var travel: Travel
    @Published var tours: [Tour]
    
    init(travel: Travel, tours: [Tour]) {
        self.travel = travel
        self.tours = tours
    }
    
    init() {
        travel = Travel(city: "브리즈번",
                        imageName: "aus",
                        startAt: "20230301".convertToDate(),
                        endAt: "20230312".convertToDate())
        tours = [Tour(name: "론파인 코알라 보호구역", date: "20230304".convertToDate()),
                 Tour(name: "열대우림 가이드 투어", date: "20230307".convertToDate()),
                 Tour(name: "몰튼 아일랜드 모래섬 액티비티", date: "20230311".convertToDate())]
    }
}

struct Travel {
    let city: String
    let imageName: String
    let startAt: Date
    let endAt: Date
}

struct Tour {
    let name: String
    let date: Date
}

extension String {
    func convertToDate(format: String = "YYYYMMdd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
}

extension Date {
    func dDayString() -> String {
        let day = Calendar.current.dateComponents([.day], from: self, to: Date()).day
        guard let day else {
            return "D-??"
        }
        return "D\(day - 1)"
    }
    
    func convertToString(format: String = "M월 d일") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(for: self) ?? ""
    }
}
