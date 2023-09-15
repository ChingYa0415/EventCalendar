//
//  MainEventCellView.swift
//  EventCalendar
//
//  Created by YA on 2023/9/15.
//

import SwiftUI

struct MainEventCellView: View {
    
    // MARK: - Property Wrapper
    
    @State var m_strTitle: String
    @State var m_dateStart: Date
    @State var m_strElapsedTime: String
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(systemName: "calendar")
                    .imageScale(.large)
                    .shadow(color: .gray, radius: 2, x: 4, y: 4)
                    .foregroundStyle(.pink)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(m_strTitle)
                        .bold()
                        .foregroundStyle(.green)
                        .font(.title2)
                        .fontDesign(.monospaced)
                        .lineLimit(1)
                    
                    Text(m_dateStart, formatter: itemFormatter)
                        .font(.subheadline)
                        .fontDesign(.monospaced)
                }
                .padding(.leading, 8)
                
                Spacer()
            }
            
            Spacer()

            HStack {
                Spacer()
                
                Text(m_strElapsedTime)
                    .font(.title)
                    .fontDesign(.monospaced)
            }
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

struct MainEventCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainEventCellView(m_strTitle: "牙套", m_dateStart: Date(), m_strElapsedTime: "365天")
    }
    
}
