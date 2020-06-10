//
//  CustomWorkout+CoreDataProperties.swift
//  FitLevel
//
//  Created by Jacky Eng on 10/06/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//
//

import Foundation
import CoreData


extension CustomWorkout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomWorkout> {
        return NSFetchRequest<CustomWorkout>(entityName: "CustomWorkout")
    }

    @NSManaged public var repetition: String?
    @NSManaged public var set: String?
    @NSManaged public var duration: String?
    @NSManaged public var routine: NSSet?
    @NSManaged public var workout: Workout?

}

// MARK: Generated accessors for routine
extension CustomWorkout {

    @objc(addRoutineObject:)
    @NSManaged public func addToRoutine(_ value: Routine)

    @objc(removeRoutineObject:)
    @NSManaged public func removeFromRoutine(_ value: Routine)

    @objc(addRoutine:)
    @NSManaged public func addToRoutine(_ values: NSSet)

    @objc(removeRoutine:)
    @NSManaged public func removeFromRoutine(_ values: NSSet)

}
