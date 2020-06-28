//
//  LoginViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 21/06/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {
    //https://stackoverflow.com/questions/48799481/how-to-switch-to-other-view-controller-programmatically-in-swift-4/48805442
    //https://www.youtube.com/watch?v=brpt9Thi6GU
    //https://stackoverflow.com/questions/37536499/how-to-maintain-user-session-after-exiting-app-in-firebase
    override func viewDidLoad() {
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
            // User is signed in.
            let sampleStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let homeView  = sampleStoryBoard.instantiateViewController(withIdentifier: "Home") as! MainTabBarViewController
            homeView.modalPresentationStyle = .fullScreen
            self.present(homeView, animated: true, completion: nil)

          } else {
            // No user is signed in.
                //get the default auth ui objects
                FUIAuth.defaultAuthUI()?.shouldHideCancelButton = true
                let authUI = FUIAuth.defaultAuthUI()
                guard authUI != nil else {
                    return
                }
                //set ourselvs as the delegate
                authUI?.delegate = self as FUIAuthDelegate
                authUI?.providers = [FUIEmailAuth()]
                //Get a reference to the auth UI view controller
                let authViewController = authUI!.authViewController()
                //Show it
                authViewController.modalPresentationStyle = .fullScreen
                self.present(authViewController, animated: true, completion: nil)
          }
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
  
    //https://stackoverflow.com/questions/58507034/how-to-create-segue-which-make-view-controller-fullscreen-in-xcode-11-1
    
    
}
    
    extension LoginViewController: FUIAuthDelegate {
        
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult:
            AuthDataResult?, error: Error?) {
            
            guard error == nil else{
                return
            }
            //authDataResult?.user.uid
            let sampleStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let homeView  = sampleStoryBoard.instantiateViewController(withIdentifier: "Home") as! MainTabBarViewController
            homeView.modalPresentationStyle = .fullScreen
            self.present(homeView, animated: true, completion: nil)
        }
    }
    
