//
//  Routine+CoreDataProperties.swift
//  FitLevel
//
//  Created by Jacky Eng on 19/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//
//

import Foundation
import CoreData


extension Routine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }

    @NSManaged public var date: String?
    @NSManaged public var name: String?
    @NSManaged public var activeroutine: NSSet?
    @NSManaged public var plan: NSSet?
    @NSManaged public var customworkout: NSSet?

}

// MARK: Generated accessors for activeroutine
extension Routine {

    @objc(addActiveroutineObject:)
    @NSManaged public func addToActiveroutine(_ value: ActiveRoutine)

    @objc(removeActiveroutineObject:)
    @NSManaged public func removeFromActiveroutine(_ value: ActiveRoutine)

    @objc(addActiveroutine:)
    @NSManaged public func addToActiveroutine(_ values: NSSet)

    @objc(removeActiveroutine:)
    @NSManaged public func removeFromActiveroutine(_ values: NSSet)

}

// MARK: Generated accessors for plan
extension Routine {

    @objc(addPlanObject:)
    @NSManaged public func addToPlan(_ value: Plan)

    @objc(removePlanObject:)
    @NSManaged public func removeFromPlan(_ value: Plan)

    @objc(addPlan:)
    @NSManaged public func addToPlan(_ values: NSSet)

    @objc(removePlan:)
    @NSManaged public func removeFromPlan(_ values: NSSet)

}

// MARK: Generated accessors for customworkout
extension Routine {

    @objc(addCustomworkoutObject:)
    @NSManaged public func addToCustomworkout(_ value: CustomWorkout)

    @objc(removeCustomworkoutObject:)
    @NSManaged public func removeFromCustomworkout(_ value: CustomWorkout)

    @objc(addCustomworkout:)
    @NSManaged public func addToCustomworkout(_ values: NSSet)

    @objc(removeCustomworkout:)
    @NSManaged public func removeFromCustomworkout(_ values: NSSet)

}
