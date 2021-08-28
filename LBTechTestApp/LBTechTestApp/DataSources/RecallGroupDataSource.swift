//
//  RecallGroupDataSource.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 22/08/2021.
//

import UIKit
import LBEntities

protocol RecallGroupDataSourceDelegate {
	func didTapItem(_ recallItem:LBEntities.RecallItem)
}
/**
 `RecallGroupDataSource` provide all the processing needed for a UITableview
 
 Requires a group which might have a list of items attached (itemlist), and a delegte for row taps
*/
class RecallGroupDataSource:NSObject,  UITableViewDataSource,UITableViewDelegate {

	

	private let delegate:RecallGroupDataSourceDelegate
	private var group:LBEntities.RecallGroup
	
	var tableview:UITableView?
	
	init(group:LBEntities.RecallGroup,delegate:RecallGroupDataSourceDelegate) {
		self.group = group
		self.delegate = delegate
	}
	
	func populateCells(_ group:LBEntities.RecallGroup) {
	
		self.group = group
	
	}
	//MARK: - Tableview Datasource Function
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.group.itemList.count
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

		return "Audio"
		
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		let cell = tableView.dequeueReusableCell(withIdentifier: "learningWithSubtitleCellID") as! LearningWithSubtitleTableViewCell
		
		
		guard self.group.itemList.isNotEmpty() else{
			return cell
		}
		
		let ri = self.group.itemList[indexPath.row]
		
		
		cell.titleLabel.text = ri.title
		cell.subtitleLabel.text = "\(ri.UID.prefix(4))"

//		if ri.thumbnail.isEmpty {
//			if let childThumbnail = self.group.itemList.first?.thumbnail {
//				cell.photoImageView.image = UIImage(data: childThumbnail)
//			}else{
//				cell.photoImageView.setDefaultThumbnail()
//			}
//		}else{
			cell.photoImageView.setThumbnailForRow(ri.thumbnail)
//		}
		
		
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		delegate.didTapItem(self.group.itemList[indexPath.row])

		tableView.deselectRow(at: indexPath, animated: true)
		
	}

}
