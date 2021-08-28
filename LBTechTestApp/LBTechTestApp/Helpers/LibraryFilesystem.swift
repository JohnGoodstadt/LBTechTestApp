//
//  LibraryFilesystem.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 23/08/2021.
//

import Foundation

let mp3_suffix = "mp3"

public class LibraryFilesystem {

	//MARK: - file paths
	public static func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}
	
	static func  cachedMP3FileExists(_ UID: String) -> Bool {
		
		let filename = "\(UID).\(mp3_suffix)"
		
		return exists(getDocumentsDirectory().appendingPathComponent(filename))
	}
	static func readLocallyCachedMP3(_ UID: String) -> Data {
		
		let filename = "\(UID).\(mp3_suffix)"
		
		do{
			return try Data(contentsOf: getDocumentsDirectory().appendingPathComponent(filename))
		}catch{
			print(error)
		}
		

		return Data()
		
	}
	static func cacheMP3Locally(_ UID: String,_ mp3: Data) {

		let filename = "\(UID).\(mp3_suffix)"

		print("writing to:")
		print("\(getDocumentsDirectory().appendingPathComponent(filename))")
		do {
			try mp3.write(to: getDocumentsDirectory().appendingPathComponent(filename))
		} catch {
			print(error)
		}
		
	}
	fileprivate static func exists(_ name:URL ) -> Bool
	{
		var returnValue = false
		
		if FileManager.default.fileExists(atPath: name.path) {
			returnValue = true
		}
			
		return returnValue
		
	}
}
