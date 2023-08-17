//
//  CalendarView.swift
//  EventCalendar
//
//  Created by Angus on 2023/7/21.
//

import SwiftUI

struct CalendarView: View {
    
    // MARK: - Property Wrapper
    
    @State var m_dateCurrentDate: Date
    @State var m_iCurrentMonth: Int = 0
    
    // MARK: - Property
    
    let m_aryColumns = Array(repeating: GridItem(.flexible()), count: 7)
    var m_aryDays: [String] = ["週日", "週一", "週二", "週三", "週四", "週五", "週六"]
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(extractData()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extractData()[1])
                        .font(.title2.bold())
                }
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation {
                        m_iCurrentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                
                Button {
                    withAnimation {
                        m_iCurrentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .padding()
            
            HStack(alignment: .center) {
                ForEach(m_aryDays, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(day == m_aryDays.first || day == m_aryDays.last ? .gray : .black)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: m_aryColumns, spacing: 15) {
                ForEach(extractDate()) { value in
                    let day = value.day != -1 ? String(value.day) : ""
                    
                    VStack {
                        Text("\(day)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.vertical, 8)
                            .frame(height: 40, alignment: .top)
                        
                        Spacer()
                        
                        Circle()
                            .foregroundStyle(.pink)
                            .frame(width: 8, height: 8)
                    }
                    .frame(maxWidth: .infinity)
                    .background {
                        Capsule()
                            .foregroundStyle(.pink)
                            .padding(.horizontal, 8)
                            .opacity(isSameDay(dateValue: value, currentDate: m_dateCurrentDate) ? 1 : 0)
                    }
                    .onTapGesture {
                        m_dateCurrentDate = value.date
                    }
                }
            }
        }
        .padding()
        .onChange(of: m_iCurrentMonth) { newValue in
            m_dateCurrentDate = getCurrentMonth()
        }
    }
    
    // MARK: - Method
    
    func isSameDay(dateValue: DateValue, currentDate: Date) -> Bool {
        if dateValue.day != -1 {
            return Calendar.current.isDate(dateValue.date, inSameDayAs: currentDate)
        } else {
            return false
        }
    }
    
    func extractData() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        return formatter.string(from: m_dateCurrentDate).components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: m_iCurrentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekDay - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
}

// MARK: - Extension

extension Date {
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: calendar.dateComponents([.month, .year], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
}

// MARK: - Preview

struct CalendarView_Previews: PreviewProvider {
    
    static var previews: some View {
        CalendarView(m_dateCurrentDate: Date())
    }
    
}
