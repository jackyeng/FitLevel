//
//  WorkoutDate+CoreDataProperties.swift
//  FitLevel
//
//  Created by Jacky Eng on 30/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//
//

import Foundation
import CoreData


extension WorkoutDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutDate> {
        return NSFetchRequest<WorkoutDate>(entityName: "WorkoutDate")
    }

    @NSManaged public var day: Int64
    @NSManaged public var month: Int64
    @NSManaged public var year: Int64

}
