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
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var calenderFrame: UITextView!
    
    var workoutlinks = ["https://wger.de/media/exercise-images/6/Leg-press-2-1024x670.png",
        "https://wger.de/media/exercise-images/177/Seated-leg-curl-1.png",
    "https://wger.de/media/exercise-images/26/Biceps-curl-1.png",
    "https://wger.de/media/exercise-images/82/Tricep-dips-2-2.png",

    "https://wger.de/media/exercise-images/244/Close-grip-front-lat-pull-down-2.png"]
    
    var workoutlist = [WorkoutData]()
    
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
    
    var DateCheck = [Int](repeating: 0, count:32)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.calenderFrame.layer.borderColor = UIColor.black.cgColor
        self.calenderFrame.layer.borderWidth = 3
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        navigationController?.navigationBar.barTintColor = UIColor.systemIndigo
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
        
        
        requestWorkoutImage()
        
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
        
        
        cell.layer.cornerRadius = 18
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
        
        
        
        if (Int(cell.DateLabel.text!)! > 0) && DateCheck[Int(cell.DateLabel.text!)!] == 1{
            cell.backgroundColor = UIColor.systemIndigo
            
        }
        if Int(cell.DateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        cell.DateLabel.textAlignment = .center
     
        return cell
    }
    
    func displayTopWorkout(){
        //Top Workout
        let coordinate = CGPoint(x:207,y:338)
        //create my track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: coordinate, radius: 100, startAngle: -CGFloat.pi / 2 , endAngle: 2 * CGFloat.pi, clockwise: true)
               
        trackLayer.path = circularPath.cgPath
               
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.white.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        view.layer.addSublayer(trackLayer)
        
    }
    
    func displayProgress(year: Int, month: Int){
        DateCheck = [Int](repeating: 0, count:32)
        let workoutProgress = databaseController?.getWorkoutDate(year: year, month: month)
        
        for date in workoutProgress!{
            DateCheck[Int(date.day)] = 1
        }
        
    }
    
    
    //Workout image API does not have name
    //The name of the workout is in the workout image link
    //the function filter out the name and associate it with the image
    @IBAction func WorkoutName(_ sender: Any) {
    
    
        let workout = databaseController?.addRoutine(routineName: "")
        let workout1 = databaseController?.addWorkout(name: "test", imageURL: "")
        let workouts = databaseController?.addCustomWorkout(set:"1", repetition: "3")
        let _ = databaseController?.addCustomWorkoutToRoutine(customWorkout: workouts!, routine: workout!)
        let _ = databaseController?.addWorkoutToCustomWorkout(workout: workout1!, customWorkout: workouts!)
        let _ = databaseController?.addRoutineToActive(routine: workout!, active: databaseController!.activeRoutine)
        
        databaseController?.saveDraft()
        
        
        
        
        return
        
        for i in workoutlist{
            print(i.imageURL!)
        }
        
        for i in workoutlinks{
            let mySubstring = i
            var startindex = 0
            var endindex = -1
            for (index,char) in mySubstring.enumerated(){
             
                if char.isUppercase{
                   startindex = index
                }
                if char.isNumber{
                    if (startindex != 0 && endindex == -1){
                        endindex = index
                    }
                    
                }
            
            }
            endindex -= (mySubstring.count + 1)
            let start = i.index(i.startIndex, offsetBy: startindex)
            let end = i.index(i.endIndex, offsetBy: endindex)
            let range = start..<end
            let finalstring = String(mySubstring[range])
            print(finalstring)
            
            var workoutname = ""
            for char in finalstring{
                if char == "-"{
                    workoutname += " "
                    
                }
                else{
                 workoutname += String(char)
            }
                }
            print(workoutname)
            }
            
            
        }
    
    
    func requestWorkoutImage() {
        let searchString = "https://wger.de/api/v2/exerciseimage.json/?is_main=True&language=2&page=9"
        let jsonURL =
            URL(string: searchString.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)!)

        let task = URLSession.shared.dataTask(with: jsonURL!) {
        (data, response, error) in
        // Regardless of response end the loading icon from the main thread
        DispatchQueue.main.async {
            
        }

        if let error = error {
            print(error)
            return
        }

        do {
            let decoder = JSONDecoder()
            let volumeData = try decoder.decode(VolumeData.self, from: data!)
            if let workouts = volumeData.Workout { //change
                self.workoutlist.append(contentsOf: workouts) //change
             
                DispatchQueue.main.async {
                    
                }
            }
        } catch let err {
            print(err)
        }
        }

        task.resume()
    
        }
    }
    

