//
//  EventCalendarView.swift
//  EventCalendar
//
//  Created by Angus on 2023/7/21.
//

import SwiftUI

struct EventCalendarView: View {
    
    // MARK: - Property Wrapper
    
    @Environment(\.managedObjectContext) private var viewContext
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
                
                CalendarView(m_dateCurrentDate: m_event.startDate!)
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
    
    @Environment(\.managedObjectContext) private var viewContext
    
    static var previews: some View {
        EventCalendarView(m_event: Event(context: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    
}
