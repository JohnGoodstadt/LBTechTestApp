//
//  AudioViewController.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 22/08/2021.
//

import UIKit
import LBEntities
import AudioToolbox;
import AVFoundation

/**
 `AudioViewController`Main page for playing mp3s
 
 Requires an item where its UID will enable it to get the audio
*/
class AudioViewController: UIViewController,AVAudioPlayerDelegate {

	//passed in arg
	public var recallItem:LBEntities.RecallItem! //cannot do without this
	
	//MARK: Outlets
	@IBOutlet weak var pageLabel: UILabel!
	@IBOutlet weak var imageview: UIImageView!

	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var navItem: UINavigationItem!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var repeatCountLabel: UILabel!
	@IBOutlet weak var speakerBarButton: UIBarButtonItem!
	@IBOutlet weak var instructionsTitleLabel: UILabel!
	@IBOutlet weak var warningPara1Label: UILabel!
	
	//ivars
	private var dataProvider: DataProvider = GlobalVariables.singleton.dataProvider
	var audioPlayer: AVAudioPlayer?
	var audioTimer = Timer()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setupUI()
		
		prepareAudio() //got something to play
		
    }
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		if let avPlayer = audioPlayer {
			avPlayer.stop()
		}
		
	}
	/**
	 `setupUI` get UI ready for data
	 
	*/
	func setupUI(){
		
		self.title = ""
		
		pageLabel.text = recallItem.title
		self.imageview.image = UIImage(data: recallItem.thumbnail)
		
		if GlobalVariables.singleton.appSettings.readsamplesfrombundleonload {
			prepareAudioFromFile(recallItem)
		}else{
			prepareAudio()
		}


	}
	/**
	 `prepareAudio` get audio from 1 of 3 areas
		1. already in memory
		2. in filesystem in documents
		3. download from google
	*/
	func prepareAudio(){
		
		guard let ri = recallItem else {
			return
		}

		guard !GlobalVariables.singleton.appSettings.readsamplesfrombundleonload else {
			return
		}
			

		if ri.audio.isNotEmpty() {
			prepareAudioFromData(ri.audio)
		}
		else if LibraryFilesystem.cachedMP3FileExists(ri.UID) {
			
			ri.audio = LibraryFilesystem.readLocallyCachedMP3(ri.UID)
			
			prepareAudioFromData(ri.audio)
			
		}
		else
		{

			dataProvider.readAudio(UID: ri.UID){ audioDocuments,errorBool in
				
				
				if  errorBool {
					print("====================> loading of audio ERROR ====================>") //could be not logged in
					return
				}
				
				if audioDocuments.count > 0 {
					if let mp3 = audioDocuments.first?.audio {
					
						ri.audio = mp3
					
						if ri.audio.count > 0 {
							self.prepareAudioFromData(ri.audio) //play ri.audio
							
							LibraryFilesystem.cacheMP3Locally(ri.UID,mp3)
						}
						
					}
				}
			}
		}
	
		

	}
	//MARK: - Audio
	@IBAction func playButtonPressed(_ sender: Any) {
		guard let ri = recallItem else {
			return
		}
		
		guard let avPlayer = audioPlayer else {
			return
		}
		
		if avPlayer.isPlaying{
			avPlayer.pause()
			setPlayImage()
			self.audioTimer.invalidate()
		}else{
			if GlobalVariables.singleton.appSettings.readsamplesfrombundleonload {
				setPauseImage()
				playFromFile(ri,numberOfLoops:2)
				self.audioTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
			}else{
				setPauseImage()
				playFromData(ri.audio,numberOfLoops:2)
				self.audioTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
			}

		}
		
		
	}
	
	@IBAction func doneButtonPressed(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}

	
	@IBAction func speakerButtonPressed(_ sender: Any) {
		
		guard let ri = self.recallItem else {
			return
		}
		
		if GlobalVariables.singleton.appSettings.readsamplesfrombundleonload {
			setPauseImage()
			playFromFile(ri)
		}else{
			playFromData(ri.audio)
		}
	}
	
	internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
		
		self.audioTimer.invalidate()
		slider.value = slider.minimumValue
		setPlayImage()

	}
	fileprivate func setPlayImage(){
		playButton.setImage(UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
	}
	fileprivate func setPauseImage(){
		playButton.setImage(UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
	}
	fileprivate func prepareAudioFromFile(_ ri: RecallItem,numberOfLoops:Int = 0) {
		let fileURL = Bundle.main.path(forResource: ri.UID, ofType: "mp3")!
		
		do{

			audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
			audioPlayer?.prepareToPlay()
			audioPlayer?.currentTime = 0.0
			audioPlayer?.delegate = self
			
			slider.maximumValue = Float(audioPlayer?.duration ?? 0.0)
			slider.isContinuous = true
			slider.minimumValue = 0.0
			slider.setValue(0.0, animated: false)
			
			
		}catch{
			print(error)
		}

	}
	fileprivate func prepareAudioFromData(_ audio: Data,numberOfLoops:Int = 0) {

		do{
			audioPlayer = try AVAudioPlayer(data: audio , fileTypeHint: "mp3")
			audioPlayer?.prepareToPlay()
			audioPlayer?.currentTime = 0.0
			audioPlayer?.delegate = self
			
			slider.maximumValue = Float(audioPlayer?.duration ?? 0.0)
			slider.isContinuous = true
			slider.minimumValue = 0.0
			slider.setValue(0.0, animated: false)
	}catch{
		print(error)
	}

	}
	/**
	 `playFromFile` use AVAudioPlayer to play documents mp3 file
	 
	numberOfLoops: can be played 3 time or just once
	*/
	fileprivate func playFromFile(_ ri: RecallItem,numberOfLoops:Int = 0) {
		let fileURL = Bundle.main.path(forResource: ri.UID, ofType: "mp3")!
		
		do{

			audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
			audioPlayer?.prepareToPlay()
			audioPlayer?.numberOfLoops = numberOfLoops
			audioPlayer?.currentTime = 0.0
			audioPlayer?.delegate = self
			audioPlayer?.play()
			
			slider.maximumValue = Float(audioPlayer?.duration ?? 0.0)
			slider.isContinuous = true
			slider.minimumValue = 0.0
			slider.setValue(0.0, animated: false)
			
		}catch{
			print(error)
		}

	}
	/**
	 `playFromData` use AVAudioPlayer to play from Data() from google db
	 
	numberOfLoops: can be played 3 time or just once
	*/
	fileprivate func playFromData(_ audio: Data,numberOfLoops:Int = 0) {
		
		
		do{

			audioPlayer = try AVAudioPlayer(data: audio , fileTypeHint: "mp3")
			audioPlayer?.prepareToPlay()
			audioPlayer?.numberOfLoops = numberOfLoops
			audioPlayer?.currentTime = 0.0
			audioPlayer?.delegate = self
			audioPlayer?.play()
			
			slider.maximumValue = Float(audioPlayer?.duration ?? 0.0)
			slider.isContinuous = true
			slider.minimumValue = 0.0
			slider.setValue(0.0, animated: false)
			
		}catch{
			print(error)
		}

	}
	@objc func updateSlider(_ timer: Timer) {
		slider.value = Float(audioPlayer?.currentTime ?? 0.0)
	}


}
