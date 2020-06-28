//
//  EditRoutineNameViewController.swift
//  FitLevel
//
//  Created by Jacky Eng on 21/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class EditRoutineNameViewController: UIViewController, UITextFieldDelegate{
    weak var nameDelegate: EditRoutineNameDelegate?
    
    @IBOutlet weak var nameLabel: UITextField!
    
    override func viewDidLoad() {
        nameLabel.delegate = self
        super.viewDidLoad()

    
    }
    //https://stackoverflow.com/questions/48900072/swift-uitextfield-keyboard-return-key-is-not-working
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
    @IBAction func editName(_ sender: Any) {
        if nameLabel.text != "" {  //only allow save when user enter name
            let name = nameLabel.text!
            let _ = nameDelegate?.editName( Name: name)
            navigationController?.popViewController(animated: true)
            return
        }

        var errorMsg = "Please ensure all fields are filled:\n"

        if nameLabel.text == "" {
            errorMsg += "- Must provide a name\n"
        }

        displayMessage(title: "Not all fields filled", message: errorMsg)
    }
    
    
        func displayMessage(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message,
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style:
                UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
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


