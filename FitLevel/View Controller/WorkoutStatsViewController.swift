//
//  WorkoutStatsViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 09/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class WorkoutStatsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, DatabaseListener{
    
    var listenerType: ListenerType = .workoutstats
    

    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout]) {
        self.workouts = workouts
    }
    
    
    @IBOutlet weak var WorkoutStats: UICollectionView!
    var databaseController: DatabaseProtocol?

    var workouts = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.systemIndigo
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        WorkoutStats.dataSource = self
        WorkoutStats.delegate = self
        
        //set image in title
        self.navigationItem.titleView = navTitleWithImageAndText(titleText: "Workout Stats", imageName: "titleicon.png")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
     
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workouts.count
        }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutStats", for: indexPath) as! WorkoutStatsCollectionViewCell
        
        //show cell background color to mark calender
        if cell.isHidden{
            cell.isHidden = false
        }
        
        cell.levelLabel.text = String(workouts[indexPath.row].level)
        
        cell.workoutNameLabel.text = String(workouts[indexPath.row].name!)
        cell.workoutNameLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.workoutNameLabel?.numberOfLines = 0
        
        //Sets the workout rank circle
        let image : UIImage = UIImage(named:"bronze")!
        cell.WorkoutStatImage.image = image
        
        return cell
    }
    
    
    //Unused
    func onRoutineWorkoutChange(change: DatabaseChange, workout: [CustomWorkout]) {
           
       }
       
    func onPlanListChange(change: DatabaseChange, recommendedPlan: [Routine]) {
           
       }
       
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine]) {
           
       }
    
    }
    


    //https://stackoverflow.com/questions/24803178/navigation-bar-with-uiimage-for-title
    func navTitleWithImageAndText(titleText: String, imageName: String) -> UIView {

        // Creates a new UIView
        let titleView = UIView()

        // Creates a new text label
        let label = UILabel()
        label.text = titleText
        label.sizeToFit()
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center

        // Creates the image view
        let image = UIImageView()
        image.image = UIImage(named: imageName)

        // Maintains the image's aspect ratio:
        let imageAspect = image.image!.size.width / image.image!.size.height

        // Sets the image frame so that it's immediately before the text:
        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect
        let imageY = label.frame.origin.y

        let imageWidth = label.frame.size.height * imageAspect + 30
        let imageHeight = label.frame.size.height + 30

        image.frame = CGRect(x: imageX-20, y: imageY-20, width: imageWidth, height: imageHeight)

        image.contentMode = UIView.ContentMode.scaleAspectFit

        // Adds both the label and image view to the titleView
        titleView.addSubview(label)
        titleView.addSubview(image)

        // Sets the titleView frame to fit within the UINavigation Title
        titleView.sizeToFit()

        return titleView

    }
    
    
