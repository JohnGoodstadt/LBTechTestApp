//
//  LBEntitiesTests.swift
//  LBEntitiesTests
//
//  Created by John goodstadt on 22/08/2021.
//

import XCTest
@testable import LBEntities

class LBEntitiesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGroup() throws {

		let group = LBEntities.RecallGroup()
		
		XCTAssertFalse(group.hasChild,"default - no children")
		XCTAssertTrue(group.groupUIDList.isEmpty,"default - no child UIDs")
		XCTAssert(group.UID.count > 0,"assigned uuid")
    }

	func testItem() throws {
		
		let item = LBEntities.RecallItem()
	
		
		XCTAssert(item.UID.count > 0,"assigned uuid")
	}
	
	func testJoinItemToGroup(){
		
		let group = LBEntities.RecallGroup()
		group.title = "g1"
		
		let item = LBEntities.RecallItem()
		item.title = "i1"
		
		group.addItem(item)
		
		XCTAssertEqual(1,group.itemList.count,"1 item in this group")
		
	}
	
	/*
	Other tests to follow
	*/

}


