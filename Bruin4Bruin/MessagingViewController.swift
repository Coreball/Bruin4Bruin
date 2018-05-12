//
//  MessagingViewController.swift
//  Bruin4Bruin
//
//  Created by Changyuan Lin on 5/4/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit
import Firebase

class MessagingViewController: UIViewController, UITableViewDataSource {
    
    var handle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()
    
    @IBOutlet weak var messagingTableView: UITableView!
    
    var email = ""
    var uid = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        messagingTableView.dataSource = self
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessagingTableViewCell", for: indexPath) as? MessagingTableViewCell else {
            fatalError("Dequed cell is not MessagingTableViewCell!")
        }
        
        cell.message.text = "HELLO"
        cell.timestamp.text = "WORLD!"
        
        return cell
    }
    
    @IBAction func testPressed(_ sender: UIButton) {
        print("\(type(of: self)) testing user email and uid")
        print("Email: \(email)")
        print("User ID: \(uid)")
    }
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "MessagingToSettings", sender: nil)
    }
    
    @IBAction func profilePressed(_ sender: UIBarButtonItem) {
        // View the other person's profile
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToMessaging(segue: UIStoryboardSegue) {
        // unwind to messaging
    }

}
