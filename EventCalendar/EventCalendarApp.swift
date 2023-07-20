//
//  EventCalendarApp.swift
//  EventCalendar
//
//  Created by Angus on 2023/7/19.
//

import SwiftUI

@main
struct EventCalendarApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}