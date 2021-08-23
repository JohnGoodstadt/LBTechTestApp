//
//  LBTechTestAppTests.swift
//  LBTechTestAppTests
//
//  Created by John goodstadt on 22/08/2021.
//

import XCTest
@testable import LBTechTestApp
import LBEntities

class LBRecallItemTests: XCTestCase {

	var itemsAndGroups = ([ LBEntities.RecallItem](),[ LBEntities.RecallGroup]())
	
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
		self.itemsAndGroups = AppLibrary.loadJSONInBundleAndProcess()
		
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		itemsAndGroups = ([ LBEntities.RecallItem](),[ LBEntities.RecallGroup]())
    }



	func testRecallItemTitles() throws {
		
		self.itemsAndGroups.0.forEach {
			XCTAssert($0.title.isNotEmpty(),"empty title")
		}
	}
	func testRecallItemHasGroup() throws {
		
		self.itemsAndGroups.0.forEach {
//			print($0.title)
//			if $0.recallGroup == nil {
//				print("no group:\($0.title) \($0.UID)")
//			}
			XCTAssert($0.busDepotUID.isNotEmpty(),"empty group ")
			XCTAssertNotNil($0.recallGroup,"empty group test")
		}
	}
	func testGroupHasItems() throws {
		
		self.itemsAndGroups.1.forEach {
			
			if !$0.hasChild {
				XCTAssert($0.itemList.isNotEmpty(),"empty items in group")
			}
	
			if $0.hasChild {
				XCTAssert($0.itemList.isEmpty,"empty items in group")
			}
			
		}
	}
	
	

}
