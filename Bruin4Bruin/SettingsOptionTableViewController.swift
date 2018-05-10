//
//  SettingsOptionTableViewController.swift
//  
//
//  Created by Student on 5/9/18.
//

import UIKit

class SettingsOptionTableViewController: UITableViewController {

    var options = [Options]()
    
    private func loadOptions() {
        
        guard let messaging = Options(name: "Messaging") else {
            fatalError("Unable to instantiate messaging")
        }
        
        guard let editProfile = Options(name: "Edit Profile") else {
            fatalError("Unable to instantiate editProfile")
        }
        
        guard let savedPeople = Options(name: "Saved People") else {
            fatalError("Unable to instantiate savedPeople")
        }
        
        guard let newConnection = Options(name: "New Connection") else {
            fatalError("Unable to instantiate newConnection")
        }
        
        guard let logout = Options(name: "Logout") else {
            fatalError("Unable to instantiate logout")
        }
        
        options += [messaging, editProfile, savedPeople, newConnection, logout]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOptions()
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        }else if indexPath.row == 1{
            //Settings to Edit Screen
            performSegue(withIdentifier: "settingsToEdit", sender: indexPath)
        }else if indexPath.row == 2{
            
        }else if indexPath.row == 3{
            
        }else if indexPath.row == 4{
            //Goes back to the root controller, but I think it does pop the controllers.
            self.dismiss(animated: true, completion: {});
            self.navigationController?.popViewController(animated: true);
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SettingsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let option = options[indexPath.row]
        cell.labelName.text = option.name
        
        
        return cell
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

}
