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
    var messages = [QueryDocumentSnapshot]()
    var userDocumentListener: ListenerRegistration?
    var messagesListener: ListenerRegistration?
    
    var cameFromEditProfile = false
    var uid = ""
    var currentchat = ""
    var partner = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in  // This gets the authenticated user's info
            if let user = user {
                print("\(type(of: self)) updating user info")
                self.uid = user.uid
                self.addUserDocumentListener()
            }	
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
        userDocumentListener?.remove()
        messagesListener?.remove()
        // Right order??
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addUserDocumentListener() {
        userDocumentListener = db.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            if let chat = document.data()!["currentchat"] as? String {
                self.currentchat = chat  // Update the user's current chat room
                self.addMessagesListener()  // Do it here so currentchat is something
            }
            // Please finish this method.
        }
    }
    
    func addMessagesListener() {
        messagesListener = db.collection("chats").document(currentchat).collection("messages").order(by: "timestamp").addSnapshotListener { querySnapshot, error in  // Listens for updates to messages
            guard let documents = querySnapshot?.documents else {
                print("Error getting documents!: \(error!)")
                return
            }
            // Delete this method?
        }
    }
    
    func fixPartner() {
        db.collection("chats").document(currentchat).getDocument { document, error in
            guard let data = document?.data() else {
                print("Error fixing partner: \(error!)")
                return
            }
            if let me = data["peanutbutter"] as? String, me == self.uid {
                self.partner = data["jelly"]! as! String
            } else if let me = data["jelly"] as? String, me == self.uid {
                self.partner = data["peanutbutter"]! as! String
            }
            // Remove the partner's stuffs
        }
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
