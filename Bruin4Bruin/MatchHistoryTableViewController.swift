//
//  MatchHistoryTableViewController.swift
//  Bruin4Bruin
//
//  Created by Changyuan Lin on 5/19/18.
//  Copyright © 2018 Changyuan Lin. All rights reserved.
//

import UIKit
import Firebase

class MatchHistoryTableViewController: UITableViewController {

    let db = Firestore.firestore()
    
    var matchHistory = [QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateMatchHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMatchHistory() {
        print("update match history")
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("history").order(by: "ended", descending: true).getDocuments {  querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error getting documents for match history: \(error!.localizedDescription)")
                return
            }
            self.matchHistory = documents
            let content = documents.map { $0["friendlypartner"]! }
            print("Previous Partners: \(content)")
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchHistory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchHistoryTableViewCell", for: indexPath) as? MatchHistoryTableViewCell else {
            fatalError("Dequeued cell is not MatchHistoryTableViewCell")
        }

        // Configure the cell...
        if let name = matchHistory[indexPath.row].data()["friendlypartner"] as? String {
            cell.partnerName.text = name
        }
        if let time = matchHistory[indexPath.row].data()["ended"] as? Timestamp {
            cell.timestamp.text = "Ended on \(DateFormatter.localizedString(from: time.dateValue(), dateStyle: .medium, timeStyle: .medium))"
        }

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
