//
//  SettingsOptionTableViewController.swift
//  Bruin4Bruin
//
//  Created by Student on 5/9/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit

class SettingsOptionTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                print("Messaging")
            case 1:
                print("Saved People")
            case 2:
                print("Edit Account")
                performSegue(withIdentifier: "SettingsToEditAccount", sender: nil)
            default:
                print("Unexpected row index in section 0")
            }
        case 1:
            print("New Connection")
            let confirmAlert = UIAlertController(title: "New Connection", message: "This will end your current conversation!", preferredStyle: .alert)
            confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                self.performSegue(withIdentifier: "SettingsToWaiting", sender: nil)
            }))
            confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Cancelled new connection")
            }))
            present(confirmAlert, animated: true, completion: nil)
        case 2:
            print("Logout")
            performSegue(withIdentifier: "UnwindToLoginFromSettings", sender: nil)
        default:
            print("Unexpected section index in Settings")
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToSettings(segue: UIStoryboardSegue) {
        // Come back to settings
    }

}
