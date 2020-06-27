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
   
    weak var workoutDelegate: WorkoutRoutineDelegate?
    var listenerType: ListenerType = .routineworkout
    var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var workoutLevel: UILabel!
    @IBOutlet weak var workoutDuration: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var CompleteButton: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
    
    var countTimer: Timer?
    
    @IBOutlet weak var warmUpLabel1: UILabel!
    @IBOutlet weak var warmUpLabel2: UILabel!
    
    var workouts = [CustomWorkout]()
    var workoutprogress = 0
    var workoutcount = 10
    var counter = 0
    var actionStatus = true
    var warmupStatus = true
    var isPaused = false
    
    //Video
    let date = Date()
    let calender = Calendar.current
    var player: AVPlayer?
    var playerViewController: AVPlayerViewController?
    
    //Audio
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        //Audio initialisation
        playWorkoutAudio()
        
        //Video initialisation
        guard let videoURL = Bundle.main.url(forResource: workouts[workoutprogress].workout?.name, withExtension: "mp4") else {
            print("Couldn't load video")
            return
        }
        player = AVPlayer(url: videoURL)
        playerViewController = AVPlayerViewController()
        
        
        //WORKOUT INITIALISATION
        
        //Warm up message and counter initalisation
        warmUpLabel1.text = "Get"
        warmUpLabel2.text = "Ready"
        counter = 5
        
        workoutcount = workouts.count
        
        
        //https://stackoverflow.com/questions/29374553/how-can-i-make-a-countdown-with-nstimer
        //countdown timer initialisation
        countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
        countDownLabel.text = String(counter)
        
        //Start warmup timer
        handleTap(duration: 5)
        
        
        //TIMER PROGRESS BAR
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

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videoHandler)))
        
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
            
                //Loop AVPlayer
                //https://stackoverflow.com/questions/27808266/how-do-you-loop-avplayer-in-swift/27808482
                playerViewController.player!.play()
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
                self?.player?.seek(to: CMTime.zero)
                self?.player?.play()
                       
               }
            }
        
    }
    
    //This function gets the timer progress bar moving when the countdown starts to provide user with an aesthetic visualisation
    @objc private func handleTap(duration: Int) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(duration)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    
    //https://stackoverflow.com/questions/34735707/swift-pause-cabasicanimation-for-calayer
    @objc private func videoHandler(){
        if isPaused {
            player?.play()
            countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
            
            //Resume CAShapeLayer Animation
            let pausedTime = shapeLayer.timeOffset
            shapeLayer.speed = 1.0
            shapeLayer.timeOffset = 0.0
            shapeLayer.beginTime = 0.0
            let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            shapeLayer.beginTime = timeSincePause
            
            isPaused = false
        }
        else{
            player?.pause()
            self.countTimer?.invalidate()
            //Pause CAShapeLayer Animation
            let pausedTime : CFTimeInterval = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
            shapeLayer.speed = 0.0
            shapeLayer.timeOffset = pausedTime
            
            isPaused = true
        }
        
        
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
        warmupStatus = true
        
        warmUpLabel1.text = "Get"
        warmUpLabel2.text = "Ready"
        counter = 5
        handleTap(duration: 5)
        countDownLabel.text = String(counter)
        
        //https://stackoverflow.com/questions/28821722/delaying-function-in-swift/28821805#28821805
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
            self.updateWorkout()
            self.actionStatus = true
        })
        
    }
    
    //
    func updateWorkout(){
        //Ends routine when the last workout is completed
        if workoutprogress > workoutcount-1{
            self.countTimer?.invalidate()
            warmUpLabel1.text = ""
            warmUpLabel2.text = ""
            displayMessage(title: "Congratulation!", message: "You have completed your workout.")
            //Mark Calender with current date once completed workout
            let _ = databaseController?.addWorkoutDate(year: year, month: month+1, day: day)
            return
        }
        
        playWorkoutAudio()
        workoutName.text = workouts[workoutprogress].workout!.name
        
        //Display current workout level
        if let level = workouts[workoutprogress].workout?.level{
            workoutLevel.text = "Level " + String(level)
        }
        else{
            workoutLevel.text = "Level: Unknown"
        }
       
        UpdateVideo((Any).self)
        
    }
    
    //
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Done",
                                                style: UIAlertAction.Style.default,
                                                handler: {(alert: UIAlertAction!) in self.popViewController()}))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //
    func popViewController(){
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func UpdateVideo(_ sender: Any) {
        guard let videoURL = Bundle.main.url(forResource: workouts[workoutprogress].workout!.name, withExtension: "mp4") else {
            print("Couldn't load video")
            return
        }
        player = AVPlayer(url: videoURL)
        playerViewController!.player = player
        playerViewController!.player!.play()
        playerViewController!.player!.isMuted = true
        playerViewController!.player!.automaticallyWaitsToMinimizeStalling = false
        playerViewController!.player!.playImmediately(atRate: 1.0)
        //Loop AVPlayer
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
        self?.player?.seek(to: CMTime.zero)
        self?.player?.play()
        
        }
    }
    
    
    
    @objc func update() {
        //ensure that counter doesnt go below zero
        if(counter > 0) {
            countDownLabel.text = String(counter)
            counter -= 1
        }
        else{
            //if it is currently in warm-up state, then start the workout
            if warmupStatus{
                let duration = Int(workouts[workoutprogress].duration!)!
                counter = duration
                countDownLabel.text = String(counter)
                warmUpLabel1.text = ""
                warmUpLabel2.text = ""
                
                handleTap(duration: duration)
                warmupStatus = false
            }
            //if it workout is in session, then skip to the next workout
            else{
                
                Complete((Any).self)
               
            }
            
        }
    }
    
    //Play audio notification when the next workout starts
    func playWorkoutAudio(){
        if let url = Bundle.main.url(forResource: workouts[workoutprogress].workout?.name, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.countTimer?.invalidate() //Stops timer when workout ends
    }
    
    
    
    
    
    //Unused
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine]) {
           
       }
       
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout]) {
           
       }
    func onPlanListChange(change: DatabaseChange, recommendedPlan: [Routine]) {
        
    }
}
