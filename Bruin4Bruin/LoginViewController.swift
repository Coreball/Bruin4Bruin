//
//  ViewController.swift
//  Bruin4Bruin
//
//  Created by Changyuan Lin on 4/29/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        This is an example of adding a button programatically.
//        let button = UIButton(type: .system) // let preferred over var here
//        button.frame = CGRect(x: 200, y: 200, width: 200, height: 200)
//        button.backgroundColor = .green
//        self.view.addSubview(button)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {  // View will appear also covers returning from another screen
        self.navigationController?.navigationBar.isHidden = true  // Hide the navbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.navigationBar.isHidden = false  // Show the navbar again
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        print("\(type(of: self)) login button pressed")
        if let email = usernameTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in  // Attempt to log in
                if let user = user {
                    print("\(type(of: self)) successfully logged in")
                    print("User ID: \(user.uid)")
                    print("Email: \(user.email!)")
                    self.performSegue(withIdentifier: "LoginToMessaging", sender: sender)
                }
            }
        }
    }

}

