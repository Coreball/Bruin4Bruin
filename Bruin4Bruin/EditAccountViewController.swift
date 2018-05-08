//
//  EditAccountViewController.swift
//  Bruin4Bruin
//
//  Created by Student on 5/3/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit

class EditAccountViewController: UIViewController {
    
    @IBOutlet var textFields: [UITextField]!  // Email, Password, Confirm Password, First Name, Last Name in that order
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var isCreatingAccount = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for textField in textFields {
            textField.layer.borderColor = UIColor.red.cgColor  // Can't do this in Storyboard
            textField.layer.borderWidth = 0  // Don't show the border
        }
        if isCreatingAccount {
            saveButton.title = "Next"
        } else {
            saveButton.title = "Save"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if isCreatingAccount {
            if validateTextFields() {
                performSegue(withIdentifier: "EditAccountToEditProfile", sender: nil)
            }
        } else {
            // save and return to settings
        }
    }
    
    func validateTextFields() -> Bool {
        
        var isValid = true
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        if !emailTest.evaluate(with: textFields[0].text) {  // Test if email is valid
            textFields[0].layer.borderWidth = 0.5
            isValid = false
        } else {
            textFields[0].layer.borderWidth = 0
        }
        
        if textFields[1].text != textFields[2].text || textFields[1].text!.isEmpty {  // Test if passwords do not match or are empty
            textFields[1].layer.borderWidth = 0.5
            textFields[2].layer.borderWidth = 0.5
            isValid = false
        } else {
            textFields[1].layer.borderWidth = 0
            textFields[2].layer.borderWidth = 0
        }
        
        if textFields[3].text!.isEmpty {  // Test if First Name is blank
            textFields[3].layer.borderWidth = 0.5
            isValid = false
        } else {
            textFields[3].layer.borderWidth = 0
        }
        
        if textFields[4].text!.isEmpty {  // Test if Last Name is blank
            textFields[4].layer.borderWidth = 0.5
            isValid = false
        } else {
            textFields[4].layer.borderWidth = 0
        }
        
        return isValid
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let editProfileVC = segue.destination as? EditProfileViewController {  // If this is creating account make last button "Finish"
            editProfileVC.isCreatingAccount = true
            editProfileVC.textFields = textFields  // Pass on the user info we just got
        }
    }
    

}
