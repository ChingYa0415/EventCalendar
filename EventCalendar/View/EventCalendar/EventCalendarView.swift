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
    @ObservedObject var m_event: Event
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \EventContent.date, ascending: true)])
    private var m_eventContents: FetchedResults<EventContent>
    @FocusState var m_bIsEditing: Bool
    @State var m_dateCurrent: Date = Date()
    @State var m_bIsNewEventPresented: Bool = false
    
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
                
                CalendarView(m_dateStart: $m_event.startDate, m_dateCurrent: $m_dateCurrent)
                
//                ForEach(m_eventContents) { eventContent in
//                    if eventContent.date == m_dateCurrent {
//                        EventView(m_dataImage: eventContent.image ?? Data(), m_strContent: eventContent.content ?? "")
//                    }
//                }
                EventView(m_bIsEditing: _m_bIsEditing, m_dataImage: Data(), m_strContent: "")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle("事件詳細資訊")
        .navigationBarTitleDisplayMode(.inline)
        .tint(.pink)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    m_bIsNewEventPresented = true
                } label: {
                    Text("編輯")
                        .underline()
                        .foregroundStyle(.green)
                }
            }
            
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button {
                    m_bIsEditing = false
                } label: {
                    Text("確定")
                        .foregroundStyle(.green)
                }
            }
        }
        .sheet(isPresented: $m_bIsNewEventPresented) {
            print(m_event.startDate!)
        } content: {
            NewEventView(m_uuidID: m_event.id, m_enumType: .Edit, m_strTitle: m_event.title!, m_bHasEndDay: m_event.endDate != nil ? true : false, m_dateStart: m_event.startDate!, m_dateEnd: m_event.endDate != nil ? m_event.endDate! : Date(timeInterval: 3600, since: m_event.startDate!), m_strContent: m_event.content!)
        }
    }
    
}

// MARK: - Preview

struct EventCalendarView_Previews: PreviewProvider {
    
    static var previews: some View {
        EventCalendarView(m_event: (PersistenceController.testEventData![0]))
    }
    
}
