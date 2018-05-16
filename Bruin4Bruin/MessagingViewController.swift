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
    var userDocumentListener: ListenerRegistration?
    var messagesListener: ListenerRegistration?
    
    @IBOutlet weak var messagingTableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    
    var email = ""
    var uid = ""
    var currentchat = ""
    var userFull = ""
    var partnerFull = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        messagingTableView.dataSource = self
        
        let topColor = UIColor(red: (15/255.0), green: (118/255.0), blue: (128/255.0), alpha: 1)
        let bottomColor = UIColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in  // This gets the authenticated user's info
            if let user = user {
                print("\(type(of: self)) updating user info")
                self.email = user.email!
                self.uid = user.uid
                self.addUserDocumentListener()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
        userDocumentListener?.remove()
        messagesListener?.remove()
        // Are these in the right order??
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
        if let from = messages[indexPath.row].data()["from"] as? String, let time = messages[indexPath.row].data()["timestamp"] as? Timestamp {
            if from == uid {
                cell.setRight()
                cell.timestamp.text = "\(userFull) on \(DateFormatter.localizedString(from: time.dateValue(), dateStyle: .medium, timeStyle: .medium))"
            } else {
                cell.setLeft()
                cell.timestamp.text = "\(partnerFull) on \(DateFormatter.localizedString(from: time.dateValue(), dateStyle: .medium, timeStyle: .medium))"
            }
        } else {
            cell.setLeft()  // Shouldn't be used but here for testing purposes since not all have "from"
        }
        
        return cell
    }
    
    func addUserDocumentListener() {
        userDocumentListener = db.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot, let data = document.data() else {
                print("Error fetching document: \(error!)")
                return
            }
            print(data)
            if let first = data["first"] as? String, let last = data["last"] as? String {
                self.userFull = "\(first) \(last)"
            }
            if let chat = data["currentchat"] as? String {
                self.currentchat = chat  // Update the user's current chat room
                if self.currentchat.isEmpty {
                    print("Either your partner left you or you never had a currentchat. Going to Waiting now.")  // IF TIME SHOW THIS TO THE USER SOMEHOW.
                    self.performSegue(withIdentifier: "MessagingToWaiting", sender: nil)
                } else {
                    self.addMessagesListener()  // Do it here so currentchat is something
                    self.setTitleFromPartner()
                }
            }
        }
    }
    
    func addMessagesListener() {
        messagesListener = db.collection("chats").document(currentchat).collection("messages").order(by: "timestamp").addSnapshotListener { querySnapshot, error in  // Listens for updates to messages
            guard let documents = querySnapshot?.documents else {
                print("Error getting documents!: \(error!)")
                return
            }
            self.messages = documents  // Reloads everything, not necessarily the most efficient but it's simple
            self.messagingTableView.reloadData()  // Otherwise the table won't update when loads new messages
            let content = documents.map { $0["content"]! }
            print("Messages: \(content)")
        }
    }
    
    func setTitleFromPartner() {
        db.collection("chats").document(currentchat).getDocument { document, error in
            guard let document = document, document.exists, let data = document.data() else {
                print("Error finding partner name: \(String(describing: error))")
                return
            }
            var partner = "?"
            if let me = data["peanutbutter"] as? String, me == self.uid {
                partner = data["jelly"] as! String
            } else if let me = data["jelly"] as? String, me == self.uid {
                partner = data["peanutbutter"] as! String
            }
            self.db.collection("users").document(partner).getDocument { document, error in
                guard let document = document, document.exists, let partnerData = document.data() else {
                    print("Error finding partner document: \(String(describing: error))")
                    return
                }
                if let first = partnerData["first"] as? String, let last = partnerData["last"] as? String {
                    self.navigationItem.title = first
                    self.partnerFull = "\(first) \(last)"
                }
            }
        }
    }
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "MessagingToSettings", sender: nil)
    }
    
    @IBAction func newConnectionPressed(_ sender: UIBarButtonItem) {
        let confirmAlert = UIAlertController(title: "New Connection", message: "This will end your current conversation!", preferredStyle: .alert)
        confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "MessagingToWaiting", sender: nil)
        }))
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Cancelled new connection")
        }))
        present(confirmAlert, animated: true, completion: nil)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let text = messageField.text, !text.isEmpty, !currentchat.isEmpty {
            print("Sending: \(text)")
            messageField.text = ""
            db.collection("chats").document(currentchat).collection("messages").addDocument(data: [  // Hopefully by the time the first message is sent we already know what currentchat is actually i'll just add a check in the big if statement
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
        } else {
            print("Message is blank or currentchat is not set")
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
