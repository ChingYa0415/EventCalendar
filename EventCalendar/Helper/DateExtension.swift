//
//  DateExtension.swift
//  EventCalendar
//
//  Created by YA on 2023/9/9.
//

import Foundation

func currentCalendar() -> Calendar {
    var calendar = Calendar.current
    calendar.locale = Locale(identifier: "zh_Hant_TW")
    calendar.timeZone = TimeZone(identifier: "Asia/Taipei")!
    
    return calendar
}

func dateToDay() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")!
   
    return  dateFormatter.date(from: dateFormatter.string(from: Date()))!
}

extension Date {
    
    func getAllDates() -> [Date] {
        let calendar = currentCalendar()
        let startDate = calendar.date(from: calendar.dateComponents([.month, .year], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
}
