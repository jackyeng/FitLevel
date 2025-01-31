//
//  RoutinePreviewTableViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 21/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class RoutinePreviewTableViewController: UITableViewController, WorkoutRoutineDelegate,CustomWorkoutDelegate, DatabaseListener {
    func addWorkout(custom: CustomWorkout) -> Bool {
        return true
    }
    
    //Update workout that has been edited
    func editWorkout(updatedWorkout: CustomWorkout, index_info: IndexPath) -> Bool {
        workouts[index_info.row] = updatedWorkout
        tableView.performBatchUpdates({
            tableView.reloadSections([section_workout], with: .automatic) //READ THIS
        }, completion: nil)
        return true
   
    }
    
    
    var workouts = [CustomWorkout]()
    var section_workout = 0
    var cell_workout = "workoutPreview"

    var listenerType: ListenerType = .routineworkout
    var databaseController: DatabaseProtocol?
    weak var workoutDelegate: WorkoutRoutineDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
       
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        databaseController?.saveDraft()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_workout, for: indexPath) as! WorkoutTableViewCell
        
        switch indexPath.section {
            case section_workout:
                let cell = tableView.dequeueReusableCell(withIdentifier: cell_workout, for: indexPath) as! WorkoutTableViewCell
                cell.nameLabel.text = workouts[indexPath.row].workout?.name!
                
                //Display current workout level
                if let level = workouts[indexPath.row].workout?.level {
                   cell.levelLabel.text = "Level: " + String(level)
                }
                else{
                   cell.levelLabel.text = "Level: Unknown";
                }
    
                cell.durationLabel.text = "Duration: " + workouts[indexPath.row].duration!
                cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                cell.textLabel?.numberOfLines = 0
                return cell
               
            default:
                return cell
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
            case "workoutRoutine":
                let destination = segue.destination as! WorkoutRoutineViewController
                    destination.workoutDelegate = self
                    destination.workouts = workouts
            case "editWorkout":
                if let indexPath = tableView.indexPathForSelectedRow{
                    let destination = segue.destination as! EditWorkoutViewController
                    destination.indexpath = indexPath
                    destination.customDelegate = self
                    destination.customworkout = workouts[indexPath.row]
                    destination.isEdit = true
                    destination.isPreview = true //Inform destination view controller that it is being accessed from previewtableviewcontroller.
            }
            
            default:
                return
        }
    }
    
    
    //Unused
    func onPlanListChange(change: DatabaseChange, recommendedPlan: [Routine]) {
        
    }
    
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine]) {
        
    }
    
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout]) {
        
    }
    
    func onRoutineWorkoutChange(change: DatabaseChange, workout: [CustomWorkout]) {
        
    }
}
