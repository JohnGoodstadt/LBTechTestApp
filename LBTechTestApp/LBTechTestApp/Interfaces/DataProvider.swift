//
//  DataProvider.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 23/08/2021.
//

import Foundation
import LBEntities

/**
 `DataProvider` protocol for all access to googles database
 

*/
public protocol DataProvider {
	
	//MARK: user routines
	func isCurrentUserUnknown() -> Bool
	func getCurrentUserid() -> String 
	func loginAsAnon(completion: @escaping (String,Bool) -> Void )
	
	//MARK: initial grab of data
	func initialLoad(completion: @escaping ([LBEntities.RecallGroup],[ LBEntities.RecallItem], Bool) -> Void)
	
	//MARK: get mp3
	func readAudio(UID:String, completion: @escaping ([AudioDocument],Bool) -> Void )
}
