//
//  WaitingViewController.swift
//  Bruin4Bruin
//
//  Created by Student on 5/10/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {
    
    var cameFromEditProfile = false

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
