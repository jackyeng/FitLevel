//
//  WorkoutRoutineViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 11/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class WorkoutRoutineViewController: UIViewController, DatabaseListener, WorkoutRoutineDelegate {
    
    
    func onRoutineWorkoutChange(change: DatabaseChange, workout: [CustomWorkout]) {
        workouts = workout
    }
    
    
    
    //https://www.youtube.com/watch?v=O3ltwjDJaMk
    let shapeLayer = CAShapeLayer()
   
    var workouts = [CustomWorkout]()
    weak var workoutDelegate: WorkoutRoutineDelegate?
    var listenerType: ListenerType = .routineworkout
    var workoutprogress = 0
    var workoutcount = 10
    @IBOutlet weak var workoutName: UILabel!
  
    
    @IBOutlet weak var workoutLevel: UILabel!
    @IBOutlet weak var workoutDuration: UILabel!
    
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var CompleteButton: UIButton!
    
    
    @IBOutlet weak var ImageView: UIImageView!
    
    
    var countTimer: Timer?
    
    var counter = 0
    var actionStatus = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        counter = Int(workouts[workoutprogress].duration!)!
        workoutcount = workouts.count
        //https://stackoverflow.com/questions/29374553/how-can-i-make-a-countdown-with-nstimer
        countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
        
        
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        
        //Initialize title
        workoutName.text = workouts[workoutprogress].workout!.name
        if let level = workouts[workoutprogress].workout?.level{
            workoutLevel.text = "Level: " + String(level)
        }
        else{
            workoutLevel.text = "Level: Unknown"
        }
        workoutDuration.text = "Duration: " + workouts[workoutprogress].duration!
        
        
        //Allignment
        workoutName.textAlignment = .center
        workoutLevel.textAlignment = .center
        workoutDuration.textAlignment = .center

        workoutName.center = CGPoint(x: 207, y: 200)
        workoutLevel.center = CGPoint(x: 207, y: 480)
        workoutDuration.center = CGPoint(x: 207, y: 510)
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
       
        workoutName.text = workouts[workoutprogress].workout!.name
    
        if let level = workouts[workoutprogress].workout?.level{
            workoutLevel.text = "Level: " + String(level)
        }
        else{
            workoutLevel.text = "Level: Unknown"
        }
        workoutDuration.text = "Duration: " + workouts[workoutprogress].duration!
        counter = Int(workouts[workoutprogress].duration!)!
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
    
    @objc func update() {
        if(counter > 0) {
            countDownLabel.text = String(counter)
            counter -= 2
           
        
        }
        else{
            
            Complete((Any).self)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.countTimer?.invalidate()
    }
    
    //unused
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine]) {
           
       }
       
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout]) {
           
       }
    func onPlanListChange(change: DatabaseChange, recommendedPlan: [Routine]) {
        
    }
}
