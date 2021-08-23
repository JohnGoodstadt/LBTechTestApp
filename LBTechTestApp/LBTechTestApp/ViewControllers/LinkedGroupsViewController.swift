//
//  LinkedGroupViewController.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 22/08/2021.
//

import UIKit
import LBEntities


class LinkedGroupsViewController: UIViewController, ViewControllerDelegate {

	

	
	@IBOutlet weak var tableview: UITableView!
	
	//passed in arg
	public var recallGroup:LBEntities.RecallGroup! //cannot do without this
	
	//ivars
	var datasource:ViewControllerDataSource?
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setupUI()
		
		setupDataSources()
		
    }
    
	func setupUI(){
		
		self.title = self.recallGroup.title
		
	}
	fileprivate func setupDataSources() {
		
		
		let groups = getGroupList(self.recallGroup.groupUIDList)
		
		//set up seperate datasource class to be used
		self.datasource = ViewControllerDataSource(groups: groups,delegate: self)
		self.datasource?.tableview = self.tableview
		
		self.tableview.dataSource = self.datasource
		self.tableview.delegate = self.datasource
		
		
	}
	
	fileprivate func getGroupList(_ UIDs: [String]) -> [LBEntities.RecallGroup]{
		
		var groups = [LBEntities.RecallGroup]()
		
		
		UIDs.forEach{
			let UID = $0
			if let group = GlobalVariables.singleton.groups.first(where:  { $0.UID == UID }){
				groups.append(group)
			}
		}
		
		
		return groups
		
	}

	//MARK: delegate callbacks
	func didTapGroup(_ recallGroup: RecallGroup) {
		print("didTapGroup \(recallGroup)")
		
		if  recallGroup.hasChild {
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(withIdentifier: "LinkedGroupsViewControllerSBID") as! LinkedGroupsViewController
			vc.recallGroup = recallGroup

			navigationController?.pushViewController(vc, animated: true)

		}else{
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(withIdentifier: "RecallGroupViewControllerSID") as! RecallGroupViewController
			vc.recallGroup = recallGroup
			
			navigationController?.pushViewController(vc, animated: true)

		}
	}
}
