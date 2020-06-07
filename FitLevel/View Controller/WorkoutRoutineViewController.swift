//
//  WorkoutRoutineViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 11/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class WorkoutRoutineViewController: UIViewController, DatabaseListener, WorkoutRoutineDelegate {
    
    
    func onRoutineWorkoutChange(change: DatabaseChange, workouts: [CustomWorkout]) {
        workoutss = workouts
    }
    
    
    
    //https://www.youtube.com/watch?v=O3ltwjDJaMk
    let shapeLayer = CAShapeLayer()
   
    var workouts = [WorkoutClass(name:"Inclined Push-Ups",sets:"1",reps:"1"),WorkoutClass(name:"Inclined Plank",sets:"2",reps:"2"),WorkoutClass(name:"Inclined Barbell Push",sets:"3",reps:"3"),WorkoutClass(name:"Squat",sets:"4",reps:"4")]
    
    var workoutss = [CustomWorkout]()
    weak var workoutDelegate: WorkoutRoutineDelegate?
    var listenerType: ListenerType = .routineworkout
    var workoutprogress = 0
    var workoutcount = 3
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var workoutSets: UILabel!
    @IBOutlet weak var workoutReps: UILabel!
    @IBOutlet weak var CompleteButton: UIButton!
    
    
    @IBOutlet weak var ImageView: UIImageView!
    
    var actionStatus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(workoutss.count)
        print(workoutss[workoutprogress].workout!)
        
     
        
               
        
        
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        
        //Initialize title
        workoutName.text = workoutss[workoutprogress].workout!.name
        workoutSets.text = "Sets: " + workoutss[workoutprogress].set!
        workoutReps.text = "Reps: " + workoutss[workoutprogress].repetition!
        
        
        //Allignment
        workoutName.textAlignment = .center
        workoutSets.textAlignment = .center
        workoutReps.textAlignment = .center

        workoutName.center = CGPoint(x: 207, y: 200)
        workoutSets.center = CGPoint(x: 207, y: 480)
        workoutReps.center = CGPoint(x: 207, y: 510)
        CompleteButton.center = CGPoint(x: 207, y: 638)
        
        CompleteButton.layer.borderWidth = 1
        CompleteButton.layer.cornerRadius = 20
        
    }
    
    
    @objc private func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func Complete(_ sender: Any) {
        workoutprogress += 1
        
        if !actionStatus  {
            return
        }
        actionStatus = false
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
    
        shapeLayer.add(basicAnimation, forKey: "Basic")
        
        //https://stackoverflow.com/questions/28821722/delaying-function-in-swift/28821805#28821805
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
            self.updateWorkout()
            self.actionStatus = true
        })
        
    }
    
    func updateWorkout(){
        
        
        if workoutprogress > workoutcount-1{
            displayMessage(title: "Congratulation!", message: "You have completed your workout.")
            return
        }
       
        workoutName.text = workoutss[workoutprogress].workout!.name
        workoutSets.text = "Sets: " + workoutss[workoutprogress].set!
        workoutReps.text = "Reps: " + workoutss[workoutprogress].repetition!
        
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Done",
                                                style: UIAlertAction.Style.default,
                                                handler: {(alert: UIAlertAction!) in self.popViewController()}))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func popViewController(){
        self.navigationController?.popViewController(animated: false)
    }
    
    
    
    //https://www.youtube.com/watch?time_continue=128&v=Z6D68MMx2pw&feature=emb_logo
    func get_image(_ url_str:String, _ ImageView:UIImageView){
        let url:URL = URL(string: url_str)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                let image = UIImage(data: data!)
                if(image != nil)
                {
                    DispatchQueue.main.async(execute: {
                        ImageView.image = image
                
                    })
                }
            }
        })
        task.resume()
    }
    
    //unused
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine]) {
           
       }
       
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout]) {
           
       }
    func onPlanListChange(change: DatabaseChange, recommendedPlan: [Routine]) {
        
    }
}
