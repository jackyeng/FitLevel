//
//  Workout+CoreDataProperties.swift
//  FitLevel
//
//  Created by Jacky Eng on 19/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var image: String?
    @NSManaged public var level: Int16
    @NSManaged public var name: String?
    @NSManaged public var custom: NSSet?

}

// MARK: Generated accessors for custom
extension Workout {

    @objc(addCustomObject:)
    @NSManaged public func addToCustom(_ value: CustomWorkout)

    @objc(removeCustomObject:)
    @NSManaged public func removeFromCustom(_ value: CustomWorkout)

    @objc(addCustom:)
    @NSManaged public func addToCustom(_ values: NSSet)

    @objc(removeCustom:)
    @NSManaged public func removeFromCustom(_ values: NSSet)

}
