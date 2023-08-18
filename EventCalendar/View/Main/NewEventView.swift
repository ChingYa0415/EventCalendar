//
//  NewEventView.swift
//  EventCalendar
//
//  Created by YA on 2023/8/18.
//

import SwiftUI

struct NewEventView: View {
    
    // MARK: - Property Wrapper
    
    @Environment(\.dismiss) var dismiss
    @State var m_strTitle: String
    @State var m_bIsAllDay: Bool
    @State var m_dateStart: Date
    @State var m_dateEnd: Date
    @State var m_strContent: String
    
    // MARK: - Property
    
    let calendar = Calendar.current
//    let calendar.date(byAdding: .day, value: day, to: Date())!
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("標題", text: $m_strTitle)
                }
                
                Section {
                    Toggle("整日", isOn: $m_bIsAllDay)
                    
                    if m_bIsAllDay {
                        DatePicker("開始", selection: $m_dateStart, displayedComponents: .date)
                        
                        DatePicker("結束", selection: $m_dateEnd, displayedComponents: .date)
                    } else {
                        DatePicker("開始", selection: $m_dateStart)
                        
                        DatePicker("結束", selection: $m_dateEnd)
                    }
                }
                
                Section {
                    TextField("註解", text: $m_strContent)
                        .frame(height: 100, alignment: .topLeading)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("新增行程")
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
                        
                    } label: {
                        Text("新增")
                            .underline(true, color: .green)
                            .foregroundColor(.green)
                    }
                }
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


