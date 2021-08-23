//
//  RecallGroupViewController.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 22/08/2021.
//

import UIKit
import LBEntities

class RecallGroupViewController: UIViewController, RecallGroupDataSourceDelegate {

	

	//passed in arg
	public var recallGroup:LBEntities.RecallGroup! //cannot do without this
	
	var datasource:RecallGroupDataSource?
	
	@IBOutlet weak var playNavButton: UIBarButtonItem!
	@IBOutlet weak var navItemToolbar: UINavigationItem!
	@IBOutlet weak var tableview: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setupUI()
		
		setupDataSources()
    }
	func setupUI(){
		
		self.navItemToolbar.title = self.recallGroup.title
		
	}
	fileprivate func setupDataSources() {
		
		//set up seperate datasource class to be used
		self.datasource = RecallGroupDataSource(group: self.recallGroup,delegate: self)
		self.datasource?.tableview = self.tableview
		
		self.tableview.dataSource = self.datasource
		self.tableview.delegate = self.datasource
		
		
	}
	//MARK: UI IBActions
	@IBAction func playNavButtonPressed(_ sender: Any) {

		
		let alert = UIAlertController(title: "Not Yet Implemented", message: "If you ask nicely, it can be done.", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	//MARK: - delegate callbacks
	func didTapItem(_ recallItem: RecallItem) {
		print("didTapItem:\(recallItem)")
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "AudioViewControllerSBID") as! AudioViewController
		vc.recallItem = recallItem
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
		self.navigationController?.pushViewController(vc, animated: true)
		
		
	}

	

}
