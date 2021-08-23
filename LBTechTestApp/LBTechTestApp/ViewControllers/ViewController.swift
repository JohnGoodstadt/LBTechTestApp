//
//  ViewController.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 22/08/2021.
//

import UIKit
import LBEntities


class ViewController: UIViewController, ViewControllerDelegate {

	

	@IBOutlet weak var tableview: UITableView!

	//access to internet data
	private var dataProvider: DataProvider = GlobalVariables.singleton.dataProvider
	
	
	//ivars
	var datasource:ViewControllerDataSource?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		
		setupDataSources()
		
		initialLoadAndDisplay()
		
	}
	//Handle iOS memory warnings
	override func didReceiveMemoryWarning(){
		
		GlobalVariables.singleton.busesNoOrderFromDB.forEach{
			if $0.audio.isNotEmpty(){
				$0.audio = Data() //will load from disk or internet next time
			}
		}
		
	}
	//MARK: - delegate functions
	func didTapGroup(_ recallGroup:LBEntities.RecallGroup) {
		print("did tap group \(recallGroup.title) \(recallGroup.UID.prefix(4))")
		
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
	
	fileprivate func setupDataSources() {
		
		//set up seperate datasource class to be used
		self.datasource = ViewControllerDataSource(groups: GlobalVariables.singleton.groups,delegate: self)
		self.datasource?.tableview = self.tableview
		
		self.tableview.dataSource = self.datasource
		self.tableview.delegate = self.datasource

	}
	/**
	 `setupUI` get UI ready for data
	 
	*/
	func setupUI(){
		
		self.title = "AppTitle".branded //uses strings file
		
	}
	/**
	 `fromModelToDataSource` make model object ready for UITableview via a datasource
	 
	*/
	fileprivate func fromModelToDataSource(_ list:[LBEntities.RecallGroup] = [LBEntities.RecallGroup] ()) {
		
		let topLevelGroups = SortLibrary.sortAndFilterToTopLevelGroups(list)
		
		self.datasource?.populateCellGroups(topLevelGroups)
		
		self.tableview.reloadData()
		
	}
	/**
	 `initialLoadAndDisplay` get the initial data from either the app bundle or the internet
	 
	 AppSettings controls the end point
	*/
	private func initialLoadAndDisplay(){
		
		
		if GlobalVariables.singleton.appSettings.readsamplesfrombundleonload {
			//use saved data in bundle
			let itemsAndGroups = AppLibrary.loadJSONInBundleAndProcess()
			
			GlobalVariables.singleton.busesNoOrderFromDB = itemsAndGroups.items
			GlobalVariables.singleton.groups = itemsAndGroups.groups
			
			print(" groups:\(GlobalVariables.singleton.groups.count)")
			print(" items: \(GlobalVariables.singleton.busesNoOrderFromDB.count)")
			
			fromModelToDataSource(GlobalVariables.singleton.groups)

			
		}else{
			//go to API for live data
			if dataProvider.isCurrentUserUnknown(){
				dataProvider.loginAsAnon(){uid,err in
					if err { //bad problem - maybe no internet on first install
						print("**** No google uid - no anon login!! ****") //1. firestore not setup yet - law 2. sign in method not set
						return
					}else{
						print("google user is:\(self.dataProvider.getCurrentUserid())")
					}
				}
			}else{
				print("google userid is:\(self.dataProvider.getCurrentUserid())")
			}
			//we have a valid google user
			
			dataProvider.initialLoad() { groups, items, errorBool in
				if errorBool {
					print("Something went wrong loading from google - first load user not logged in as anon yet")
					return
				}
				
				let itemsAndGroups = AppLibrary.joinItemsToGroups(items, groups)
				
				GlobalVariables.singleton.busesNoOrderFromDB = itemsAndGroups.items //moved from original framework layer
				GlobalVariables.singleton.groups = itemsAndGroups.groups
				
				self.fromModelToDataSource(GlobalVariables.singleton.groups)
			}
			
			
		}
		
		
	}

}

