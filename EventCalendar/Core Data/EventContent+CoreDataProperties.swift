//
//  EventContent+CoreDataProperties.swift
//  EventCalendar
//
//  Created by YA on 2023/8/18.
//
//

import Foundation
import CoreData


extension EventContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventContent> {
        return NSFetchRequest<EventContent>(entityName: "EventContent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var image: Data?
    @NSManaged public var date: Date?

}

extension EventContent : Identifiable {

}
