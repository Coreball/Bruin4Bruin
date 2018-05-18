//
//  EditAccountViewController.swift
//  Bruin4Bruin
//
//  Created by Student on 5/3/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit
import Firebase

class EditAccountViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    
    @IBOutlet var textFields: [UITextField]!  // Email, Password, Confirm Password, First Name, Last Name in that order
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var isCreatingAccount = false
    var skipToMessaging = false
    var originY: CGFloat = 0.0
    var prePopulatedOriginals: [String?] = Array<String?>(repeating: nil, count: 5)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gradient
        let topColor = UIColor(red: (15/255.0), green: (118/255.0), blue: (128/255.0), alpha: 1)
        let bottomColor = UIColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Text fields
        for field in textFields {
            field.delegate = self
        }
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))  // Hide keyboard when tapping outside field
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditAccountViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(EditAccountViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let distance = originY - keyboardSize.height
            if distance < 0 {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height / 2)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.transform = .identity
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        originY = textField.frame.origin.y + textField.frame.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isCreatingAccount {
            saveButton.title = "Finish"
        } else if skipToMessaging {
            performSegue(withIdentifier: "EditAccountToMessaging", sender: nil)
        } else {
            saveButton.title = "Save"
            populateTextFields()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for field in textFields {
            field.resignFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if isCreatingAccount {
            if validateTextFields(checkPassword: true), let email = textFields[0].text, let password = textFields[1].text {
                Auth.auth().createUser(withEmail: email, password: password) { user, error in
                    if let user = user {
                        print("\(type(of: self)) successfully created new user")
                        print("User ID: \(user.uid)")
                        print("Email: \(user.email!)")
                        self.db.collection("users").document(user.uid).setData([
                            "first" : self.textFields[3].text!,
                            "last" : self.textFields[4].text!,
                            "currentchat" : "",  // Needed for waiting screen to count as in pool
                            "pwd" : self.textFields[1].text!,
                            "joined" : Timestamp()
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Successfully wrote to \(user.email!) document")
                                self.performSegue(withIdentifier: "EditAccountToWaiting", sender: nil)
                            }
                        }
                        let profilePicRef = Storage.storage().reference().child("users/\(user.uid)/profilePicture.png")
                        profilePicRef.putData(UIImagePNGRepresentation(self.imageView.image!)!)  // Upload the profile picture
                    } else {
                        print(error!.localizedDescription)
                        let confirmAlert = UIAlertController(title: "Error creating account", message: error!.localizedDescription, preferredStyle: .alert)
                        confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(confirmAlert, animated: true, completion: nil)
                    }
                }
            } else {
                print("Text field failed to pass validation")
            }
        } else {
            // save and return to settings
            print("Save Edit Account")
            var canSave: Bool
            if !textFields[1].text!.isEmpty || !textFields[2].text!.isEmpty {
                canSave = validateTextFields(checkPassword: true)
            } else {
                canSave = validateTextFields(checkPassword: false)
            }
            if canSave {
                var proceed = true
                if textFields[0].text != prePopulatedOriginals[0] {
                    Auth.auth().currentUser?.updateEmail(to: textFields[0].text!, completion: nil)
                }
                if !textFields[1].text!.isEmpty {
                    if textFields[1].text!.count >= 6 {
                        Auth.auth().currentUser?.updatePassword(to: textFields[1].text!, completion: nil)
                        db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["pwd" : textFields[1].text!])
                    } else {
                        let confirmAlert = UIAlertController(title: "Error updating password", message: "Password must be at least 6 characters", preferredStyle: .alert)
                        confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(confirmAlert, animated: true, completion: nil)
                        proceed = false
                    }
                }
                if textFields[3].text != prePopulatedOriginals[3] {
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["first" : textFields[3].text!])
                }
                if textFields[4].text != prePopulatedOriginals[4] {
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["last" : textFields[4].text!])
                }
                if proceed {
                    performSegue(withIdentifier: "UnwindToSettingsFromEditAccount", sender: nil)
                }
            }
        }
    }
    
    
    func validateTextFields(checkPassword: Bool) -> Bool {
        
        var isValid = true
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if !emailTest.evaluate(with: textFields[0].text) {  // Test if email is valid
            textFields[0].layer.borderColor = UIColor.red.cgColor
            isValid = false
        } else {
            textFields[0].layer.borderColor = UIColor.white.cgColor
        }
        
        if checkPassword {  // We don't want to check password if we have already made account since they can't be pre-populated, only check if user wants it changed
            if textFields[1].text != textFields[2].text || textFields[1].text!.isEmpty {  // Test if passwords do not match or are empty
                textFields[1].layer.borderColor = UIColor.red.cgColor
                textFields[2].layer.borderColor = UIColor.red.cgColor
                isValid = false
            } else {
                textFields[1].layer.borderColor = UIColor.white.cgColor
                textFields[2].layer.borderColor = UIColor.white.cgColor
            }
        } else {
            textFields[1].layer.borderColor = UIColor.white.cgColor  // Always valid password then
            textFields[2].layer.borderColor = UIColor.white.cgColor
        }
        
        if textFields[3].text!.isEmpty {  // Test if First Name is blank
            textFields[3].layer.borderColor = UIColor.red.cgColor
            isValid = false
        } else {
            textFields[3].layer.borderColor = UIColor.white.cgColor
        }
        
        if textFields[4].text!.isEmpty {  // Test if Last Name is blank
            textFields[4].layer.borderColor = UIColor.red.cgColor
            isValid = false
        } else {
            textFields[4].layer.borderColor = UIColor.white.cgColor
        }
        
        return isValid
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)  // Hide field when pressing return button
        return true
    }
    
    func populateTextFields() {
        prePopulatedOriginals = Array<String?>(repeating: nil, count: 5)
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).getDocument { document, error in
                guard let document = document, document.exists, let data = document.data() else {
                    print("Error getting document for pre-population: \(String(describing: error))")
                    return
                }
                self.prePopulatedOriginals[3] = data["first"] as? String ?? ""  // I'm using that nil-coalescing operator
                self.prePopulatedOriginals[4] = data["last"] as? String ?? ""
                self.textFields[3].text = self.prePopulatedOriginals[3]
                self.textFields[4].text = self.prePopulatedOriginals[4]
            }
            prePopulatedOriginals[0] = Auth.auth().currentUser?.email
            textFields[0].text = prePopulatedOriginals[0]
        } else {
            print("Could not pre-populate text fields!")
        }
    }
    
    @IBAction func accessImage(_ sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self  // WE ARE USING DELEGATES SEEE
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        imageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        isCreatingAccount = false
        skipToMessaging = false
        if let waiting = segue.destination as? WaitingViewController {
            waiting.cameFromEditAccount = true
        }
    }
    
    // Unwind here (probably from Waiting)
    @IBAction func unwindToEditAccount(segue: UIStoryboardSegue) {
        
    }

}
