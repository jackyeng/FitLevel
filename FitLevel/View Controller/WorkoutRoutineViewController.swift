//
//  WorkoutRoutineViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 11/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class WorkoutRoutineViewController: UIViewController {
    //https://www.youtube.com/watch?v=O3ltwjDJaMk
    let shapeLayer = CAShapeLayer()
    //WorkoutData(name:"S",sets:"s",reps"s")
    var workouts = [WorkoutData(name:"Inclined Push-Ups",sets:"1",reps:"1"),WorkoutData(name:"Inclined Plank",sets:"2",reps:"2"),WorkoutData(name:"Inclined Barbell Push",sets:"3",reps:"3"),WorkoutData(name:"Squat",sets:"4",reps:"4")]
    
    var workoutprogress = 0
    var workoutcount = 3
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var workoutSets: UILabel!
    @IBOutlet weak var workoutReps: UILabel!
    @IBOutlet weak var CompleteButton: UIButton!
    
    var actionStatus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        //let center = view.center
        let coordinate = CGPoint(x:207,y:338)
        //create my track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: coordinate, radius: 100, startAngle: -CGFloat.pi / 2 , endAngle: 2 * CGFloat.pi, clockwise: true)
               
        trackLayer.path = circularPath.cgPath
               
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.systemIndigo.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        
        //Initialize title
        workoutName.text = workouts[workoutprogress].name
        workoutSets.text = "Sets: " + workouts[workoutprogress].sets
        workoutReps.text = "Reps: " + workouts[workoutprogress].reps
        
        
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
        
        workoutprogress += 1
        if workoutprogress > workoutcount{
            displayMessage(title: "Congratulation!", message: "You have completed your workout.")
            return
        }
        
        workoutName.text = workouts[workoutprogress].name
        workoutSets.text = "Sets: " + workouts[workoutprogress].sets
        workoutReps.text = "Reps: " + workouts[workoutprogress].reps
        
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
}
