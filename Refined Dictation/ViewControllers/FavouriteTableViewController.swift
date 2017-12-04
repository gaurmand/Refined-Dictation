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
    var Favourites = [(String, NSDate, Bool)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Favourites = ["ayy", "dispose of", "uncomment", "right", "bar button", "recreate", "table", "numb", "number", "numberof", "didReceiveMemoryWarning", "o", "a", "n", "I", "dequeue"]
        Favourites = RecentDictsAndFavs.favourites
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

        
        // Configure the cells...
        cell.TextLabel.text = Favourites[indexPath.row].0
        
        // Format NSDate to String
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Favourites[indexPath.row].1 as Date)
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        cell.DateLabel.text = myStringafd
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? VerificationViewController {
            filtering?.filteredResult = Favourites[(tableView.indexPathForSelectedRow?.row)!].0   //set filtered result equal to the string displayed in the selected cell
            destinationViewController.filtering = filtering
        }
    }
 

}
