//
//  HistoryTableViewController.swift
//  Refined Dictation
//
//  Created by Serran N on 11/27/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController, UISearchResultsUpdating {
    var usrFilterLib: CommonFilter?
    var recording: SpeechRecog?
    var filtering: SpeechFilter?
    var finalRes: FinalResult?
    var History = [Dictation]()
    var DisplayedResults = [Dictation]()
    
    let searchController = UISearchController(searchResultsController: nil) //needed for search bar and searching
    
    //Nested Dictation Class
    class Dictation{
        var phrase: String
        var date: String
        var isFavourite: Bool
        
        init(_ a: String, _ b: String, _ c: Bool){
            phrase = a
            date = b
            isFavourite = c
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let DDay = "Nov-28-17"
        History = [Dictation("ayy", DDay, false), Dictation("result", DDay, true), Dictation("w", DDay, true), Dictation("memory", DDay, true), Dictation("Haalf", DDay, false), Dictation("num", DDay, true), Dictation("numb", DDay, false), Dictation("number", DDay, true), Dictation("I", DDay, false), Dictation("between the", DDay, false), Dictation("ijk", DDay, true)]
        DisplayedResults = History
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for past dictations"
        self.tableView.tableHeaderView = self.searchController.searchBar
        definesPresentationContext = true
        
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
        return 1    //only one section required
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if(searchController.isActive && searchController.searchBar.text != "")
        return DisplayedResults.count   // should return number of results in history
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "HistoryCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HistoryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CustomTableViewCell.")
        }
        
        // Configure the cell...
        let currentResult = DisplayedResults[indexPath.row]
        cell.TextLabel.text = currentResult.phrase
        cell.DateLabel.text = currentResult.date
        
        if(currentResult.isFavourite){   //if result is favourited set image to solid heart
            cell.FavouriteImage.image = UIImage(named: "solidheart")
        }
        else{   //if result is not favourited set image to hollow heart
            cell.FavouriteImage.image = UIImage(named: "hollowheart")
        }
        
        return cell
    }
    
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

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? VerificationViewController {
            filtering?.filteredResult = DisplayedResults[(tableView.indexPathForSelectedRow?.row)!].phrase //makes filtered result equal to the string in the selected cell
            destinationViewController.filtering = filtering
         }
    }
    
    //MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if(searchController.searchBar.text != ""){
            var tempArr = [Dictation]()
            for string in History{
                if(string.phrase.lowercased().contains(searchController.searchBar.text!.lowercased())){
                    tempArr.append(string)
                }
            }
            DisplayedResults = tempArr
        }
        else{
            DisplayedResults = History
        }
        tableView.reloadData()
    }
    

}
