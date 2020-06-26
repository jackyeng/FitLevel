//
//  CustomWorkoutDelegate.swift
//  FitLevel
//
//  Created by Jacky Eng on 21/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import Foundation


protocol CustomWorkoutDelegate: AnyObject {
        func addWorkout( custom: CustomWorkout) -> Bool
        func editWorkout(updatedWorkout: CustomWorkout, index_info: IndexPath ) -> Bool
}
