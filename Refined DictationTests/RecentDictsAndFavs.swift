//
//  FirebaseDatabaseTests.swift
//  Refined DictationTests
//
//  Created by Shawn Wang on 12/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

import XCTest
import Firebase
@testable import Refined_Dictation

class RecentDictsAndFavs: XCTestCase {
    let ref = Database.database().reference()

    // MARK: test for retrieving history
    func testRetrieving(){
        userID = "nYDA3eNIF7dRUTPHWL5INHv60DX2"
        
        // Clear to prepare for re-populate
        if (RecentDictsAndFavs.recentDictations.count != 0) {
            RecentDictsAndFavs.recentDictations.removeAll()
        }
        if (RecentDictsAndFavs.favourites.count != 0) {
            RecentDictsAndFavs.favourites.removeAll()
        }
        
        // get the past HISTORY_GO_BACK_DATE_COUNT dictation records
        let backupDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
        let backupTime = Double((backupDate.timeIntervalSince1970 * 1000.0).rounded())
        // queryEndingAtValue(ServerValue.timestamp()) is implied
        ref.child("users/\(userID)/dictations").queryOrdered(byChild: "timestamp").queryStarting(atValue: backupTime).observeSingleEvent(of: .value, with: { (snapshot) in
            let ret = snapshot.value as? [(String, String?, String?, Double, Double, TimeInterval, Bool)] ?? []
            recentDictations = ret.map {
                ($0.2 ?? ($0.1 ?? $0.0), NSDate(timeIntervalSince1970: $0.5/1000), $0.6)  // divide by 1000 to get seconds: https://stackoverflow.com/a/30244373
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        print(recentDictations)
        
        
    }

}
