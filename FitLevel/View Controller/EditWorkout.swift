//
//  EditWorkout.swift
//  FitLevel
//
//  Created by Jacky Eng on 09/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class EditWorkout: UIViewController, UITextFieldDelegate, CustomWorkoutDelegate, DatabaseListener {
    var listenerType: ListenerType = .workout
    
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine]) {
        
    }
    
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout]) {
        
    }
    
    func onRoutineWorkoutChange(change: DatabaseChange, workouts: [CustomWorkout]) {
        
    }
    
    
    weak var customDelegate: CustomWorkoutDelegate?
    var workout: Workout?
    var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var sets: UITextField!
    @IBOutlet weak var reps: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sets.delegate = self
        reps.delegate = self
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
        let customWorkout = databaseController?.addCustomWorkout(set: sets.text!, repetition: reps.text!)
        
    }
}
