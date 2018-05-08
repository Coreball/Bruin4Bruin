//
//  MessagingViewController.swift
//  Bruin4Bruin
//
//  Created by Changyuan Lin on 5/4/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessagingViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var email = ""
    var uid = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in  // This gets the authenticated user's info
            if let user = user {
                print("\(type(of: self)) updating user info")
                self.email = user.email!
                self.uid = user.uid
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testPressed(_ sender: UIButton) {
        print("\(type(of: self)) testing user email and uid")
        print("Email: \(email)")
        print("User ID: \(uid)")
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
