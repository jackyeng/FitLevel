//
//  SettingsViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 21/06/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit
import FirebaseUI

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    //This function removes user session from the app and pops back to login page
    @IBAction func tappedLogout(_ sender: UIButton) {
        
        do
            {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeView  = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                homeView.modalPresentationStyle = .fullScreen
                self.present(homeView, animated: true, completion: nil)
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }


        }
    
}
