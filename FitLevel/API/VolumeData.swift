//
//  VolumeData.swift
//  FitLevel
//
//  Created by Jacky Eng on 17/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//


import UIKit

class VolumeData: NSObject, Decodable {
    var Workout: [WorkoutData]?
    
 private enum CodingKeys: String, CodingKey {
    case Workout = "results"

 }
}
