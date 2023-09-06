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
    @State var m_bIsNewEventPresented: Bool
    @State var m_bIsAlertPresented: Bool
    
    // MARK: - Property
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Event.startDate, ascending: true)])
    private var m_events: FetchedResults<Event>
    let itemFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        return dateFormatter
    }()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            if m_events.isEmpty {
                Text("空的")
                    .navigationTitle(Text("事件"))
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                m_bIsNewEventPresented.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .sheet(isPresented: $m_bIsNewEventPresented) {
                        NewEventView()
                    }
            } else {
                List {
                    ForEach(m_events) { event in
                        NavigationLink {
                            EventCalendarView(m_event: event)
                        } label: {
                            Image(systemName: "calendar")
                                .imageScale(.large)
                                .padding()
                                .background(.pink)
                                .clipShape(Circle())
                            
                            Text(event.startDate!, formatter: itemFormatter)
                                .padding(.leading, 20)
                                .foregroundStyle(.green)
                                .font(.subheadline)
                            
                            Text("\(event.title!)")
                                .bold()
                                .padding(.leading, 20)
                                .foregroundStyle(.green)
                                .font(.subheadline)
                                .lineLimit(2)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle(Text("事件"))
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        if !m_events.isEmpty {
                            Button {
                                m_bIsAlertPresented = true
                            } label: {
                                Text("全部刪除")
                                    .underline()
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            m_bIsNewEventPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.green)
                        }
                    }
                }
                .sheet(isPresented: $m_bIsNewEventPresented) {
                    NewEventView()
                }
                .alert("全部刪除", isPresented: $m_bIsAlertPresented) {
                    Button {
                        m_bIsAlertPresented = false
                    } label: {
                        // MARK: TODO: 更改文字顏色
                        Text("取消")
                    }
                    
                    Button {
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
                    } label: {
                        // MARK: TODO: 更改文字顏色
                        Text("好")
                    }
                } message: {
                    Text("確定要刪除全部資料嗎？")
                }
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
        MainView(m_bIsNewEventPresented: false, m_bIsAlertPresented: false)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    
}
