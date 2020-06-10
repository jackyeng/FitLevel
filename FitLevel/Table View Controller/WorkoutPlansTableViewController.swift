//
//  WorkoutPlansTableViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 09/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class WorkoutPlansTableViewController: UITableViewController, DatabaseListener, WorkoutRoutineDelegate {
    func onPlanListChange(change: DatabaseChange, recommendedPlan: [Routine]) {
        routines = recommendedPlan
        for i in routines{
            print(i)
        }
    }
    
    func onRoutineWorkoutChange(change: DatabaseChange, workout: [CustomWorkout]) {
        
    }
    
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine]) {
        
    }
    
    var listenerType: ListenerType = .plan
    
    @IBOutlet weak var PlanName: UILabel!
    
    var routines = [Routine]()
    var databaseController: DatabaseProtocol?
    
    var plan = ["1","2","3"]
    var beginnercell = "beginner"
    
 
    
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout]) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return routines.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "routine", for: indexPath) as! RoutineTableViewCell
        let cell =
            tableView.dequeueReusableCell(withIdentifier: beginnercell, for: indexPath)
            as! PlanTableViewCell
        //let workout = plan[indexPath.row]
        cell.PlanNameLabel.text = routines[indexPath.row].name //display cocktails in My Drink
      
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 0
        return cell //display cocktails in My Drink

    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           databaseController?.addListener(listener: self)
           
       }

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           databaseController?.removeListener(listener: self)
       }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier { //comment
        case "routinePreview":
            if let indexPath = tableView.indexPathForSelectedRow{
            let destination = segue.destination as! RoutinePreviewTableViewController
                destination.workoutDelegate = self
               
                destination.workouts = (databaseController?.getRoutineWorkout(name: routines[indexPath.row].name!))!
            }
        
        default:
            return
    }
    
}
}
