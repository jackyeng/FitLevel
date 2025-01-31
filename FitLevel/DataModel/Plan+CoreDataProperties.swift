//
//  Plan+CoreDataProperties.swift
//  FitLevel
//
//  Created by Jacky Eng on 19/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//
//

import Foundation
import CoreData


extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var routine: NSSet?

}

// MARK: Generated accessors for routine
extension Plan {

    @objc(addRoutineObject:)
    @NSManaged public func addToRoutine(_ value: Routine)

    @objc(removeRoutineObject:)
    @NSManaged public func removeFromRoutine(_ value: Routine)

    @objc(addRoutine:)
    @NSManaged public func addToRoutine(_ values: NSSet)

    @objc(removeRoutine:)
    @NSManaged public func removeFromRoutine(_ values: NSSet)

}
