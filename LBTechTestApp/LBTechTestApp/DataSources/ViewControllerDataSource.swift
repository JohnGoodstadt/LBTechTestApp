//
//  ViewControllerDataSource.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 22/08/2021.
//

import Foundation
import UIKit
import LBEntities

protocol ViewControllerDelegate {
	func didTapGroup(_ recallGroup:LBEntities.RecallGroup)
}

/**
 `ViewControllerDataSource` provide all the processing needed for a UITableview
 
 Requires an array of groups and a delegte for row taps
*/
class ViewControllerDataSource: NSObject, UITableViewDataSource,UITableViewDelegate {

	private let delegate:ViewControllerDelegate
	private var groups:[LBEntities.RecallGroup]
	
	var tableview:UITableView?
	
	init(groups:[LBEntities.RecallGroup],delegate:ViewControllerDelegate) {
		self.groups = groups
		self.delegate = delegate
	}
	
	func populateCellGroups(_ groups:[LBEntities.RecallGroup]) {
		self.groups = groups
	}

	//MARK: - Tableview Datasource Function
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.groups.count
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.groups[section].title
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		let cell = tableView.dequeueReusableCell(withIdentifier: "groupSummaryCellID") as! GroupSummaryTableViewCell
		
		guard self.groups.isNotEmpty() else{
			return cell
		}
		
		let rg = self.groups[indexPath.section]
		
		var groupType = "words".branded
		var childCount = rg.groupUIDList.count
		if rg.hasChild {
			groupType = "groups".branded
		}else{
			childCount = rg.itemList.count
		}
		
		cell.titleLabel.text = "\(childCount) \(groupType)"
		cell.summaryTitleLabel.text = "\(rg.UID.prefix(4))"
		
		//cell.photoImageView.setThumbnailForRow(rg.thumbnail)
		if rg.thumbnail.isEmpty {
			if (rg.itemList.first?.thumbnail.count == 0) {
				cell.photoImageView.setDefaultThumbnail()
			}else{
				if let thumbnail = rg.itemList.first?.thumbnail{
					cell.photoImageView.image = UIImage(data: thumbnail)
				}else{
					cell.photoImageView.setDefaultThumbnail()
				}
			}
		}else{
			cell.photoImageView.setThumbnailForRow(rg.thumbnail)
		}
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let rg = self.groups[indexPath.section]

		delegate.didTapGroup(rg)

		tableView.deselectRow(at: indexPath, animated: true)
		
	}
}
