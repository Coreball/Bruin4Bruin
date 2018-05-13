//
//  EditProfileViewController.swift
//  Bruin4Bruin
//
//  Created by Student on 5/3/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {

    @IBOutlet weak var scrollInside: UIView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var textFields = [UITextField]()
    var profilePic: UIImage = #imageLiteral(resourceName: "defaultPhoto")
    let db = Firestore.firestore()
    var isCreatingAccount = false
    var skipToMessaging = false
    @IBOutlet var stacks: [TagStackView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollInside.frame.size.height = 5000
        loadStacks()
//        scrollInside.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 500)
//        scrollInside.frame = CGRect(x: 0, y: 0, self.view.safeAreaLayoutGuide.widthAnchor  )
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isCreatingAccount {
            saveButton.title = "Finish"
        } else if skipToMessaging{
            performSegue(withIdentifier: "EditProfileToMessaging", sender: nil)
        } else {
            saveButton.title = "Save"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func loadStacks() {
        for index in 0...3 {
            stacks[index].loadWithID(for: index)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if isCreatingAccount {
            Auth.auth().createUser(withEmail: textFields[0].text!, password: textFields[1].text!) { (user, error) in
                if let user = user {
                    print("\(type(of: self)) successfully created new user")
                    print("User ID: \(user.uid)")
                    print("Email: \(user.email!)")
                    self.db.collection("users").document(user.uid).setData([
                        "first" : self.textFields[3].text!,
                        "last" : self.textFields[4].text!,
                        "currentchat" : "",  // Needed for waiting screen to count as in pool
                        "joined" : Timestamp()
                        // Submit more things like BIO, etc.
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Successfully wrote to \(user.email!) document")
                        }
                    }
                    let profilePicRef = Storage.storage().reference().child("users/\(user.uid)/profilePicture.png")
                    profilePicRef.putData(UIImagePNGRepresentation(self.profilePic)!)  // Upload the profile picture
                    self.performSegue(withIdentifier: "EditProfileToWaiting", sender: nil)
                } else {
                    print(error!.localizedDescription)
                }
            }
        } else {
            // save the stuff and return to settings
            print("Pretending to save Edit Profile")
            performSegue(withIdentifier: "UnwindToSettingsFromEditProfile", sender: nil)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        isCreatingAccount = false  // Reset
        skipToMessaging = false
        if let waiting = segue.destination as? WaitingViewController {
            waiting.cameFromEditProfile = true
        }
    }
    
    @IBAction func unwindToEditProfile(segue: UIStoryboardSegue) {
        /// unwind
    }

}
