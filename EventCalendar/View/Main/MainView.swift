//
//  ContentView.swift
//  EventCalendar
//
//  Created by Angus on 2023/7/19.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    // MARK: - Property Wrapper
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Event.startDate, ascending: true)])
    private var m_events: FetchedResults<Event>
    @State var m_bIsNewEventPresented: Bool
    @State var m_bIsDeleteAllAlertPresented: Bool
    @State var m_bIsHelpAlertPresented: Bool
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(m_events) { event in
                        ZStack {
                            MainEventCellView(m_strTitle: event.title!, m_dateStart: event.startDate!, m_strElapsedTime: setElapsedTime(event.startDate!))
                            
                            NavigationLink {
                                EventCalendarView(m_event: event)
                            } label: {
                                EmptyView()
                            }
                            .opacity(0)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle(Text("事件"))
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        if !m_events.isEmpty {
                            Button {
                                m_bIsDeleteAllAlertPresented = true
                            } label: {
                                Text("全部刪除")
                                    .underline()
                                    .foregroundStyle(.red)
                            }
                            
                            Spacer()
                            
                            Button {
                                m_bIsHelpAlertPresented = true
                            } label: {
                                Image(systemName: "info.circle")
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }
                .sheet(isPresented: $m_bIsNewEventPresented) {
                    NewEventView()
                }
                .alert("全部刪除", isPresented: $m_bIsDeleteAllAlertPresented) {
                    Text("取消")
                    
                    Button("確定", role: .destructive) {
                        withAnimation {
                            do {
                                for event in m_events {
                                    viewContext.delete(event)
                                }
                                
                                try viewContext.save()
                            } catch {
                                print("刪除全部資料錯誤：", error)
                            }
                        }
                    }
                } message: {
                    Text("確定要刪除全部資料嗎？")
                }
                .alert("", isPresented: $m_bIsHelpAlertPresented) {
                    Text("好")
                } message: {
                    Text("經過日期以天為單位來進行計算")
                }
                .refreshable {
                    do {
                        try await Task.sleep(nanoseconds: 1 * 1000000000)
                        
                        viewContext.refreshAllObjects()
                    } catch {
                        print(error)
                    }
                }
                
                Button {
                    m_bIsNewEventPresented = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundStyle(.green)
                        .frame(width: 60, height: 60)
                        .background(in: RoundedRectangle(cornerSize: CGSize(width: 30, height: 30)))
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .tint(.clear)
                .padding()
            }
        }
    }
    
    // MARK: - Method
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { m_events[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

// MARK: - Preview

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView(m_bIsNewEventPresented: false, m_bIsDeleteAllAlertPresented: false, m_bIsHelpAlertPresented: false)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    
}
