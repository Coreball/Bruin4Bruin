//
//  ViewController.swift
//  Bruin4Bruin
//
//  Created by Changyuan Lin on 4/29/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {  // View will appear also covers returning from another screen
        self.navigationController?.navigationBar.isHidden = true  // Hide the navbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.navigationBar.isHidden = false  // Show the navbar again
    }

}

