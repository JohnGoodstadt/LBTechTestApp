//
//  RecallItem.swift
//  LBEntities
//
//  Created by John goodstadt on 22/08/2021.
//

import Foundation

final public class RecallItem : NSObject,Codable {
	
	@objc public var UID:String = UUID().uuidString
	public var title = "An item title to be altered"
	public var busDepotUID = ""
	public var recallGroup:RecallGroup?
	public var thumbnail:Data = Data()
	public var audio:Data = Data() //not read from outside aource - assigned locally
	
	//MARK: Initializers
	override public init() {}

	private enum CodingKeys: String, CodingKey {
		case UID = "UID"
		case title = "title"
		case busDepotUID = "busDepotUID"
		case thumbnail = "thumbnail"
	
	
	
	}
	required public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		
		UID =  try values.decodeIfPresent(String.self, forKey: .UID) ?? ""
		busDepotUID =  try values.decodeIfPresent(String.self, forKey: .busDepotUID) ?? ""
		title =  try values.decodeIfPresent(String.self, forKey: .title) ?? ""
		thumbnail =  try values.decodeIfPresent(Data.self, forKey: .thumbnail) ?? Data()
		
		
	}
	override public var description: String {
		return "\(title) UID:\(UID.prefix(4)) thumbnail:\(thumbnail.count)"
	}
//	public func copy(with zone: NSZone? = nil) -> Any {
//
//		let copy = RecallItem()
//
//		copy.UID = self.UID
//		copy.busDepotUID = self.busDepotUID
//		copy.title = self.title
//
//
//		return copy
//	}
}
