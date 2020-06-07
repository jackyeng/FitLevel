//
//  WorkoutStatsViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 09/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class WorkoutStatsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutStats", for: indexPath) as! WorkoutStatsCollectionViewCell
               
               /*
               cell.backgroundColor = UIColor.yellow
               
               
               cell.layer.cornerRadius = 18
               cell.layer.masksToBounds = true
               let origin = cell.frame
               
               //Top Workout
               let coordinate = CGPoint(x:207,y:338)
               //create my track layer
               let trackLayer = CAShapeLayer()
               let circularPath = UIBezierPath(arcCenter: coordinate, radius: 100, startAngle: -CGFloat.pi / 2 , endAngle: 2 * CGFloat.pi, clockwise: true)
                      
               trackLayer.path = circularPath.cgPath
                      
               trackLayer.strokeColor = UIColor.lightGray.cgColor
               trackLayer.lineWidth = 10
               trackLayer.fillColor = UIColor.white.cgColor
               trackLayer.lineCap = CAShapeLayerLineCap.round

               
               
               
               */
               
               if cell.isHidden{
                   cell.isHidden = false
               }
              cell.levelLabel.text = "16"
        cell.workoutNameLabel.text = "Mountain Climber"
        cell.workoutNameLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.workoutNameLabel?.numberOfLines = 0
               let image : UIImage = UIImage(named:"goldcircle")!
               cell.WorkoutStatImage.image = image
               return cell
    }
    
    
   
    @IBOutlet weak var WorkoutStats: UICollectionView!
    
    var views: UIView?
    var string: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.systemIndigo
       WorkoutStats.dataSource = self
       WorkoutStats.delegate = self
        
        
        self.navigationItem.titleView = navTitleWithImageAndText(titleText: "Workout Stats", imageName: "gamer_01_18_contour_info_infos_lines-512.png")
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 10
        }
    }
    
  
    
    func displayTopWorkout(){
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //https://stackoverflow.com/questions/24803178/navigation-bar-with-uiimage-for-title
    func navTitleWithImageAndText(titleText: String, imageName: String) -> UIView {

        // Creates a new UIView
        let titleView = UIView()

        // Creates a new text label
        let label = UILabel()
        label.text = titleText
        label.sizeToFit()
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center

        // Creates the image view
        let image = UIImageView()
        image.image = UIImage(named: imageName)

        // Maintains the image's aspect ratio:
        let imageAspect = image.image!.size.width / image.image!.size.height

        // Sets the image frame so that it's immediately before the text:
        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect
        let imageY = label.frame.origin.y

        let imageWidth = label.frame.size.height * imageAspect + 30
        let imageHeight = label.frame.size.height + 30

        image.frame = CGRect(x: imageX-20, y: imageY-20, width: imageWidth, height: imageHeight)

        image.contentMode = UIView.ContentMode.scaleAspectFit

        // Adds both the label and image view to the titleView
        titleView.addSubview(label)
        titleView.addSubview(image)

        // Sets the titleView frame to fit within the UINavigation Title
        titleView.sizeToFit()

        return titleView

    }
    
    

