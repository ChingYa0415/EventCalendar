//
//  CalendarView.swift
//  EventCalendar
//
//  Created by Angus on 2023/7/21.
//

import SwiftUI

struct CalendarView: View {
    
    // MARK: -  Property
    
    var days: [String] = ["週日", "週一", "週二", "週三", "週四", "週五", "週六"]
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack(alignment: .center) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(day == days.first || day == days.last ? .gray : .black)
                        .frame(maxWidth: .infinity)
                }
            }
            
            HStack(alignment: .center) {
                
            }
        }
        .padding()
    }
    
}

// MARK: - Extension

extension Date {
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day, to: self)!
        }
    }
    
}

// MARK: - Preview

#Preview {
    CalendarView()
}
