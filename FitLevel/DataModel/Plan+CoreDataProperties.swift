//
//  Plan+CoreDataProperties.swift
//  FitLevel
//
//  Created by Jacky Eng on 10/05/2020.
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
    @NSManaged public var workout: Workout?

}
