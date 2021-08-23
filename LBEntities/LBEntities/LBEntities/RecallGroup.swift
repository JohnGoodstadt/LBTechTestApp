//
//  RecallGroup.swift
//  LBEntities
//
//  Created by John goodstadt on 22/08/2021.
//

import Foundation

final public class RecallGroup : NSObject,Codable {
	
	public var UID:String = UUID().uuidString
	public var title = "A group title to be altered"
	public var itemList:[RecallItem] = [RecallItem]()
	
	//linked list
	public var hasChild = false //group can have a group as a child
	public var hasParent = false //group can have group as a parent
	public var groupUIDList:[String] = [String]() //list of sub groups (UIDs)
	public var thumbnail:Data = Data()
	
	//MARK: Initializers
	override public init() {}

	private enum CodingKeys: String, CodingKey {
		case UID = "UID"
		case title = "title"
		case hasParent = "hasParent"
		case hasChild = "hasChild"
		case groupUIDList = "groupUIDList"
		case thumbnail = "thumbnail"
		

	}
	
	required public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		UID =  try values.decodeIfPresent(String.self, forKey: .UID) ?? ""
		title =  try values.decodeIfPresent(String.self, forKey: .title) ?? ""
		//group within group
		hasParent =  try values.decodeIfPresent(Bool.self, forKey: .hasParent) ?? false
		hasChild =  try values.decodeIfPresent(Bool.self, forKey: .hasChild) ?? false
		groupUIDList =  try values.decodeIfPresent([String].self, forKey: .groupUIDList) ?? [String]()
		thumbnail =  try values.decodeIfPresent(Data.self, forKey: .thumbnail) ?? Data()

		
	}
	
	override public var description: String {
		
		return "\(title) UID:\(UID) hasParent:\(hasParent) hasChild:\(hasChild) \(hasParent) item count:\(itemList.count) thumbnail:\(thumbnail.count)"
	}
	// MARK: Collection routines
	public func addItem(_ ri: RecallItem){
		
		itemList.append(ri) 
		
		ri.recallGroup = self
		ri.busDepotUID = UID
		
		
	}
}
