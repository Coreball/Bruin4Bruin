//
//  WaitingViewController.swift
//  Bruin4Bruin
//
//  Created by Student on 5/10/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit
import Firebase

class WaitingViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()
    
    var uid = ""
    var uidFormerPartner = ""
    var currentchat = ""
    var cameFromEditProfile = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in  // This gets the authenticated user's info
            if let user = user {
                print("\(type(of: self)) updating user info")
                self.uid = user.uid
                print("USER ID: \(self.uid)")
                self.db.collection("users").document(self.uid).getDocument { (document, error) in
                    if let chat = document?.data()!["currentchat"] as? String, !chat.isEmpty {
                        self.currentchat = chat
                        self.becomeSingle()
                    } else {
                        print("Failed to find current chat! in Waiting")
                    }
                }
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
    
    func becomeSingle() {
        guard currentchat != "" else {  // Only want to clean up shared message once
            print("This is the second user")
            return
        }
        
        db.collection("chats").document(currentchat).getDocument { (document, error) in
            if let document = document, document.exists {
                if let peanutbutter = document.data()!["peanutbutter"] as? String, peanutbutter != self.uid {
                    self.uidFormerPartner = peanutbutter
                } else if let jelly = document.data()!["jelly"] as? String, jelly != self.uid {
                    self.uidFormerPartner = jelly
                }
            }
        }
        
        db.collection("chats").document(currentchat).updateData([
            "ended" : Timestamp()
            ])
        db.collection("users").document(uid).updateData([
            "currentchat" : ""
            ])
        db.collection("users").document(uidFormerPartner).updateData([
            "currentchat" : ""  // The listener if the other partner is in Messaging should cause them to go into Waiting too
            ])
    }
    
    func matchMe() {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        cameFromEditProfile = false
        if let editProfile = segue.destination as? EditProfileViewController {
            editProfile.skipToMessaging = true  // Unwind and then skip directly to messaging
        }
    }
    
    @IBAction func leavePressed(_ sender: UIButton) {
        if cameFromEditProfile {
            performSegue(withIdentifier: "UnwindToEditProfileFromWaiting", sender: nil)
        } else {
            performSegue(withIdentifier: "UnwindToMessagingFromWaiting", sender: nil)
        }
    }
    
}
