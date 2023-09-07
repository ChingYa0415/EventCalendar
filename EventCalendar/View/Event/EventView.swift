//
//  EventView.swift
//  EventCalendar
//
//  Created by YA on 2023/9/7.
//

import SwiftUI

struct EventView: View {
    
    @Environment(\.isPresented) private var presentMode
    @FocusState var m_bIsEditing: Bool
    @State var m_dataImage: Data
    @State var m_strContent: String
    @State var m_bIsAddingImage: Bool = false
    @State var m_bIsAddingContent: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if !m_bIsAddingImage {
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
            
            if !m_bIsAddingContent {
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
        
        VStack(alignment: .leading, spacing: 10) {
            if m_bIsAddingImage {
                if m_dataImage.isEmpty {
                    Image(uiImage: UIImage(data: m_dataImage) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            
            if m_bIsAddingContent {
                Text("備註")
                    .padding(.vertical, 10)
                    .font(.subheadline)
                
                TextEditor(text: $m_strContent)
                    .padding(10)
                    .frame(minHeight: 200, maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.gray, lineWidth: 1.0)
                    }
                    .focused($m_bIsEditing)
            }
        }
        .padding()
    }
    
}

// MARK: - Preview

struct EventView_Previews: PreviewProvider {
    
    static var previews: some View {
        let testData = PersistenceController.testEventContentData![0]
        
        EventView(m_dataImage: testData.image!, m_strContent: testData.content ?? "")
    }
    
}
