//
//  EditProfileViewController.swift
//  Bruin4Bruin
//
//  Created by Student on 5/3/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit
import FirebaseAuth

class EditProfileViewController: UIViewController {

    @IBOutlet weak var scrollInside: UIView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var textFields = [UITextField]()
    var isCreatingAccount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollInside.frame.size.height = 5000
//        scrollInside.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 500)
//        scrollInside.frame = CGRect(x: 0, y: 0, self.view.safeAreaLayoutGuide.widthAnchor  )
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isCreatingAccount {
            saveButton.title = "Finish"
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
            Auth.auth().createUser(withEmail: textFields[0].text!, password: textFields[1].text!) { (user, error) in
                if let user = user {
                    print("\(type(of: self)) successfully created new user")
                    print("User ID: \(user.uid)")
                    print("Email: \(user.email!)")
                    self.performSegue(withIdentifier: "EditProfileToMessaging", sender: nil)
                } else {
                    print(error!.localizedDescription)
                }
            }
        } else {
            // save the stuff and return to settings
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
