//
//  FavouriteTableViewController.swift
//  Refined Dictation
//
//  Created by Serran N on 11/27/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class FavouriteTableViewController: UITableViewController {
    var usrFilterLib: CommonFilter?
    var recording: SpeechRecog?
    var filtering: SpeechFilter?
    var finalRes: FinalResult?
    var Favourites = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Favourites = ["ayy", "dispose of", "uncomment", "right", "bar button", "recreate", "table", "numb", "number", "numberof", "didReceiveMemoryWarning", "o", "a", "n", "I", "dequeue"]

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
        return 1         //only one section required
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favourites.count         // should return number of favourites
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FavouriteCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavouriteTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CustomTableViewCell.")
        }

        // Configure the cell...
        cell.TextLabel.text = Favourites[indexPath.row]
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? VerificationViewController {
            filtering?.filteredResult = Favourites[(tableView.indexPathForSelectedRow?.row)!]   //set filtered result equal to the string displayed in the selected cell
            destinationViewController.filtering = filtering
        }
    }
 

}
