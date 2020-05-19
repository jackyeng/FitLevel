//
//  ActiveRoutine+CoreDataProperties.swift
//  FitLevel
//
//  Created by Jacky Eng on 19/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//
//

import Foundation
import CoreData


extension ActiveRoutine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActiveRoutine> {
        return NSFetchRequest<ActiveRoutine>(entityName: "ActiveRoutine")
    }

    @NSManaged public var name: String?
    @NSManaged public var routine: NSSet?

}

// MARK: Generated accessors for routine
extension ActiveRoutine {

    @objc(addRoutineObject:)
    @NSManaged public func addToRoutine(_ value: Routine)

    @objc(removeRoutineObject:)
    @NSManaged public func removeFromRoutine(_ value: Routine)

    @objc(addRoutine:)
    @NSManaged public func addToRoutine(_ values: NSSet)

    @objc(removeRoutine:)
    @NSManaged public func removeFromRoutine(_ values: NSSet)

}
