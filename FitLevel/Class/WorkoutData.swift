//
//  Workout.swift
//  FitLevel
//
//  Created by Jacky Eng on 11/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class WorkoutData: NSObject {
    
    var name: String
    var sets: String
    var reps: String
    
    init(name:String, sets:String, reps:String) {
        self.name = name
        self.sets = sets
        self.reps = reps
    }

}
