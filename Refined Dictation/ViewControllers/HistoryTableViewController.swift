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
    var History = [(String, NSDate?, Bool)]()
    var DisplayedResults = [(phrase: String, timestampInNSDate: NSDate?, favourited: Bool)]()
    
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

//        History = [Dictation("ayy", DDay, false), Dictation("result", DDay, true), Dictation("w", DDay, true), Dictation("memory", DDay, true), Dictation("Haalf", DDay, false), Dictation("num", DDay, true), Dictation("numb", DDay, false), Dictation("number", DDay, true), Dictation("I", DDay, false), Dictation("between the", DDay, false), Dictation("ijk", DDay, true)]
        History = RecentDictsAndFavs.recentDictations
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        History = RecentDictsAndFavs.recentDictations
        DisplayedResults = History
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
        cell.TextLabel.text = currentResult.0
        // Format NSDate to String
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: currentResult.1 as! Date)
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        cell.DateLabel.text = myStringafd
        
        if(currentResult.2){   //if result is favourited set image to solid heart
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
            //destinationViewController.finalRes = FinalResult(raw: "", filtered: filtering?.filteredResult, edited: "", STTT: 0, filterT: 0)
            destinationViewController.Dictation = DisplayedResults[(tableView.indexPathForSelectedRow?.row)!]
            destinationViewController.isPreviousViewRecord = false
            destinationViewController.isFavourite = DisplayedResults[(tableView.indexPathForSelectedRow?.row)!].2
         }
    }
    
    //MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if(searchController.searchBar.text != ""){
            var tempArr = [(phrase: String, timestampInNSDate: NSDate?, favourited: Bool)]()
            for elem in History{
                if(elem.0.lowercased().contains(searchController.searchBar.text!.lowercased())){
                    tempArr.append(elem)
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
