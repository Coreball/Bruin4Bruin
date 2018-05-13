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
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        This is an example of adding a button programatically.
//        let button = UIButton(type: .system) // let preferred over var here
//        button.frame = CGRect(x: 200, y: 200, width: 200, height: 200)
//        button.backgroundColor = .green
//        self.view.addSubview(button)
        
        let topColor = UIColor(red: (15/255.0), green: (118/255.0), blue: (128/255.0), alpha: 1)
        let bottomColor = UIColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)

        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 0.75
        
        usernameTextField.layer.masksToBounds = true
        usernameTextField.layer.borderColor = UIColor.white.cgColor
        usernameTextField.layer.borderWidth = 0.75
        usernameTextField.layer.cornerRadius = 6
        
        usernameTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.borderWidth = 0.75
        passwordTextField.layer.cornerRadius = 6
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {  // View will appear also covers returning from another screen
        self.navigationController?.navigationBar.isHidden = true  // Hide the navbar
        errorLabel.isHidden = true  // Hide the error until needed
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.navigationBar.isHidden = false  // Show the navbar again
        if let editAccountVC = segue.destination as? EditAccountViewController {
            editAccountVC.isCreatingAccount = true
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        print("\(type(of: self)) login button pressed")
        if let email = usernameTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in  // Attempt to log in
                if let user = user {
                    print("\(type(of: self)) successfully logged in")
                    print("User ID: \(user.uid)")
                    print("Email: \(user.email!)")
                    self.performSegue(withIdentifier: "LoginToMessaging", sender: nil)
                } else {
                    print(error!.localizedDescription)
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = error!.localizedDescription  // If have time write some better error messages
                }
            }
        }
    }

    @IBAction func createAccountPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginToEditAccount", sender: nil)
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        do {
            try Auth.auth().signOut()
            print("\(type(of: self)) successfully signed out user")
        } catch {
            print("\(type(of: self)) failed to sign out user!!")
        }
    }
    
}

