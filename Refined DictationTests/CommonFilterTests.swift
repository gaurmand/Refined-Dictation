//
//  CommonFilterTests.swift
//  Refined DictationTests
//
//  Created by Serran N on 11/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import XCTest
@testable import Refined_Dictation

class CommonFilterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //For testConstructor() to work, change filename from "ExcludedCommonWordsList" to "ExcludedCommonWordsList(test)" in CommonFilter constructor in dataObjs.swift
    /*func testConstructor(){
        let testUser = User()
        let testObj = CommonFilter(usr:testUser)
        
        XCTAssert(testObj.ExcludedCommonWords["the"] == true)
        XCTAssert(testObj.ExcludedCommonWords["i"] == true)
        XCTAssert(testObj.ExcludedCommonWords["with"] == true)
        XCTAssert(testObj.ExcludedCommonWords["some"] == true)
    }*/
    
    func testAddtoList() {
        let testUser = User()
        let testObj = CommonFilter(usr:testUser)
        testObj.ExcludedCommonWords["b2"] = false
        testObj.ExcludedCommonWords["c3"] = true
        
        //"a" not in ExcludedCommonWords, should be added succesfully to UserFilterWords
        XCTAssert(testObj.addToList(word: "a1"))
        //"b" is in ExcludedCommonWords, but its value is false, should be added succesfully to UserFilterWords
        XCTAssert(testObj.addToList(word: "b2"))
        //"c" is in ExcludedCommonWords, and its value is true, should not be added succesfully to UserFilterWords
        XCTAssert(!testObj.addToList(word: "c3"))
        //asserts a & b were added to UserFilterWords dictionary, but not c
        XCTAssert(testObj.UserFilterWords["a1"]!)
        XCTAssert(testObj.UserFilterWords["b2"]!)
        XCTAssert(testObj.UserFilterWords["c3"] == nil)
    }
    
    func testRmFromList() {
        let testUser = User()
        let testObj = CommonFilter(usr:testUser)
        testObj.UserFilterWords["b2"] = false
        testObj.UserFilterWords["c3"] = true
        
        //"a" is not in UserFilterWords, should just return true
        XCTAssert(testObj.rmFromList(word: "a1"))
        //"b" is in UserFilterWords, but its value is false, should just return true
        XCTAssert(testObj.rmFromList(word: "b2"))
        //"c" is in UserFilterWords, and its value is true, should remove entry and return true
        XCTAssert(testObj.rmFromList(word: "c3"))
        // asserts a is not in UserFilterWords dictionary,and that b & c are removed
        XCTAssert(testObj.UserFilterWords["a1"] == nil)
        XCTAssert(testObj.UserFilterWords["b2"] == false)
        XCTAssert(testObj.UserFilterWords["c3"] == false)
    }
    
    func testIsOnList() {
        let testUser = User()
        let testObj = CommonFilter(usr:testUser)
        testObj.UserFilterWords["b2"] = false
        testObj.UserFilterWords["c3"] = true
        
        //"a" is not in UserFilterWords, should return false
        XCTAssert(!testObj.isOnList(word: "a1"))
        //"b" is in UserFilterWords, but its value is false, should return false
        XCTAssert(!testObj.isOnList(word: "b2"))
        //"c" is in UserFilterWords, and its value is true, should return true
        XCTAssert(testObj.isOnList(word: "c3"))
    }


    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
