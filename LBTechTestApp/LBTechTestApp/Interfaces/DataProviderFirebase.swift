//
//  DataProviderFirebase.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 23/08/2021.
//

import Foundation
import LBEntities



/**
 `DataProviderFirebase`definition of google's interfa ce
 
 Adapter for the data provider using framework
*/
struct DataProviderFirebase: DataProvider {

	
	
	private let networkService: NetworkingFirebase
	
	
	init() {
		let networkService = NetworkingFirebase()
		self.networkService = networkService
	}
	
	//MARK: user routunes
	func isCurrentUserUnknown() -> Bool {
		networkService.isCurrentUserUnknown()
	}
	func getCurrentUserid() -> String  {
		networkService.getCurrentUserid()
	}
	func loginAsAnon(completion: @escaping (String,Bool) -> Void ){
		networkService.loginAsAnon(completion: completion)
	}
	
	//MARK: initial grab of data
	func initialLoad(completion: @escaping ([LBEntities.RecallGroup],[ LBEntities.RecallItem], Bool) -> Void) {
		networkService.initialLoadFromFirebase(completion: completion)
	}
	
	//MARK: get mp3
	func readAudio(UID:String, completion: @escaping ([AudioDocument],Bool) -> Void ){
		networkService.readAudio(UID: UID, completion: completion)
	}
}
