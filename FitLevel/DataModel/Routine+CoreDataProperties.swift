//
//  Routine+CoreDataProperties.swift
//  FitLevel
//
//  Created by Jacky Eng on 10/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//
//

import Foundation
import CoreData


extension Routine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: String?
    @NSManaged public var workout: Workout?

}
