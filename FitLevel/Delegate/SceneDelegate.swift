//
//  SceneDelegate.swift
//  FitLevel
//
//  Created by Jacky Eng on 08/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootViewController: UIViewController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //Display Onboarding if first time using App
        guard let winScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: winScene)
        //https://medium.com/@rajatamil/root-view-controller-programmatically-in-swift-cc740e14192f
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController

        if(UserDefaults.standard.bool(forKey: "notFirstInApp") == false){
            //window?.rootViewController = your tutorial view controller
            rootViewController = storyboard.instantiateViewController(withIdentifier: "Onboarding") as UIViewController
            
        }else{
            //window?.rootViewController = your main viewcontroller
            rootViewController = storyboard.instantiateViewController(withIdentifier: "Login") as UIViewController
            
        }
        navigationController.viewControllers = [rootViewController!]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

