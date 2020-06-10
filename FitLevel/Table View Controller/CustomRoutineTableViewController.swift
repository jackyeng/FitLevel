//
//  CustomRoutineTableViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 21/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class CustomRoutineTableViewController: UITableViewController, EditRoutineNameDelegate, CustomWorkoutDelegate {
    
    
    func addWorkout(custom: CustomWorkout) -> Bool {
        workouts.append(custom)
        tableView.reloadData()
        return true
    }
    
    
    
    func editName(Name: String) -> Bool {
        routinename = Name //update cocktail name when returning from edit instruction screen
        tableView.reloadData()
        return true
    }
    
    var databaseController: DatabaseProtocol?
    
    let section_routinename = 0
    let section_workoutlist = 1
    let section_addworkout = 2

    let section_name = "ROUTINE NAME:"
    let section_workout = "WORKOUT LIST:"
    

    let cell_routinename = "routineName"
    let cell_workoutlist = "workoutList"
    let cell_addworkout = "addWorkout"
    
    var routinename = ""
    var workouts = [CustomWorkout]()
    
    @IBOutlet weak var workoutLabel: UILabel!
    
    
    
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
        return 3    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == section_workoutlist{
            return workouts.count //comment
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
               switch section{
               case section_routinename:
                   return section_name
               case section_workoutlist:
                   return section_workout
               default:
                   return nil
               
           }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
                case section_routinename:
                    let cell = tableView.dequeueReusableCell(withIdentifier: cell_routinename, for: indexPath)
                    cell.textLabel?.textColor = .black
                    cell.selectionStyle = .none
                    cell.textLabel?.text = routinename
                    cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                    cell.textLabel?.numberOfLines = 0
    
                    return cell
        
                case section_workoutlist:
                    let cell =
                    tableView.dequeueReusableCell(withIdentifier: cell_workoutlist, for: indexPath)
                    as! WorkoutTableViewCell
                    let workout = workouts[indexPath.row]
                    
                    cell.CustomWorkoutLabel.text = workout.workout?.name!
                
                    return cell
            
                case section_addworkout:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: cell_addworkout, for: indexPath)
                    cell.textLabel?.textColor = .secondaryLabel //secondaryLabel
                    cell.selectionStyle = .none
                    cell.textLabel?.text = "Add Workout"
                    cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                    cell.textLabel?.numberOfLines = 0
                  
    
                    return cell
           
                
                   
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: cell_routinename, for: indexPath)
                    return cell
                
            }
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

    @IBAction func CreateRoutine(_ sender: Any) {
        print(routinename)
        print(workouts.count)
        if routinename != "" && workouts.count != 0  { //validate that informations for the cocktail are filled
            
            
            let routine = databaseController?.addRoutine(routineName: routinename)
            let _ = databaseController?.addRoutineToActive(routine: routine!, active: databaseController!.activeRoutine)
            
            for workout in workouts{
                let _ = databaseController?.addCustomWorkoutToRoutine(customWorkout: workout, routine: routine!)
            }
            
            databaseController?.saveDraft() //save informations to child context and then to persistent container.
            
          
            self.navigationController!.popToRootViewController(animated: true)
            return
           
        }

        var errorMsg = "Please ensure all fields are filled:\n"

        if routinename == "" {
            errorMsg += "- Must provide routine name\n"
        }
        if workouts.count == 0 {
            errorMsg += "- Must provide a workout\n"
        
        
        }
        displayMessage(title: "Not all fields filled", message: errorMsg)
    }
    
        func displayMessage(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message,
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style:
                UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "editName":
            let destination = segue.destination as! EditRoutineNameViewController
            destination.nameDelegate = self
        case "addWorkout":
            let destination = segue.destination as! WorkoutListTableViewController
            destination.workoutDelegate = self
        default:
            return
        }
    }
    

}
