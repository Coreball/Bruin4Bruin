//
//  WaitingViewController.swift
//  Bruin4Bruin
//
//  Created by Student on 5/10/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        if let editProfile = segue.destination as? EditProfileViewController {
            editProfile.skipToMessaging = true  // Unwind and then skip directly to messaging
        }
    }
    
    @IBAction func leavePressed(_ sender: UIButton) {
        if (self.parent as? EditProfileViewController) != nil {
            performSegue(withIdentifier: "UnwindToEditProfileFromWaiting", sender: nil)
        }
        if (self.parent as? MessagingViewController) != nil {
            performSegue(withIdentifier: "UnwindToMessagingFromWaiting", sender: <#T##Any?#>)
        }
    }
    
}
