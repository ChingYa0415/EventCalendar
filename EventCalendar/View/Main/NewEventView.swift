//
//  NewEventView.swift
//  EventCalendar
//
//  Created by YA on 2023/8/18.
//

import SwiftUI

struct NewEventView: View {
    
    // MARK: - Property Wrapper
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @FocusState var m_bIsEditing: Bool
    @State var m_strTitle: String = ""
    @State var m_bHasEndDay: Bool = false
    @State var m_bIsAllDay: Bool = false
    @State var m_dateStart: Date = Date()
    @State var m_dateEnd: Date = Date(timeInterval: 3600, since: Date())
    @State var m_strContent: String = ""
    @State var m_bIsAlertPresented: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("標題", text: $m_strTitle)
                        .focused($m_bIsEditing)
                }
                
                Section {
                    Toggle("結束日", isOn: $m_bHasEndDay)
                    
                    Toggle("整日", isOn: $m_bIsAllDay)
                    
                    if m_bIsAllDay {
                        DatePicker("開始", selection: $m_dateStart, displayedComponents: .date)
                        
                        if m_bHasEndDay {
                            DatePicker("結束", selection: $m_dateEnd, displayedComponents: .date)
                        }
                    } else {
                        DatePicker("開始", selection: $m_dateStart)
                        
                        if m_bHasEndDay {
                            DatePicker("結束", selection: $m_dateEnd)
                        }
                    }
                }
                
                Section {
                    ZStack {
                        if m_strContent.isEmpty && !m_bIsEditing {
                            Text("備註")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .foregroundStyle(.gray)
                                .padding(.vertical, 10)
                        }
                        
                        TextEditor(text: $m_strContent)
                            .frame(minHeight: 200, maxHeight: .infinity, alignment: .topLeading)
                            .focused($m_bIsEditing)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("新增事件")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("取消")
                            .underline(true, color: .green)
                            .foregroundColor(.green)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if m_dateStart.compare(m_dateEnd) == .orderedDescending && m_bHasEndDay  {
                            m_bIsAlertPresented = true
                        } else {
                            addItem()
                        }
                    } label: {
                        Text("新增")
                            .underline(true, color: .green)
                            .foregroundColor(.green)
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
            .alert("新增失敗", isPresented: $m_bIsAlertPresented) {
                Button {
                    m_bIsAlertPresented = false
                } label: {
                    // MARK: TODO: 更改文字顏色
                    Text("好")
                }
                .tint(.green)
            } message: {
                Text("開始日期必須早於結束日期")
            }
        }
    }
    
    // MARK: - Method
    
    private func addItem() {
        withAnimation {
            let event = Event(context: viewContext)
            event.id = UUID()
            
            if m_strTitle == "" {
                m_strTitle = "新增事件"
            }
            
            event.title = m_strTitle
            event.startDate = m_dateStart
            event.endDate = m_bHasEndDay ? m_dateEnd : nil
            event.content = m_strContent
            
            do {
                try viewContext.save()
                
                dismiss()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                
                fatalError("新增錯誤\(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

// MARK: - Preview

struct NewEventView_Previews: PreviewProvider {
    
    static var previews: some View {
        NewEventView(m_strTitle: "", m_bIsAllDay: false, m_dateStart: Date(), m_dateEnd: Date().addingTimeInterval(3600), m_strContent: "")
    }
    
}
