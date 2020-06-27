//
//  WorkoutListTableViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 09/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class WorkoutListTableViewController: UITableViewController, DatabaseListener, CustomWorkoutDelegate {
    func editWorkout(updatedWorkout: CustomWorkout, index_info: IndexPath) -> Bool {
        return true
    }
    
    
    func addWorkout(custom: CustomWorkout) -> Bool {
        return true
    }
    
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout]) {
        workout = workouts
    }
   
    
    var listenerType: ListenerType = .workout
    weak var workoutDelegate: CustomWorkoutDelegate?
    var databaseController: DatabaseProtocol?
    var workout = [Workout]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController


    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workout", for: indexPath) as! WorkoutTableViewCell
      
          cell.WorkoutNameLabel.text = workout[indexPath.row].name
        
          cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
          cell.textLabel?.numberOfLines = 0
          return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         databaseController?.addListener(listener: self)
     
    }

     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         databaseController?.removeListener(listener: self)
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier { 
        case "customWorkout":
            if let indexPath = tableView.indexPathForSelectedRow{
                let destination = segue.destination as! EditWorkoutViewController
                destination.customDelegate = workoutDelegate
                destination.workout = self.workout[indexPath.row]
                
                databaseController?.saveDraft()
        
            }
        
        default:
            return
        }
    }
    
    
    //Unused
    
    func onPlanListChange(change: DatabaseChange, recommendedPlan: [Routine]) {
           
       }
       
    func onRoutineWorkoutChange(change: DatabaseChange, workout: [CustomWorkout]) {
           
       }
       
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine]) {
           
       }
}
