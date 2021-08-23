//
//  SamplesToCache.swift
//  Udemy Chants
//
//  Created by John goodstadt on 01/01/2021.
//  Copyright © 2021 John Goodstadt. All rights reserved.
//

import Foundation
//represents the JSON file structure
public class BundleGroupsAndItems : Decodable {
	
	//NOTE: same as firestore db - items and groups
	
	public var groups = [RecallGroup]()
	public var items = [RecallItem]()
	public var timestamp = Date()

	public init() {} //or else a default is created
	
}
