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
    var messages = [QueryDocumentSnapshot]()
    
    @IBOutlet weak var messagingTableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    
    var email = ""
    var uid = ""
    var currentchat = ""

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
                print("Messaging: \(self.uid)")
                self.db.collection("users").document(self.uid).getDocument { (document, error) in  // Load the chat messages
                    if let chat = document?.data()!["currentchat"] as? String, !chat.isEmpty {
                        self.currentchat = chat
                        self.db.collection("chats").document(self.currentchat).collection("messages").order(by: "timestamp").addSnapshotListener { querySnapshot, error in  // Listens for updates to messages
                            guard let documents = querySnapshot?.documents else {
                                print("Error getting documents!: \(error!)")
                                return
                            }
                            self.messages = documents  // Reloads everything, not necessarily the most efficient but it's simple
                            self.messagingTableView.reloadData()  // Otherwise the table won't update when loads new messages
                            let content = documents.map { $0["content"]! }
                            print("Messages: \(content)")
                        }
                        self.messagingTableView.reloadData()
                    } else {
                        print("Failed to find current chat! in Messaging")
                    }
                }
               
                self.db.collection("users").document(self.uid).addSnapshotListener { querySnapshot, error in  // Add listener to end if the currentchat suddenly ends
                    print("saw user update!")
                    guard let data = querySnapshot?.data() else {
                        print("Error getting \(self.uid) document!")
                        return
                    }
                    print("FIRST: \(data["first"]!)")
                    print("CHAT: \(data["currentchat"]!)")
                    
                    if let chat = data["currentchat"] as? String, chat.isEmpty {  // WHY DOES THIS SOMETIMES EVALUATE AS TRUE?!?!?
                        print("Your partner closed the connection!!")
                        self.performSegue(withIdentifier: "MessagingToWaiting", sender: nil)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessagingTableViewCell", for: indexPath) as? MessagingTableViewCell else {
            fatalError("Dequed cell is not MessagingTableViewCell!")
        }
        
        if let content = messages[indexPath.row].data()["content"] as? String {
            cell.message.text = content
        }
        if let time = messages[indexPath.row].data()["timestamp"] as? Timestamp {
            cell.timestamp.text = DateFormatter.localizedString(from: time.dateValue(), dateStyle: .medium, timeStyle: .medium)
        }
        if let from = messages[indexPath.row].data()["from"] as? String {
            if from == uid {
                cell.setRight()
            } else {
                cell.setLeft()
            }
        } else {
            cell.setLeft()  // Shouldn't be used but here for testing purposes since not all have "from"
        }
        
        return cell
    }
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "MessagingToSettings", sender: nil)
    }
    
    @IBAction func profilePressed(_ sender: UIBarButtonItem) {
        // View the other person's profile
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let text = messageField.text, !text.isEmpty {
            print("Sending: \(text)")
            messageField.text = ""
            db.collection("chats").document(currentchat).collection("messages").addDocument(data: [
                "content" : text,
                "from" : uid,
                "timestamp" : Timestamp()
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Successfully sent: \(text)")
                }
            }
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
    
    @IBAction func unwindToMessaging(segue: UIStoryboardSegue) {
        // unwind to messaging
    }

}
