//
//  AboutTableViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 23/06/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
    
    
    var section_thirdparty = 0
    var section_resources = 1
    var section_youtubelinks = 2
   
    
    var cell_thirdparty = "ThirdParty"
    var cell_youtubelinks = "YoutubeResources"
    var cell_resources = "Resources"
    
    //IMAGE ASSETS LINK
    
    var ThirdParty = ["Firebase"]
    
    var YoutubeLinks = ["1","2","3"]
    
    var Resources = ["1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section{
        case section_thirdparty:
            return ThirdParty.count
        case section_resources:
            return Resources.count
        case section_youtubelinks:
            return YoutubeLinks.count
        default:
            return 0
            
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        // Configure the cell...
        
        switch indexPath.section{
        case section_thirdparty:
            let thirdpartycell = tableView.dequeueReusableCell(withIdentifier: "ThirdParty", for: indexPath) as! AboutTableViewCell
            
            let thirdpartyname = ThirdParty[indexPath.row]
            thirdpartycell.referenceLabel.text = thirdpartyname
            
            return thirdpartycell
        case section_resources:
            let resourcescell = tableView.dequeueReusableCell(withIdentifier: "Resources", for: indexPath) as! AboutTableViewCell
            let resourcesname = Resources[indexPath.row]
            resourcescell.referenceLabel.text = resourcesname
            
            return resourcescell
        case section_youtubelinks:
            let youtubelinkcell = tableView.dequeueReusableCell(withIdentifier: "YoutubeResources", for: indexPath) as! AboutTableViewCell
            youtubelinkcell.referenceLabel.text = YoutubeLinks[indexPath.row]
            return youtubelinkcell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! AboutTableViewCell
            return cell
            
        }
      
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
