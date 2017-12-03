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

class FirebaseDatabaseTests: XCTestCase {

    let ref = Database.database().reference()

    // MARK: create a new nameless node
    func testNewNamelessNode(){
        let key = ref.child("users").childByAutoId().key
        let post = ["rawResult": "rawResult",
                    "filteredResult": "filter",
                    "editedResult": "Result ?? ",
                    "STTTime": 0.12312,
                    "filterTime": 0.12312,
                    "timestamp": ServerValue.timestamp(),    // timestamping firebase data: https://stackoverflow.com/a/30244373
            // This is stored in miliseconds since EPOCH time, in UTC
            "Favourited": false
            ] as [String : Any]
        let childUpdates = ["/users/3UcnRHL9B7WOqaylnjXeE0WSMVi2/dictations/\(key)/": post]
        ref.updateChildValues(childUpdates)

        
    }



}
