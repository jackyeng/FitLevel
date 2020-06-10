//
//  WorkoutRoutineViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 11/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

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
    
    //Video
    let date = Date()
    let calender = Calendar.current
    var  player: AVPlayer?
    var playerViewController: AVPlayerViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let videoURL = Bundle.main.url(forResource: workouts[0].workout?.name, withExtension: "mp4") else {
            print("Couldn't load video")
            return
        }
        player = AVPlayer(url: videoURL)
        playerViewController = AVPlayerViewController()
        
       
        counter = Int(workouts[workoutprogress].duration!)!
        workoutcount = workouts.count
        //https://stackoverflow.com/questions/29374553/how-can-i-make-a-countdown-with-nstimer
        countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
        
        handleTap()
        
        
        //Timer progress
        
        //let center = view.center
        let coordinate = CGPoint(x:207,y:550)
        //create my track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: coordinate, radius: 38, startAngle: -CGFloat.pi / 2 , endAngle: (2 * CGFloat.pi)-1.7, clockwise: true)
               
        // Create a completed circle layer
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 8
        trackLayer.fillColor = UIColor.white.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        // Create a second layer that completes a circle when called
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.systemIndigo.cgColor
        shapeLayer.lineWidth = 8
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        self.view.bringSubviewToFront(countDownLabel)
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        
        //Initialize title
        workoutName.text = workouts[workoutprogress].workout!.name
        if let level = workouts[workoutprogress].workout?.level{
            workoutLevel.text = "Level " + String(level)
        }
        else{
            workoutLevel.text = "Level: Unknown"
        }
      
        
        
        //Allignment
        workoutName.textAlignment = .center
        workoutLevel.textAlignment = .center
        countDownLabel.textAlignment = .center

        workoutName.center = CGPoint(x: 207, y: 165)
        workoutLevel.center = CGPoint(x: 207, y: 480)
       
        CompleteButton.center = CGPoint(x: 207, y: 638)
        
        CompleteButton.layer.borderWidth = 1
        CompleteButton.layer.cornerRadius = 20
        if let playerViewController = playerViewController {
                   playerViewController.player = player
                   
                   playerViewController.view.frame = CGRect(x: 35, y: 220, width: 350, height: 198)
                   view.addSubview(playerViewController.view)
                       addChild(playerViewController)
                   
                   playerViewController.showsPlaybackControls = false
               // Do any additional setup after loading the view.
                   //https://stackoverflow.com/questions/27808266/how-do-you-loop-avplayer-in-swift/27808482
                   playerViewController.player!.play()
                   NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
                   self?.player?.seek(to: CMTime.zero)
                   self?.player?.play()
                       
           
                       
               }
               }
        
    }
    
    
    @objc private func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 30
        
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
        //workoutDuration.text = "Duration: " + workouts[workoutprogress].duration!
        UpdateVideo((Any).self)
        counter = Int(workouts[workoutprogress].duration!)!
        handleTap()
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
    
    
    @IBAction func UpdateVideo(_ sender: Any) {
        guard let videoURL = Bundle.main.url(forResource: workouts[workoutprogress].workout!.name, withExtension: "mp4") else {
            print("Couldn't load video")
            return
        }
        player = AVPlayer(url: videoURL)
        playerViewController!.player = player
        playerViewController!.player!.play()
    }
    
    @objc func update() {
        if(counter > 0) {
            countDownLabel.text = String(counter)
            counter -= 1
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
