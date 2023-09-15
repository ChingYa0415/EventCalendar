//
//  DateExtension.swift
//  EventCalendar
//
//  Created by YA on 2023/9/9.
//

import Foundation

let itemFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    
    return dateFormatter
}()

func setElapsedTime(_ date: Date) -> String {
    let date = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date, to: Date())
    
    if let day = date.day {
        return String(day < 0 ? "\(abs(day))天後開始" : "\(day)天")
    }
    
    return ""
}

func currentCalendar() -> Calendar {
    var calendar = Calendar.current
    calendar.locale = Locale(identifier: "zh_Hant_TW")
    calendar.timeZone = TimeZone(identifier: "Asia/Taipei")!
    
    return calendar
}

func dateToDay(_ date: Date? = nil) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")!
   
    return  dateFormatter.date(from: dateFormatter.string(from: date ?? Date()))!
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
