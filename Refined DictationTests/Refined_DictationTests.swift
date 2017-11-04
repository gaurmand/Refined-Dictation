//
//  Refined_DictationTests.swift
//  Refined DictationTests
//
//  Created by Admin on 30/10/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import XCTest
@testable import Refined_Dictation

class Refined_DictationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testUserInit(){
        let tstUsr = User.init()
        XCTAssertNotNil(tstUsr)
    }
    
    func testrecog(){
        let tstUsr = User.init()
        let tstRecog = SpeechRecog.init(usr: tstUsr)
        XCTAssertNotNil(tstRecog)
    }
    
}
