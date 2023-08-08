//
//  DateValue.swift
//  EventCalendar
//
//  Created by Angus on 2023/7/28.
//

import Foundation

struct DateValue: Identifiable {
    
    var id = UUID().uuidString
    var day: Int
    var date: Date
    
}
