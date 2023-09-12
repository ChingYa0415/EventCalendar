//
//  CalendarView.swift
//  EventCalendar
//
//  Created by Angus on 2023/7/21.
//

import SwiftUI

struct CalendarView: View {
    
    // MARK: - Property Wrapper
    
    @Environment(\.colorScheme) private var colorScheme
    @Binding var m_eventContents: [EventContent]
    @Binding var m_dateStart: Date?
    @Binding var m_dateEnd: Date?
    @Binding var m_dateCurrent: Date
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
                    m_iCurrentMonth -= 1
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                .tint(.clear)
                
                Button {
                    m_iCurrentMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                .tint(.clear)
            }
            .padding()
            
            HStack(alignment: .center) {
                ForEach(m_aryDays, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(day == m_aryDays.first || day == m_aryDays.last ? .gray : colorScheme == .dark ? .white : .black)
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
                            .foregroundStyle(haveContent(dateValue: value) ? .gray : .clear)
                            .frame(width: 8, height: 8)
                    }
                    .frame(maxWidth: .infinity)
                    .background {
                        if isSameDay(dateValue: value, currentDate: m_dateStart!) {
                            if isSameDay(date1: m_dateStart!, date2: m_dateCurrent) {
                                Capsule()
                                    .foregroundStyle(LinearGradient(colors: [.green, .pink], startPoint: .top, endPoint: .bottom))
                                    .padding(.horizontal, 8)
                                    .opacity(1)
                            } else {
                                Capsule()
                                    .foregroundStyle(.green)
                                    .padding(.horizontal, 8)
                                    .opacity(1)
                            }
                        } else if m_dateEnd != nil, isSameDay(dateValue: value, currentDate: m_dateEnd!) {
                            if isSameDay(date1: m_dateEnd!, date2: m_dateCurrent) {
                                Capsule()
                                    .foregroundStyle(LinearGradient(colors: [.blue, .pink], startPoint: .top, endPoint: .bottom))
                                    .padding(.horizontal, 8)
                                    .opacity(1)
                            } else {
                                Capsule()
                                    .foregroundStyle(.blue)
                                    .padding(.horizontal, 8)
                                    .opacity(1)
                            }
                        } else {
                            Capsule()
                                .foregroundStyle(.pink)
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(dateValue: value, currentDate: m_dateCurrent) ? 1 : 0)
                        }
                    }
                    .onTapGesture {
                        m_dateCurrent = value.date
                    }
                }
            }
        }
        .padding()
        .onChange(of: m_iCurrentMonth) { newValue in
            m_dateCurrent = getCurrentMonth()
        }
        .animation(nil)
    }
    
    // MARK: - Method
    
    func isSameDay(dateValue: DateValue, currentDate: Date) -> Bool {
        return dateValue.day != -1 ? currentCalendar().isDate(dateValue.date, inSameDayAs: currentDate) : false
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        return currentCalendar().isDate(date1, inSameDayAs: date2)
    }
    
    func haveContent(dateValue: DateValue) -> Bool {
        if dateValue.day != -1 {
            for eventContent in m_eventContents {
                if currentCalendar().isDate(dateValue.date, inSameDayAs: eventContent.date!) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func extractData() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")!
        
        return formatter.string(from: m_dateCurrent).components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = currentCalendar()
        
        guard let currentMonth = calendar.date(byAdding: .month, value: m_iCurrentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = currentCalendar()
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

// MARK: - Preview

struct CalendarView_Previews: PreviewProvider {
    
    static var previews: some View {
        let testEventContentData = PersistenceController.testEventContentData!
        
        CalendarView(m_eventContents: .constant(testEventContentData), m_dateStart: .constant(Date()), m_dateEnd: .constant(Date()), m_dateCurrent: .constant(Date()))
    }
    
}
