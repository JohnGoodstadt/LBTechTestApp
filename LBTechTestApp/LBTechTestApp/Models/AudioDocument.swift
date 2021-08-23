//
//  DocumentModels.swift
//  memorize
//
//  Created by John goodstadt on 11/03/2021.
//  Copyright © 2021 John Goodstadt. All rights reserved.
//

import Foundation
import LBEntities

public class AudioDocument : Codable {
	public var UID = "" // either item or group
	public var audio:Data = Data()
	//var imageType = image_type_enum.image
	public var owner = image_owner_enum.item //most likely
	public var name = ""
	public var uploaddate = Date()
	
	public init(_ UID:String,_ audio:Data, name:String = ""){
		
		self.UID = UID
		self.audio = audio
		//self.imageType = .audio //most common
		self.owner = image_owner_enum.item
		self.name = name
		self.uploaddate = Date()
	}
//	public init(recallItem ri:LBEntities.RecallItem){
//		
//		self.UID = ri.UID
//		self.audio = ri.audio
//		self.owner = image_owner_enum.item
//		self.name = ri.title
//		self.uploaddate = Date()
//	}
	required public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		UID  =  try values.decodeIfPresent(String.self, forKey: .UID) ?? ""
		audio =  try values.decodeIfPresent(Data.self, forKey: .audio) ?? Data()
		//imageType =  try values.decodeIfPresent(image_type_enum.self, forKey: .imageType) ?? image_type_enum.audio
		owner =  try values.decodeIfPresent(image_owner_enum.self, forKey: .owner) ?? image_owner_enum.item
		name  =  try values.decodeIfPresent(String.self, forKey: .name) ?? ""
		uploaddate  =  try values.decodeIfPresent(Date.self, forKey: .uploaddate) ?? Date()
	}
}

public enum image_type_enum : Int, CustomStringConvertible,Codable{
	
	case image = 0   // used for image collection - an image not an audio
	case audio		// used for image collection - an mp3 not image
	public var description : String {
		switch self {
			case .image: return "Image"
			case .audio: return "Audio"
		}
	}
	
}
public enum fb_collection_type_enum : Int, CustomStringConvertible,Codable{
	
	case item = 0   // used to point to recalitems collection  in fb
	case group		// used to point to recalgroups collection in fb
	case image		// used to point to images collection in fb
	case audio		// used to point to audio collection in fb
	
	public var description : String {
		switch self {
			case .item: return "Image"
			case .group: return "group"
			case .image: return "image"
			case .audio: return "Audio"
		}
	}
	
}
public enum image_owner_enum : Int, CustomStringConvertible,Codable{
	
	case item = 0   // used for image collection - owned by an item
	case group		// used for image collection - owned by a group
	public var description : String {
		switch self {
			case .item: return "item"
			case .group: return "group"
		}
	}
	
}
public enum audio_type_enum : Int, CustomStringConvertible,Codable{
	
	case chant = 0   //
	case asana // used for downloading all asanas
	case chakra // used for downloading all chakras
	public var description : String {
		switch self {
			case .chant: return "chant"
			case .asana: return "asana"
			case .chakra: return "chakra"
		}
	}
	
}

