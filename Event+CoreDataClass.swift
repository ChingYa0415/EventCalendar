//
//  Event+CoreDataClass.swift
//  EventCalendar
//
//  Created by YA on 2023/8/18.
//
//

import Foundation
import CoreData

@objc(Event)
public class Event: NSManagedObject {
    public var content: String?
    public var startDate: Date?
    public var id: UUID?
    public var title: String?
    public var endDate: Date?
}
