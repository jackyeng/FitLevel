//
//  EditWorkoutDelegate.swift
//  FitLevel
//
//  Created by Jacky Eng on 10/06/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import Foundation

protocol EditWorkoutDelegate: AnyObject {
   
    func editWorkout( duration: String) -> Bool
}
