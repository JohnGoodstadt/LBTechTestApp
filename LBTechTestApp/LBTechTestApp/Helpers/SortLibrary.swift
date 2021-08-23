//
//  SortLibrary.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 22/08/2021.
//

import Foundation
import LBEntities

public class SortLibrary {
	
	@objc public static func sortAndFilterToTopLevelGroups(_ groups:[LBEntities.RecallGroup]) -> [LBEntities.RecallGroup]{
		
		var parentList = [LBEntities.RecallGroup]()
		
		if groups.isEmpty {
			return parentList
		}
		
		//sort by titles
		let groupsSorted = groups.sorted(by: { (lhs: LBEntities.RecallGroup, rhs: LBEntities.RecallGroup) -> Bool in
			
			if GlobalVariables.singleton.appSettings.sortbystrippingaccents {
				return  lhs.title.forNonDiatricicSorting < rhs.title.forNonDiatricicSorting
			}else{
				return  lhs.title < rhs.title
			}
		})
		
		for group in groupsSorted {

			if group.hasParent { //if has a parent then not top level
				continue
			}
			
			parentList.append(group)
		}
		
		return parentList
	}
	
}
