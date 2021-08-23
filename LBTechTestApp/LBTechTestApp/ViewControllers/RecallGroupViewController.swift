//
//  RecallGroupViewController.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 22/08/2021.
//

import UIKit
import LBEntities
import AVFoundation
/**
 `RecallGroupViewController`Represents 1 group with a list of mp3 items
 
 Can play whole list
*/
class RecallGroupViewController: UIViewController, RecallGroupDataSourceDelegate,AVAudioPlayerDelegate {

	

	//passed in arg
	public var recallGroup:LBEntities.RecallGroup! //cannot do without this
	
	var datasource:RecallGroupDataSource?
	private var playlistQ = Queue<LBEntities.RecallItem>() //list of mp3s
	var audioPlayer: AVAudioPlayer?
	
	@IBOutlet weak var playNavButton: UIBarButtonItem!
	@IBOutlet weak var navItemToolbar: UINavigationItem!
	@IBOutlet weak var tableview: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setupUI()
		
		setupDataSources()
    }
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		if let player = self.audioPlayer {
			if player.isPlaying {
				player.stop()
			}
		}
		
	}
	func setupUI(){
		
		self.navItemToolbar.title = self.recallGroup.title
		
	}
	fileprivate func setupDataSources() {
		
		
		//sort items by title
		self.recallGroup.itemList = SortLibrary.sortByDiacriticTitleOnly(self.recallGroup.itemList)
		
		//set up seperate datasource class to be used
		self.datasource = RecallGroupDataSource(group: self.recallGroup,delegate: self)
		self.datasource?.tableview = self.tableview
		
		self.tableview.dataSource = self.datasource
		self.tableview.delegate = self.datasource
		
		
	}
	//MARK: UI IBActions
	@IBAction func playNavButtonPressed(_ sender: Any) {
		
		
		if GlobalVariables.singleton.appSettings.readsamplesfrombundleonload  {
			
			prepareForPlayListQ()
			
			playListOfMP3s()
			
		}else{
			let alert = UIAlertController(title: "Not Yet Implemented", message: "Switch appsetting to read from cache in bundle to hear all tracks.", preferredStyle: UIAlertController.Style.alert)
				alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
			}))
			self.present(alert, animated: true, completion: nil)
		}
		

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
	//MARK: Helper functions
	func prepareForPlayListQ(){
		
		//for now only for bundle samples
		guard GlobalVariables.singleton.appSettings.readsamplesfrombundleonload else {
			return
		}
		
		guard let rg = self.recallGroup else {
			return
		}
		
		//all recall items.audio can be filled in
		rg.itemList.forEach{
			$0.audio = Data()
		}

		playlistQ.clear()
		playlistQ.addAll(SortLibrary.sortByDiacriticTitleOnly(rg.itemList))

		
	}
	fileprivate func playListOfMP3s() {
		//if I have a player and it is playing just stop
		if let mp = self.audioPlayer {
			if mp.isPlaying {
				audioPlayer?.stop()
				colorIconNotPlaying()
				return
			}
			
		}
		
		startStopPlayingOfPlaylist()
	}
	fileprivate func startStopPlayingOfPlaylist(){
		
		
		//if I have a player and it is playing just stop
		if let mp = self.audioPlayer {
			if mp.isPlaying {
				audioPlayer?.stop()
				colorIconNotPlaying()
				return
			}
		}
		

		if playlistQ.isNotEmpty() {
			if (playNextTrackQ() ){ //something played
				colorIconPlaying()
			}else{
				colorIconNotPlaying()
			}
		}else{  //at end of list
			print("No tracks to play")
			colorIconNotPlaying()
		}

	}
	internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){

		
		///we have a valid mp3 to play
		if playlistQ.isNotEmpty() {
			colorIconPlaying()
			playNextTrackQ()
		}else{
			colorIconNotPlaying()
			prepareForPlayListQ() //for next time - from model to playList Queue
		}
		

	}
	private func colorIconNotPlaying(){
		if let navbutton = playNavButton {
			navbutton.tintColor = UIColor.systemBlue
		}
	}
	private func colorIconPlaying(){
		if let navbutton = playNavButton {
			navbutton.tintColor = UIColor.systemRed
		}
	}
	private func playNextTrackQ() -> Bool {
	
		let returnValue = false
	
		
		if playlistQ.isEmpty() {
			return returnValue //no more todo
		}
		
		
		if let item = playlistQ.dequeue() { //FIFO - guaranteed valid mp3
		
			playMP3(item.UID)
		}

		return returnValue
	}
	fileprivate func playMP3(_ UID: String){
		
		if let fileURL = Bundle.main.path(forResource: UID, ofType: "mp3") {
			do{

				audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
				audioPlayer?.prepareToPlay()
				audioPlayer?.numberOfLoops = 0
				audioPlayer?.currentTime = 0.0
				audioPlayer?.delegate = self
				audioPlayer?.play()
				

				
			}catch{
				print(error)
			}
		}

	}

	
}
