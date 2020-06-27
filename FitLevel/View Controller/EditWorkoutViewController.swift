//
//  EditWorkoutViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 09/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class EditWorkoutViewController: UIViewController, UITextFieldDelegate, DatabaseListener {
    
    var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .workout
    weak var customDelegate: CustomWorkoutDelegate?
    var workout: Workout?
    var customworkout: CustomWorkout?
    var isEdit = false
    var isPreview = false
    var indexpath: IndexPath?
    
    
    @IBOutlet weak var durationLabel: UITextField!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        // Do any additional setup after loading the view.
        durationLabel.delegate = self
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    //Allows user to save their workout once a duration is set
    @IBAction func addWorkout(_ sender: Any) {
        
        if durationLabel.text != "" && durationLabel.text!.isInt {  //only allow save when user enter text
            
            //If in Edit Mode, then only make changes to the CustomWorkout Object passed into this class and pop view ontroller.
            if isEdit{
                customworkout?.duration = durationLabel.text!
                let _ = customDelegate?.editWorkout(updatedWorkout: customworkout!, index_info: indexpath!)
                
            }
            //If not in Edit Mode, then add new CustomWorkout object to the Persistent Storage and give it a duration.
            else{
            
            let customWorkout = databaseController?.addCustomWorkout(set: "", repetition: "", duration: durationLabel.text!)
            let _ = databaseController?.addWorkoutToCustomWorkout(workout: workout!, customWorkout: customWorkout!)
            
            let _ = customDelegate?.addWorkout(custom: customWorkout!)
            
            }
            
            //Pop view controller to return to Preview screen.
            if isPreview{
                navigationController?.popViewController(animated: true)
                return
            }
            
            //search through the view controllers for CustomRoutineTableViewController to pop to it
            for vc in self.navigationController!.viewControllers {
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
        if durationLabel.text?.isInt == false {
            errorMsg += "- Input must be an integer\n"
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
    
    
    //Unused
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine]) {
        
    }
    
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout]) {
        
    }
    
    func onRoutineWorkoutChange(change: DatabaseChange, workout: [CustomWorkout]) {
        
    }
    
    func onPlanListChange(change: DatabaseChange, recommendedPlan: [Routine]) {
        
    }
}

//https://stackoverflow.com/questions/38159397/how-to-check-if-a-string-is-an-int-in-swift
extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
