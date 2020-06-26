//
//  AboutTableViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 23/06/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
    var section_cocoapods = 0
    var section_workoutresources = 1
    var section_assetresources = 2
    var section_calender = 3
    var section_login = 4
    var section_usersession = 5
    var section_progressbar = 6
    var section_tabbar = 7
    var section_nstimer = 8
    var section_avplayerloop = 9
    var section_pauseanimation = 10
    var section_delayfunction = 11
    var section_coredata = 12
    var section_seguefullscreen = 13
    var section_switchvc = 14
    var section_titleimage = 15
    var section_intcheck = 16
 
    var sectiontitle_cocoapods = "Cocoapods"
    var sectiontitle_workoutresources = "Workout Resources"
    var sectiontitle_assetresources = "Asset Resources"
    var sectiontitle_calender = "Calender"
    var sectiontitle_login = "Build Login page in iOS with Firebase"
    var sectiontitle_usersession = "Maintain user session after exiting app in firebase"
    var sectiontitle_progressbar = "Animated Circle Progress Bar"
    var sectiontitle_tabbar = "Swift UITabBar & Basic Customization"
    var sectiontitle_nstimer = "Countdown with NSTimer"
    var sectiontitle_avplayerloop = "Looping AVPlayer"
    var sectiontitle_pauseanimation = "Pause CABasicAnimation for CALayer"
    var sectiontitle_delayfunction = "Delay function execution in swift"
    var sectiontitle_coredata = "Saving Core Data Objects"
    var sectiontitle_seguefullscreen = "How to create Segue which make view controller fullscreen"
    var sectiontitle_switchvc = "Switching to other view controller programmatically"
    var sectiontitle_titleimage = "Navigation Bar with UIImage for title"
    var sectiontitle_intcheck = "Checking if string is an int"
    
    var cell_cocoapods = "cocoapods"
    var cell_workoutresources = "workoutresources"
    var cell_assetresources = "assetresources"
    var cell_calender = "calender"
    var cell_login = "login"
    var cell_usersession = "usersession"
    var cell_progressbar = "progressbar"
    var cell_tabbar = "tabbar"
    var cell_nstimer = "nstimer"
    var cell_avplayerloop = "avplayerloop"
    var cell_pauseanimation = "pauseanimation"
    var cell_delayfunction = "delayfunction"
    var cell_coredata = "coredata"
    var cell_seguefullscreen = "seguefullscreen"
    var cell_switchvc = "switchvc"
    var cell_titleimage = "titleimage"
    var cell_intcheck = "intcheck"
    
    var cell_list = [String]()
    var reference_list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cell_list = [ cell_cocoapods,
                      cell_workoutresources,
                      cell_assetresources,
                      cell_calender,
                      cell_login,
                      cell_usersession,
                      cell_progressbar,
                      cell_tabbar,
                      cell_nstimer,
                      cell_avplayerloop,
                      cell_pauseanimation,
                      cell_delayfunction,
                      cell_coredata,
                      cell_seguefullscreen,
                      cell_switchvc,
                      cell_titleimage,
                      cell_intcheck]
        
        reference_list =
        ["Firebase",
        "https://www.youtube.com/watch?time_continue=270&v=_knIf9vF4k4&feature=emb_logo",
        "Icons8",
        "https://www.youtube.com/watch?v=0o06EIPY0JI",
        "https://www.youtube.com/watch?v=brpt9Thi6GU",
        "https://stackoverflow.com/questions/37536499/how-to-maintain-user-session-after-exiting-app-in-firebase",
        "https://www.youtube.com/watch?v=O3ltwjDJaMk",
        "https://www.youtube.com/watch?v=n7NNAdaIDKQ",
        "https://stackoverflow.com/questions/29374553/how-can-i-make-a-countdown-with-nstimer",
        "https://stackoverflow.com/questions/27808266/how-do-you-loop-avplayer-in-swift/27808482",
        "https://stackoverflow.com/questions/34735707/swift-pause-cabasicanimation-for-calayer",
        "https://stackoverflow.com/questions/28821722/delaying-function-in-swift/28821805#28821805",
        "https://code-craftsman.fr/2015/08/04/saving-core-data-objects/",
    "https://stackoverflow.com/questions/58507034/how-to-create-segue-which-make-view-controller-fullscreen-in-xcode-11-1",
    "https://stackoverflow.com/questions/48799481/how-to-switch-to-other-view-controller-programmatically-in-swift-4/48805442",
        "https://stackoverflow.com/questions/24803178/navigation-bar-with-uiimage-for-title ",
        "https://stackoverflow.com/questions/38159397/how-to-check-if-a-string-is-an-int-in-swift"]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 17
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case section_cocoapods:
            return sectiontitle_cocoapods
        case section_workoutresources:
            return sectiontitle_workoutresources
        case section_assetresources:
            return sectiontitle_assetresources
        case section_calender:
            return sectiontitle_calender
        case section_login:
            return sectiontitle_login
        case section_usersession:
            return sectiontitle_usersession
        case section_progressbar:
            return sectiontitle_progressbar
        case section_tabbar:
            return sectiontitle_tabbar
        case section_nstimer:
            return sectiontitle_nstimer
        case section_avplayerloop:
            return sectiontitle_avplayerloop
        case section_pauseanimation:
            return sectiontitle_pauseanimation
        case section_delayfunction:
            return sectiontitle_delayfunction
        case section_coredata:
            return sectiontitle_coredata
        case section_seguefullscreen:
            return sectiontitle_seguefullscreen
        case section_switchvc:
            return sectiontitle_switchvc
        case section_titleimage:
            return sectiontitle_titleimage
        case section_intcheck:
            return sectiontitle_intcheck
        default:
            return nil
               
           }
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_list[indexPath.section], for: indexPath) as! AboutTableViewCell

        cell.referenceLabel.text = reference_list[indexPath.section]
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 0
        return cell
        // Configure the cell...
        /*
        switch indexPath.section{
        case section_cocoapods:
            let thirdpartycell = tableView.dequeueReusableCell(withIdentifier: cell_cocoapods, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.referenceLAbel?.numberOfLines = 0
            thirdpartycell.referenceLabel.text = "test"
            return thirdpartycell
            
        case section_workoutresources:
            let resourcescell = tableView.dequeueReusableCell(withIdentifier: cell_workoutresources, for: indexPath) as! AboutTableViewCell
            resourcescell.referenceLabel.text = "test"
            return resourcescell
            
        case section_assetresources:
            let youtubelinkcell = tableView.dequeueReusableCell(withIdentifier: cell_assetresources, for: indexPath) as! AboutTableViewCell
            youtubelinkcell.referenceLabel.text = "test"
            return youtubelinkcell
            
        case section_calender:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_calender, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.referenceLabel?.numberOfLines = 0
            cell.referenceLabel.text = "https://www.youtube.com/watch?v=0o06EIPY0JI"
            return cell
            
        case section_login:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_login, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.referenceLabel?.numberOfLines = 0
            cell.referenceLabel.text = "https://www.youtube.com/watch?v=brpt9Thi6GU"
            return cell
            
        case section_usersession:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_usersession, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.referenceLabel?.numberOfLines = 0
            cell.referenceLabel.text = "https://stackoverflow.com/questions/37536499/how-to-maintain-user-session-after-exiting-app-in-firebase"
            return cell
            
        case section_progressbar:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_progressbar, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.referenceLAbel?.numberOfLines = 0
            cell.referenceLabel.text = "https://www.youtube.com/watch?v=O3ltwjDJaMk"
            return cell
            
        case section_tabbar:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_tabbar, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel.text = "https://www.youtube.com/watch?v=n7NNAdaIDKQ"
            return cell
            
        case section_nstimer:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_nstimer, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel.text = "https://stackoverflow.com/questions/29374553/how-can-i-make-a-countdown-with-nstimer"
            return cell
            
        case section_avplayerloop:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_avplayerloop, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel.text = "https://stackoverflow.com/questions/27808266/how-do-you-loop-avplayer-in-swift/27808482"
            return cell
            
        case section_pauseanimation:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_pauseanimation, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel.text = "https://stackoverflow.com/questions/34735707/swift-pause-cabasicanimation-for-calayer"
            return cell
            
        case section_delayfunction:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_delayfunction, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel.text = "https://stackoverflow.com/questions/28821722/delaying-function-in-swift/28821805#28821805"
            return cell
            
        case section_coredata:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_coredata, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel.text = "https://code-craftsman.fr/2015/08/04/saving-core-data-objects/"
            return cell
            
        case section_seguefullscreen:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_seguefullscreen, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel.text = "https://stackoverflow.com/questions/58507034/how-to-create-segue-which-make-view-controller-fullscreen-in-xcode-11-1"
            return cell
            
        case section_switchvc:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_switchvc, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel.text = "https://stackoverflow.com/questions/48799481/how-to-switch-to-other-view-controller-programmatically-in-swift-4/48805442"
            return cell
        
        case section_titleimage:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_titleimage, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel.text = "https://stackoverflow.com/questions/24803178/navigation-bar-with-uiimage-for-title "
            return cell
            
        case section_intcheck:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_intcheck, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel.text = "https://stackoverflow.com/questions/38159397/how-to-check-if-a-string-is-an-int-in-swift"
            return cell
        
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cell_intcheck, for: indexPath) as! AboutTableViewCell
            cell.referenceLabel.text = ""
            return cell
            
        }
      */
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
