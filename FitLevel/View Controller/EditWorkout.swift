//
//  EditWorkout.swift
//  FitLevel
//
//  Created by Jacky Eng on 09/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class EditWorkout: UIViewController, UITextFieldDelegate, DatabaseListener {
    func onPlanListChange(change: DatabaseChange, recommendedPlan: [Routine]) {
        
    }
    
    var listenerType: ListenerType = .workout
    
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine]) {
        
    }
    
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout]) {
        
    }
    
    func onRoutineWorkoutChange(change: DatabaseChange, workout: [CustomWorkout]) {
        
    }
    
    @IBOutlet weak var durationLabel: UITextField!
    
    
    weak var customDelegate: CustomWorkoutDelegate?
    var workout: Workout?
    var databaseController: DatabaseProtocol?
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        durationLabel.delegate = self
   
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addWorkout(_ sender: Any) {
        
        
        if durationLabel.text != "" {  //only allow save when user enter text
            let customWorkout = databaseController?.addCustomWorkout(set: "", repetition: "", duration: durationLabel.text!)
            let _ = databaseController?.addWorkoutToCustomWorkout(workout: workout!, customWorkout: customWorkout!)
                let _ = customDelegate?.addWorkout(custom: customWorkout!)
            
                
                
            
                for vc in self.navigationController!.viewControllers { //search for My Drinks View Controller and pop to it.
                    if let myvc = vc as? CustomRoutineTableViewController{
                        self.navigationController?.popToViewController(myvc, animated: true)
                    }
                }
                return
            }

            var errorMsg = "Please ensure all fields are filled:\n"

            if durationLabel.text == "" {
            errorMsg += "- Must provide a duration\n"
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
    
}
