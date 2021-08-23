//
//  AppLibrary.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 22/08/2021.
//

import Foundation
import LBEntities


@objc public class AppLibrary: NSObject {
	
	
	public static func loadJSONInBundleAndProcess() -> (items:[ LBEntities.RecallItem],groups:[LBEntities.RecallGroup]) {
		

		var returnValue = ([ LBEntities.RecallItem](),[ LBEntities.RecallGroup]())
		
		let jsondata = loadJSONCachedSamplesFromResources()
		do{
			let bundleGroupsAndItems = try JSONDecoder().decode(LBEntities.BundleGroupsAndItems.self, from: jsondata)
			
			let itemsAndGroups = joinItemsToGroups(bundleGroupsAndItems.items, bundleGroupsAndItems.groups)
			
			returnValue = (itemsAndGroups.items,itemsAndGroups.groups)
			
			
		}catch{
			print(error)
		}
		
		return returnValue
		
	}
	private static func loadJSONCachedSamplesFromResources()-> Data {
		
		var returnValue = Data()
		
		//check
		guard GlobalVariables.singleton.appSettings.audioapp else {
			return returnValue
		}
		
		if let urlString = Bundle.main.path(forResource: CACHEDSAMPLES_FILENAME, ofType: "json") {
			
			if urlString.isNotEmpty() {
				do{
					let jsondata = try  Data(contentsOf: URL(fileURLWithPath: urlString))
					print(jsondata.count)
					if jsondata.count > 0 {
						returnValue = jsondata
					}
					
				}catch {
					print(error)
					print("============================================")
					print("====>ERROR READING CACHED SAMPLES JSON <====")
					print("============================================")
				}
			}
		}
		
		
		return returnValue
	
	}
	/*
	send in 2 seperate array - items and groups
	link them together - all items have a group to attaach to.
	*/
	static func joinItemsToGroups(_ items: [ LBEntities.RecallItem], _ groups: [LBEntities.RecallGroup]) -> (items:[ LBEntities.RecallItem],groups:[LBEntities.RecallGroup]){
		
		
		guard items.isEmpty == false && groups.isEmpty == false else{
			return (items,groups)
		}
		
		
		//1. make lookup dict for performance
		//2. for each item lookup group and assign
		
		print("\(Date()) read groups: \(groups.count) rows, items: \(items.count) rows")
		
		let lookupDict = groups.toDictionary { $0.UID }
		
		
		//A points to B and B has a list of A's
		for ri in items {

			if ri.busDepotUID.isEmpty == false {
				
				let key = ri.busDepotUID
				
				if let rg = lookupDict[key] {
					ri.recallGroup = rg
					rg.addItem(ri) //join the 2

				}
			}

		}
		
		return (items,groups)
		
	}
	
}
