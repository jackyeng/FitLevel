//
//  WorkoutData.swift
//  FitLevel
//
//  Created by Jacky Eng on 17/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class WorkoutData: NSObject, Decodable{

    var imageURL: String?

     private enum RootKeys: String, CodingKey {
        case image
        
        
     }
   
     required init(from decoder: Decoder) throws {
        let workoutContainer = try decoder.container(keyedBy: RootKeys.self)

        imageURL = try workoutContainer.decode(String.self, forKey: .image)
    
        
    }
    

        
}
    
