//
//  WorkoutRoutineTableViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 09/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class WorkoutRoutineTableViewController: UITableViewController,WorkoutRoutineDelegate, DatabaseListener {
    
    
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine]) {
        routines = routineWorkouts
        self.tableView.reloadData()
    }
    
    var routines = [Routine]()
    
    var listenerType: ListenerType = .routine
    var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.systemIndigo //systemindigo
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell =
                   tableView.dequeueReusableCell(withIdentifier: "routine", for: indexPath)
                   as! RoutineTableViewCell
    
         cell.RoutineNameLabel.text = routines[indexPath.row].name!
             
         cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
         cell.textLabel?.numberOfLines = 0
         return cell
    }
    
    
    // Override to support conditional editing of the table view.
       override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           if indexPath.section == 0 {
               return true
           }
           return false
       }

       
       // Override to support editing the table view.
       override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete && indexPath.section == 0 {
            self.databaseController!.removeRoutinefromActive(active: databaseController!.activeRoutine, routine: routines[indexPath.row])
       
           }
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
        case "routinePreview":
            if let indexPath = tableView.indexPathForSelectedRow{
            let destination = segue.destination as! RoutinePreviewTableViewController
                destination.workoutDelegate = self
               //pass workouts list to be displayed in routine preview screen
                destination.workouts = (databaseController?.getRoutineWorkout(name: routines[indexPath.row].name!))!
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
    
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout]) {
           
       }
}
