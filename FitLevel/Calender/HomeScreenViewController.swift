//
//  HomeScreenViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 12/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

//https://www.youtube.com/watch?v=0o06EIPY0JI by Asterios R.
class HomeScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,DatabaseListener {
    
    var listenerType: ListenerType = .workoutstats
    
   
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout]) {
        self.workouts = workouts
    }
    
    
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var calenderFrame: UITextView!
   
    var workoutlist = [WorkoutData]()
    var workouts = [Workout]()
    
    @IBOutlet weak var Calender: UICollectionView!
    @IBOutlet weak var WorkoutStats: UICollectionView!
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
    
    var DateCheck = [Int](repeating: 0, count:32)
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        displayProgress(year: year, month: month + 1)
        calenderFrame.isUserInteractionEnabled = false
        Calender.reloadData()
        WorkoutStats.reloadData()
        
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        WorkoutStats.delegate = self
        WorkoutStats.dataSource = self
        self.calenderFrame.layer.borderColor = UIColor.black.cgColor
        self.calenderFrame.layer.borderWidth = 3
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        navigationController?.navigationBar.barTintColor = UIColor.systemIndigo //systemindigo
        currentMonth = Months[month]
        
        MonthLabel.text = "\(currentMonth) \(year)"
        MonthLabel.center = CGPoint(x: 207, y: 133)
        MonthLabel.textAlignment = .center
        
        if weekday == 0{
            weekday = 7
        }
        GetStartDateDayPosition()
        displayProgress(year: year, month: month + 1)
        
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
            displayProgress(year: year, month: month + 1)
            Calender.reloadData()

        default:
            
            Direction = 1
    
            GetStartDateDayPosition()
            month += 1
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            displayProgress(year: year, month: month + 1)
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
            displayProgress(year: year, month: month + 1)
            Calender.reloadData()

        default:
            month -= 1
            Direction = -1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            displayProgress(year: year, month: month + 1)
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
        if collectionView == self.Calender {
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
        else{
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.Calender {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calender", for: indexPath) as! DateCollectionViewCell
        
            cell.backgroundColor = UIColor.clear
            cell.layer.cornerRadius = 18
            cell.layer.masksToBounds = true
        
            //Show cell background to mark calender
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
        
        
            if (Int(cell.DateLabel.text!)! > 0) && DateCheck[Int(cell.DateLabel.text!)!] == 1{
                cell.backgroundColor = UIColor.systemIndigo //systemindigo
            
            }
            if Int(cell.DateLabel.text!)! < 1 {
                cell.isHidden = true
            }
            cell.DateLabel.textAlignment = .center
            return cell
        }
            
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topWorkout", for: indexPath) as! WorkoutStatsCollectionViewCell
            if cell.isHidden{
                      cell.isHidden = false
                  }
            
            //Display Top Workout Information
            if workouts.count != 0{
                cell.levelLabel.text = String(workouts[indexPath.row].level)
                cell.workoutNameLabel.text = workouts[indexPath.row].name
            }
            else{
                cell.levelLabel.text = "?"
                cell.workoutNameLabel.text = "???"
            }
           cell.workoutNameLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
           cell.workoutNameLabel?.numberOfLines = 0
            
           //Set workout rank
           switch workouts[indexPath.row].level{
           case 1..<10:
               let image : UIImage = UIImage(named:"bronze")!
               cell.WorkoutStatImage.image = image
           case 10..<20:
               let image : UIImage = UIImage(named:"silver")!
               cell.WorkoutStatImage.image = image
           default:
               let image : UIImage = UIImage(named:"goldcircle")!
               cell.WorkoutStatImage.image = image
               
           }
           return cell
        }

    }
    
   
    
    func displayProgress(year: Int, month: Int){
        DateCheck = [Int](repeating: 0, count:32)
        let workoutProgress = databaseController?.getWorkoutDate(year: year, month: month)
        
        for date in workoutProgress!{
            DateCheck[Int(date.day)] = 1
        }
        
    }
    
    
   //UNUSED
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine]) {
           
       }
       
    func onRoutineWorkoutChange(change: DatabaseChange, workout: [CustomWorkout]) {
           
       }
       
    func onPlanListChange(change: DatabaseChange, recommendedPlan: [Routine]) {
           
       }

    }
    

