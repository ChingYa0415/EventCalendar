//
//  Event+CoreDataProperties.swift
//  EventCalendar
//
//  Created by YA on 2023/8/18.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var content: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var endDate: Date?

}

extension Event : Identifiable {

}
