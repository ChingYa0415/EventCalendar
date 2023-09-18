//
//  EventView.swift
//  EventCalendar
//
//  Created by YA on 2023/9/7.
//

import SwiftUI

struct EventView: View {
    
    // MARK: - Enumeration
    
    enum PhotoSource: Identifiable {
        case photoLibrary
        case camera
        
        var id: Int {
            hashValue
        }
    }
    
    // MARK: - Property Wrapper
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.isPresented) private var presentMode
    @FocusState var m_bIsEditing: Bool
    @ObservedObject var m_eventContent: EventContent
    @ObservedObject var m_event: Event
    @Binding var m_dateCurrent: Date
    @State var m_enumPhotoSource: PhotoSource?
    @State var m_bIsAddingImage: Bool = false
    @State var m_bIsAddingContent: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if m_eventContent.image.isEmpty {
                Button {
                    m_bIsAddingImage = true
                } label: {
                    Text("新增今日圖片")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                        .background(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.vertical, 10)
                }
                .tint(.clear)
            }
            
            if !m_bIsAddingContent && m_eventContent.content.isEmpty {
                Button {
                    m_bIsAddingContent = true
                } label: {
                    Text("新增今日備註")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                        .background(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.vertical, 10)
                }
                .tint(.clear)
            }
        }
        .padding()
        .confirmationDialog("選擇圖片來源", isPresented: $m_bIsAddingImage, titleVisibility: .visible) {
            Button("相機", role: .none) {
                m_enumPhotoSource = .camera
            }
            
            Button("照片", role: .none) {
                m_enumPhotoSource = .photoLibrary
            }
            
            if !m_eventContent.image.isEmpty {
                Button("刪除", role: .destructive) {
                    m_eventContent.image = Data()
                    
                    if m_eventContent.content.isEmpty && m_eventContent.image.isEmpty && m_eventContent.id != nil {
                        deleteEventContent(m_eventContent.id!)
                    } else {
                        addOrEditEventContent()
                    }
                }
            }
        }
        .fullScreenCover(item: $m_enumPhotoSource) { source in
            switch source {
            case .camera:
                ImagePicker(m_eventContent: m_eventContent, m_event: m_event, m_dateCurrent: $m_dateCurrent, sourceType: .camera).ignoresSafeArea()
            case .photoLibrary:
                ImagePicker(m_eventContent: m_eventContent, m_event: m_event, m_dateCurrent: $m_dateCurrent, sourceType: .photoLibrary).ignoresSafeArea()
            }
        }
        
        VStack(alignment: .leading, spacing: 10) {
            if !m_eventContent.image.isEmpty {
                Image(uiImage: UIImage(data: m_eventContent.image) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        m_bIsAddingImage = true
                    }
            }
            
            if m_bIsAddingContent || !m_eventContent.content.isEmpty {
                Text("備註")
                    .padding(.vertical, 10)
                    .font(.subheadline)
                
                TextEditor(text: $m_eventContent.content)
                    .padding(10)
                    .frame(minHeight: 200, maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.gray, lineWidth: 1.0)
                    }
                    .focused($m_bIsEditing)
                    .onChange(of: m_eventContent.content) { newValue in
                        if m_bIsAddingContent {
                            if m_eventContent.content.isEmpty && m_eventContent.image.isEmpty && m_eventContent.id != nil {
                                deleteEventContent(m_eventContent.id!)
                            } else {
                                addOrEditEventContent()
                            }
                        }
                    }
            }
        }
        .padding()
        .onChange(of: m_dateCurrent) { newValue in
            m_bIsAddingImage = false
            m_bIsAddingContent = false
        }
    }
    
    // MARK: - Method
    
    private func addOrEditEventContent() {
        do {
            if m_eventContent.id != nil {
                let fetchRequest = EventContent.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", (m_eventContent.id! as CVarArg))
                
                if let eventContentToUpdate = try? viewContext.fetch(fetchRequest).first {
                    eventContentToUpdate.content = m_eventContent.content
                    eventContentToUpdate.image = m_eventContent.image
                    eventContentToUpdate.date = m_dateCurrent
                }
            } else {
                let eventContent = EventContent(context: viewContext)
                eventContent.id = UUID()
                eventContent.content = m_eventContent.content
                eventContent.image = m_eventContent.image
                eventContent.date = m_dateCurrent
                eventContent.event = m_event
            }
            
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            
            fatalError("新增錯誤\(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deleteEventContent(_ id: UUID) {
        do {
            let fetchRequest = EventContent.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            if let eventContentToDelete = try? viewContext.fetch(fetchRequest).first {
                viewContext.delete(eventContentToDelete)
            }
            
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            
            fatalError("刪除錯誤\(nsError), \(nsError.userInfo)")
        }
    }
    
    func checkEventContentsExist() -> Bool {
        let fetchRequest = EventContent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "event == %@", m_event.objectID)
        
        do {
            if (try? viewContext.fetch(fetchRequest) as [EventContent]) != nil {
                return true
            } else {
                return false
            }
        }
    }
    
    
    
}

// MARK: - Preview

struct EventView_Previews: PreviewProvider {
    
    static var previews: some View {
        let testEventData = PersistenceController.testEventData![0]
        let testEventContentData = PersistenceController.testEventContentData![0]
        
        EventView(m_eventContent: testEventContentData, m_event: testEventData, m_dateCurrent: .constant(Date()))
    }
    
}
