//
//  ViewController.swift
//  Bruin4Bruin
//
//  Created by Changyuan Lin on 4/29/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.shadowImage = UIImage()  // Get rid of ugly line
        
        let topColor = UIColor(red: (15/255.0), green: (118/255.0), blue: (128/255.0), alpha: 1)
        let bottomColor = UIColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))  // Hide keyboard when tapping outside field
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {  // View will appear also covers returning from another screen
        self.navigationController?.navigationBar.isHidden = true  // Hide the navbar
        errorLabel.isHidden = true  // Hide the error until needed
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // TODO remove the keyboard observers
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()  // Switch to password field
        } else if textField == passwordTextField {
            loginPressed(nil)  // Same as pressing Login
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.navigationBar.isHidden = false  // Show the navbar again
        if let editAccountVC = segue.destination as? EditAccountViewController {
            editAccountVC.isCreatingAccount = true
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton?) {
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

