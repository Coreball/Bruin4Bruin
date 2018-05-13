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
    
    var cameFromEditProfile = false
    var uid = ""
    var currentchat = ""
    var partner = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change background
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pineapples")!)
        
        let topColor = UIColor(red: (15/255.0), green: (118/255.0), blue: (128/255.0), alpha: 1)
        let bottomColor = UIColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
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
        // Right order??
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
                self.db.collection("chats").document(self.currentchat).updateData(["ended" : Timestamp()])  // Write that this chat has ended at this time
                self.fixPartner()
                self.db.collection("users").document(self.uid).updateData(["currentchat" : ""])
            } else {
                print("Couldn't find current chat!")
            }
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
            self.db.collection("users").document(self.partner).updateData(["currentchat" : ""])  // Remove the partner's current chat
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
