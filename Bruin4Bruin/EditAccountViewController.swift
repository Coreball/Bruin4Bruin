//
//  EditAccountViewController.swift
//  Bruin4Bruin
//
//  Created by Student on 5/3/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit

class EditAccountViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    @IBOutlet var textFields: [UITextField]!  // Email, Password, Confirm Password, First Name, Last Name in that order
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    var isCreatingAccount = false

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
        
        //text field borders
        for textbox in textFields {
            textbox.layer.masksToBounds = true
            textbox.layer.borderColor = UIColor.white.cgColor
            textbox.layer.borderWidth = 0.75
            textbox.layer.cornerRadius = 6
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isCreatingAccount {
            saveButton.title = "Next"
        } else {
            saveButton.title = "Save"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if isCreatingAccount {
            if validateTextFields() {
                performSegue(withIdentifier: "EditAccountToEditProfile", sender: nil)
            }
        } else {
            // save and return to settings
            print("Pretending to save Edit Account")
            performSegue(withIdentifier: "UnwindToSettingsFromEditAccount", sender: nil)
        }
    }
    
    func validateTextFields() -> Bool {
        
        var isValid = true
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if !emailTest.evaluate(with: textFields[0].text) {  // Test if email is valid
            //textFields[0].layer.borderWidth = 0.75
            textFields[0].layer.borderColor = UIColor.red.cgColor
            isValid = false
        } else {
            textFields[0].layer.borderColor = UIColor.white.cgColor
        }
        
        if textFields[1].text != textFields[2].text || textFields[1].text!.isEmpty {  // Test if passwords do not match or are empty
            textFields[1].layer.borderColor = UIColor.red.cgColor
            textFields[2].layer.borderColor = UIColor.red.cgColor
            isValid = false
        } else {
            textFields[1].layer.borderColor = UIColor.white.cgColor
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
    
    
    @IBAction func accessImage(_ sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
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
        if let editProfileVC = segue.destination as? EditProfileViewController {  // If this is creating account make last button "Finish"
            editProfileVC.isCreatingAccount = true
            editProfileVC.textFields = textFields  // Pass on the user info we just got
            editProfileVC.profilePic = imageView.image!  // Pass on whatever image is currently selected
        }
    }
    

}
