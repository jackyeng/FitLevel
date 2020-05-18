//
//  Workout+CoreDataProperties.swift
//  FitLevel
//
//  Created by Jacky Eng on 18/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var level: Int16
    @NSManaged public var name: String?
    @NSManaged public var repetition: Int16
    @NSManaged public var set: Int16
    @NSManaged public var image: String?
    @NSManaged public var plan: Plan?
    @NSManaged public var routine: Routine?

}
