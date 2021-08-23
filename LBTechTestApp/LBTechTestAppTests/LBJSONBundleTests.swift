//
//  LBTechTestAppTests.swift
//  LBTechTestAppTests
//
//  Created by John goodstadt on 22/08/2021.
//

import XCTest
@testable import LBTechTestApp
import LBEntities

class LBJSONBundleTests: XCTestCase {

	var itemsAndGroups = ([ LBEntities.RecallItem](),[ LBEntities.RecallGroup]())
	
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
		self.itemsAndGroups = AppLibrary.loadJSONInBundleAndProcess()
		
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		itemsAndGroups = ([ LBEntities.RecallItem](),[ LBEntities.RecallGroup]())
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		
		XCTAssertEqual(1,1)
		XCTAssertNotEqual(1,0)
    }

	func testBundleJSON() throws {
		
		
		XCTAssertEqual(33,self.itemsAndGroups.0.count,"json item test")
		XCTAssertEqual(15,itemsAndGroups.1.count,"json group test")
		
	}
	
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
