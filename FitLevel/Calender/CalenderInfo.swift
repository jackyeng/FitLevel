//
//  CalenderInfo.swift
//  FitLevel
//
//  Created by Jacky Eng on 13/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import Foundation

let date = Date()
let calender = Calendar.current

let day = calender.component(.day, from: date)
var weekday = calender.component(.weekday, from: date) - 1
var month = calender.component(.month, from: date) - 1
var year = calender.component(.year, from: date)
