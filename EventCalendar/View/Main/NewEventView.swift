//
//  NewEventView.swift
//  EventCalendar
//
//  Created by YA on 2023/8/18.
//

import SwiftUI

struct NewEventView: View {
    
    // MARK: - Enumeration
    
    enum NewType {
        case Add
        case Edit
    }
    
    // MARK: - Property Wrapper
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @FocusState var m_bIsTitleEditing: Bool
    @FocusState var m_bIsContentEditing: Bool
    @State var m_uuidID: UUID?
    @State var m_enumType: NewType = .Add
    @State var m_strTitle: String = ""
    @State var m_bHasEndDay: Bool = false
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
                        .focused($m_bIsTitleEditing)
                }
                
                Section {
                    Toggle("結束日", isOn: $m_bHasEndDay)
                    
                    DatePicker("開始", selection: $m_dateStart, displayedComponents: .date)
                    
                    if m_bHasEndDay {
                        DatePicker("結束", selection: $m_dateEnd, displayedComponents: .date)
                    }
                }
                
                Section {
                    ZStack {
                        if m_strContent.isEmpty && !m_bIsContentEditing {
                            Text("備註")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .foregroundStyle(.gray)
                                .padding(.vertical, 10)
                        }
                        
                        TextEditor(text: $m_strContent)
                            .frame(minHeight: 200, maxHeight: .infinity, alignment: .topLeading)
                            .focused($m_bIsContentEditing)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(m_enumType == .Add ? "新增事件" : "編輯事件")
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
                            if m_enumType == .Add{
                                addItem()
                            } else if m_enumType == .Edit {
                                editItem()
                            }
                        }
                    } label: {
                        Text(m_enumType == .Add ? "新增" : "確定")
                            .underline(true, color: .green)
                            .foregroundColor(.green)
                    }
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button {
                        m_bIsTitleEditing = false
                        m_bIsContentEditing = false
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
            
            if m_strTitle.isEmpty {
                m_strTitle = "新增事件"
            }
            
            if m_strContent.isEmpty {
                m_strContent = "新增事件內容"
            }
            
            event.title = m_strTitle
            event.startDate = dateToDay(m_dateStart)
            event.endDate = m_bHasEndDay ? dateToDay(m_dateEnd) : nil
            event.content = m_strContent
            
            do {
                try viewContext.save()
                
                dismiss()
            } catch {
                let nsError = error as NSError
                
                fatalError("新增錯誤\(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func editItem() {
        let fetchRequest = Event.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", m_uuidID! as CVarArg)
        
        do {
            if let eventToUpdate = try? viewContext.fetch(fetchRequest).first {
                eventToUpdate.title = m_strTitle
                eventToUpdate.endDate = m_dateEnd
                eventToUpdate.startDate = m_dateStart
                eventToUpdate.content = m_strContent
                
                try viewContext.save()
                
                dismiss()
            }
        } catch {
            let nsError = error as NSError
            
            fatalError("編輯錯誤\(nsError), \(nsError.userInfo)")
        }
    }
    
}

// MARK: - Preview

struct NewEventView_Previews: PreviewProvider {
    
    static var previews: some View {
        NewEventView(m_strTitle: "", m_dateStart: Date(), m_dateEnd: Date().addingTimeInterval(3600), m_strContent: "")
    }
    
}
