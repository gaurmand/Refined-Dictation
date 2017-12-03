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
    
    func testPlayground() {
        let a = [("A", 1, 25), ("B", 2, 26)]
        let b = a.map {
            ($0.0, $0.1)
        }
        print(b)
    }
    
    
//    func testUserInit(){
//        let tstUsr = User.init()
//        XCTAssertNotNil(tstUsr)
//    }
//
//    // MARK: stub
//    func testrecog(){
//        let tstUsr = User.init()
//        let tstRecog = SpeechRecog(usr: tstUsr)
//        XCTAssertNotNil(tstRecog)
//    }
//
//    func testupdateIfEdited(){
//        let tstUsr = User.init()
//        let filteredStr = "hello world my dudes"
//        let result = FinalResult(usr: tstUsr, before: filteredStr)
//        let after = "hello? world a .dudes"
//        result.updateIfEdited(after: after)
//    }
//

    
    
}
