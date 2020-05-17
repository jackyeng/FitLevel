//
//  HomeScreenViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 12/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

//https://www.youtube.com/watch?v=0o06EIPY0JI by Asterios R.
class HomeScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    
    @IBOutlet weak var Calender: UICollectionView!
    
    @IBOutlet weak var MonthLabel: UILabel!
    
    @IBOutlet weak var TopWorkout: UILabel!
    
    
    let Months = ["January","February", "March", "April", "May", "June","July","August","September", "October", "November" ,"December"]
    let DaysOfMonth = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    
    var currentMonth = String()
    
    var NumberOfEmptyBox = Int() //The number of empty boxes at the start of the current month
    
    var NextNumberOfEmptyBox = Int()
    
    var PreviousNumberOfEmptyBox = 0
    
    var Direction = 0
    
    var PositionIndex = 0
    
    var dayCounter = 0
    
    var LeapYearCounter = 0
    
    
    
    
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           navigationController?.navigationBar.barTintColor = UIColor.systemIndigo
           currentMonth = Months[month]
        
            MonthLabel.text = "\(currentMonth) \(year)"
            MonthLabel.center = CGPoint(x: 207, y: 133)
            MonthLabel.textAlignment = .center
        
        if weekday == 0{
            weekday = 7
        }
        GetStartDateDayPosition()
        
        TopWorkout.layer.cornerRadius = 15
        TopWorkout.layer.masksToBounds = true
        
       }
       
    
    @IBAction func Next(_ sender: Any) {
        switch currentMonth{
        case "December":
            month = 0
            year += 1
            Direction = 1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calender.reloadData()
      
            
            
        default:
            
            Direction = 1
            
            GetStartDateDayPosition()
            month += 1
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calender.reloadData()
        
            
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        switch currentMonth{
        case "January":
            month = 11
            year -= 1
            
            Direction = -1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calender.reloadData()

           
            
        default:
            month -= 1
            Direction = -1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calender.reloadData()
     
           
        
    }
    }
    
    
    func GetStartDateDayPosition(){
        switch Direction{
        case 0:
            NumberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter > 0 {
                NumberOfEmptyBox = NumberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if NumberOfEmptyBox == 0 {
                    NumberOfEmptyBox = 7
                }
                
            }
            if NumberOfEmptyBox == 7 {
                NumberOfEmptyBox = 0
            }
            /*switch day{
            case 1...7:
                NumberOfEmptyBox = weekday - day
            case 8...14:
                NumberOfEmptyBox = weekday - day - 7
            case 15...21:
                NumberOfEmptyBox = weekday - day - 14
            case 22...28:
                NumberOfEmptyBox = weekday - day - 21
            case 29...31:
                NumberOfEmptyBox = weekday - day - 28
            default:
                break
            }*/
            PositionIndex = NumberOfEmptyBox
        case 1...:
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
            PositionIndex = NextNumberOfEmptyBox
        case -1:
            PreviousNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex)%7)
            if PreviousNumberOfEmptyBox == 7 {
                PreviousNumberOfEmptyBox = 0
            }
            PositionIndex = PreviousNumberOfEmptyBox
        default:
            fatalError()
    
        }
        
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction{
        case 0:
            return DaysInMonths[month] + NumberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + NextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calender", for: indexPath) as! DateCollectionViewCell
        
        cell.backgroundColor = UIColor.clear
        
        
        cell.layer.cornerRadius = 25
        cell.layer.masksToBounds = true
        
        if cell.isHidden{
            cell.isHidden = false
        }
        switch Direction{
        case 0:
            cell.DateLabel.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
        case 1...:
            cell.DateLabel.text = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
        case -1:
            cell.DateLabel.text = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        switch cell.DateLabel.text{
        case "5":
            cell.backgroundColor = UIColor.systemIndigo
        case "9":
            cell.backgroundColor = UIColor.systemIndigo
        case "21":
            cell.backgroundColor = UIColor.systemIndigo
        default:
            break
        }
        
        if Int(cell.DateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        cell.DateLabel.textAlignment = .center
        return cell
    }
    
    
}
