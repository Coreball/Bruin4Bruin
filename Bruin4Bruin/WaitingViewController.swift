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
    var poolListener: ListenerRegistration?
    var joinedChatListener: ListenerRegistration?
    
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var numberOfOthersInPoolLbl: UILabel!
    
    var cameFromEditAccount = false
    var uid = ""
    var currentchat = ""
    var partner = ""
    var ended: Timestamp!
    var othersInPool = [String]()
    let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gradient
        
        let topColor = UIColor(red: (15/255.0), green: (118/255.0), blue: (128/255.0), alpha: 1)
        let bottomColor = UIColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in  // This gets the authenticated user's info
            if let user = user {
                print("\(type(of: self)) updating user info")
                self.uid = user.uid
                self.endCurrentChat()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
        poolListener?.remove()
        joinedChatListener?.remove()
        // Right order??
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        gradientLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func endCurrentChat() {
        db.collection("users").document(uid).getDocument { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            if let chat = document.data()!["currentchat"] as? String {
                self.currentchat = chat  // Update the user's current chat room
                print("Current chat: \(self.currentchat)")
                if self.currentchat.isEmpty {
                    print("There is a currentchat field but it is empty.")
                    // do nothing if don't need to clear a chat or fix partner
                } else {
                    self.ended = Timestamp()
                    self.db.collection("chats").document(self.currentchat).updateData(["ended" : self.ended])  // Write that this chat has ended at this time
                    self.fixPartner()
                    self.db.collection("users").document(self.uid).updateData(["currentchat" : ""])
                }
            } else {
                print("No chat found.")  // Could have come from creating account nvm I think that's the above currentchat.isempty one
            }
            self.addPoolListener()
            self.addJoinedChatListener()
        }
    }
    
    func fixPartner() {
        db.collection("chats").document(currentchat).getDocument { document, error in
            guard let document = document, document.exists, let data = document.data() else {
                print("Error fixing partner: \(String(describing: error))")
                return
            }
            print(data)
            if let me = data["peanutbutter"] as? String, me == self.uid {
                self.partner = data["jelly"]! as! String
            } else if let me = data["jelly"] as? String, me == self.uid {
                self.partner = data["peanutbutter"]! as! String
            }
            print("Previous partner: \(self.partner)")
            self.addToHistory()
            self.addToPartnerHistory()
            self.db.collection("users").document(self.partner).updateData(["currentchat" : ""])  // Remove the partner's current chat
        }
    }
    
    func addToHistory() {
        print("Adding chat to user's history")
        db.collection("users").document(self.partner).getDocument { document, error in
            guard let document = document, document.exists, let data = document.data() else {
                print("Error getting partner's data: \(error?.localizedDescription ?? "Couldn't get error message?")")
                return
            }
            print("boo")
            if let first = data["first"], let last = data["last"] {
                let friendlyPartnerName = "\(first) \(last)"
                print("Friendly partner name: \(friendlyPartnerName)")
                let history = self.db.collection("users").document(self.uid).collection("history").document(self.currentchat)
                history.setData([
                    "friendlypartner" : friendlyPartnerName,
                    "ended" : self.ended
                ]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func addToPartnerHistory() {
        print("Adding chat to partner's history")
        db.collection("users").document(self.uid).getDocument { document, error in
            guard let document = document, document.exists, let data = document.data() else {
                print("Error getting my own data: \(error?.localizedDescription ?? "Couldn't get error message?")")
                return
            }
            if let first = data["first"], let last = data["last"] {
                let friendlyUserName = "\(first) \(last)"
                print("Friendly user name: \(friendlyUserName)")
                let history = self.db.collection("users").document(self.partner).collection("history").document(self.currentchat)
                history.setData([
                    "friendlypartner" : friendlyUserName,
                    "ended" : self.ended
                ]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func addPoolListener() {
        poolListener = db.collection("users").whereField("currentchat", isEqualTo: "").addSnapshotListener { querySnapshot, error in  // This will update at least twice, when currentuser and partner leave their currentchat.
            guard let bachelors = querySnapshot?.documents else {
                print("Error getting documents of users in pool: \(error!)")
                return
            }
            print("Bachelors and Bachelorettes: \(bachelors.map { $0["first"] })")
            self.othersInPool = [String]()
            for user in bachelors {
                if user.documentID != self.uid {
                    self.othersInPool += [user.documentID]
                }
            }
            self.numberOfOthersInPoolLbl.text = String(self.othersInPool.count)
        }
    }
    
    func addJoinedChatListener() {
        joinedChatListener = db.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            print("Database user was modified!")
            if let chat = document.data()!["currentchat"] as? String, !chat.isEmpty, chat != self.currentchat {
                print("Database current chat changed to \(chat), initiating segue now")
                self.segueToCorrectScreen()  // Leave if we were just on the waiting screen and joined a new chat by someone else's hand
            }
        }
    }
    
    func makeMatch() {
        joinedChatListener?.remove()
        print("Removed join chat listener")  // Don't want it to trigger segue before currentchat is written
        let random = Int(arc4random_uniform(UInt32(othersInPool.count)))  // Choose a partner randomly for now
        partner = othersInPool[random]
        let newChat = db.collection("chats").document()  // Make a new document for the new chat with random name
        newChat.setData([
            "peanutbutter" : uid,
            "jelly" : partner,
            "started" : Timestamp()
            ])
        db.collection("users").document(uid).updateData(["currentchat" : newChat.documentID])
        db.collection("users").document(partner).updateData(["currentchat" : newChat.documentID])
        print("Finished writing uid information with new chat")
        segueToCorrectScreen()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        cameFromEditAccount = false
        if let editAccount = segue.destination as? EditAccountViewController {
            editAccount.skipToMessaging = true  // Unwind and then skip directly to messaging
        }
    }
    
    @IBAction func leavePressed(_ sender: UIButton) {
        if othersInPool.count > 0 {
            makeMatch()
            segueToCorrectScreen()
        } else {
            print("No other matchers in pool, could not match.")
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "UnwindToLoginFromWaiting", sender: nil)
    }
    
    func segueToCorrectScreen() {
        if cameFromEditAccount {
            performSegue(withIdentifier: "UnwindToEditAccountFromWaiting", sender: nil)
        } else {
            performSegue(withIdentifier: "UnwindToMessagingFromWaiting", sender: nil)  // Skip the settings screen
        }
    }
    
}
