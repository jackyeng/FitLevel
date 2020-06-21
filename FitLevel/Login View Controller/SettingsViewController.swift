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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func tappedLogout(_ sender: UIButton) {
        
        do
            {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //let sampleStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
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
