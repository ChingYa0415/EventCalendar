//
//  EventCalendarView.swift
//  EventCalendar
//
//  Created by Angus on 2023/7/21.
//

import SwiftUI

struct EventCalendarView: View {
    
    // MARK: - Property Wrapper
    
    @State var m_event: Event
    
    // MARK: - Property
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text(m_event.title ?? "Title")
                        .font(.title)
                    
                    Text(m_event.content ?? "Content")
                        .font(.callout)
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, idealHeight: 300, alignment: .leading)
                .padding(.horizontal, 20)
                
                CalendarView(m_dateStartDate: m_event.startDate!, m_dateCurrentDate: Date())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle("事件詳細資訊")
        .navigationBarTitleDisplayMode(.inline)
        .tint(.pink)
    }
    
}

// MARK: - Preview

struct EventCalendarView_Previews: PreviewProvider {
    
    static var previews: some View {
        EventCalendarView(m_event: (PersistenceController.testData?[0])!)
    }
    
}
