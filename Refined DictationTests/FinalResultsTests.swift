//
//  FinalResultsTests.swift
//  Refined DictationTests
//
//  Created by Serran N on 12/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import XCTest
@testable import Refined_Dictation

class FinalResultsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUpdateIfEdited(){
        let A = FinalResult(raw: "sup my bro", filtered: "sup my bro", edited: "sup bro", STTT: 1, filterT: 1)
        A.updateIfEdited()
    }
    
    
}
