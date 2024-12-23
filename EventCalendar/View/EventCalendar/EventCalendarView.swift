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
    @FocusState var m_bIsEditing: Bool
    @State var m_dateCurrent: Date = dateToDay()
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
                CalendarView(m_eventContents: getEventContents(), m_dateStart: $m_event.startDate, m_dateEnd: $m_event.endDate, m_dateCurrent: $m_dateCurrent)
                
                EventView(m_bIsEditing: _m_bIsEditing, m_eventContent: getCurrentEventContent(), m_event: m_event, m_dateCurrent: $m_dateCurrent)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
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
            NewEventView(m_uuidID: m_event.id!, m_enumType: .Edit, m_strTitle: m_event.title!, m_bHasEndDay: m_event.endDate != nil ? true : false, m_dateStart: m_event.startDate!, m_dateEnd: m_event.endDate != nil ? m_event.endDate! : Date(timeInterval: 3600, since: m_event.startDate!), m_strContent: m_event.content!)
        }
    }
    
    // MARK: - Method
    
    func getCurrentEventContent() -> EventContent {
        let fetchRequest = EventContent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "event == %@", m_event.objectID)
        
        do {
            let m_eventContents = try viewContext.fetch(fetchRequest) as [EventContent]
            
            for eventContent in m_eventContents {
                if eventContent.date == m_dateCurrent {
                    return eventContent
                }
            }
            
            return EventContent(context: viewContext)
        } catch {
            let nsError = error as NSError
            
            fatalError("取得EventContent錯誤\(nsError), \(nsError.userInfo)")
        }
    }
    
    func getEventContents() -> Binding<[EventContent]> {
        let fetchRequest = EventContent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "event == %@", m_event.objectID)
        
        do {
            var m_eventContents = try viewContext.fetch(fetchRequest) as [EventContent]
            
            return Binding {
                m_eventContents
            } set: {
                m_eventContents = $0
            }
        } catch {
            let nsError = error as NSError
            
            fatalError("取得EventContent錯誤\(nsError), \(nsError.userInfo)")
        }
    }
    
}

// MARK: - Preview

struct EventCalendarView_Previews: PreviewProvider {
    
    static var previews: some View {
        let testEventData = PersistenceController.testEventData![0]
        
        EventCalendarView(m_event: testEventData)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
    
}
