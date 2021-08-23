//
//  Extensions.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 22/08/2021.
//

import Foundation
import UIKit
import LBEntities

public extension String {
	func isNotEmpty() -> Bool {
		return !self.isEmpty
	}
	//https://stackoverflow.com/questions/29521951/how-to-remove-diacritics-from-a-string-in-swift
	var forNonDiatricicSorting: String {
		let simple = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
		let nonAlphaNumeric = CharacterSet.alphanumerics.inverted
		return simple.components(separatedBy: nonAlphaNumeric).joined(separator: "")
	}
	
	var branded: String {
				
		return NSLocalizedString(self, tableName: GlobalVariables.singleton.appSettings.stringsfile, comment: "Comment")
		
	}
}
public extension Array {
	
	func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
		var dict = [Key:Element]()
		for element in self {
			dict[selectKey(element)] = element
		}
		return dict
	}
	func isNotEmpty() -> Bool {
		return !self.isEmpty
	}
}
extension Data {
	func isNotEmpty() -> Bool {
		return !self.isEmpty
	}
}
extension UIImageView {
	/*
	Full process for getting the correct thumbnail for group
	1. if *.thumbnail - then use it
	1a. if pinnedItemUID and has thumbnail - use it
	2. look at children for typicalItem thumbnail (pinned/first/sort order first)
		border rules
			A) no border - legal
				
			B) border - music
				
	3. otherwise use standard icon for App
		A) audio icon
		B) legal 2 char round green no border
		C) music
		
	*/
	public func setDefaultThumbnail(){
		
		//defult circle
		self.backgroundColor = UIColor.clear;
		self.layer.cornerRadius =  self.frame.size.height / 2;
		self.layer.masksToBounds = true;

		self.image =  UIImage(systemName: "waveform.path",withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))

		//waveform image always has border
		self.layer.borderWidth = 1
		self.layer.borderColor = HILIGHT_CELL_COLOR.cgColor
		
		
		
	}
//	public func setImageForItem(ri:LBEntities.RecallItem){
//
//		//defult circle
//		self.backgroundColor = UIColor.clear;
//		self.layer.cornerRadius =  self.frame.size.height / 2;
//		self.layer.masksToBounds = true;
//
//		if ri.thumbnail.count > 1 {
//			self.image = UIImage(data: ri.thumbnail)
//			self.layer.borderWidth = 0
//			return
//		}
//
//		if #available(iOS 13.0, *) {
//			self.image =  UIImage(systemName: "waveform.path",withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))
//		}
//		//waveform image always has border
//		self.layer.borderWidth = 1
//		self.layer.borderColor = HILIGHT_CELL_COLOR.cgColor
//
//
//
//	}
	/*
	Full process for getting the correct thumbnail for item
	1. if thumbnail - then use it
	2. otherwise use standard icon for App
		A) audio icon		
	*/
	public func setThumbnailForRow(_ thumbnail:Data){
		
		//defult circle
		self.backgroundColor = UIColor.clear;
		self.layer.cornerRadius =  self.frame.size.height / 2;
		self.layer.masksToBounds = true;
		
		//1.
		if thumbnail.count > 1 {
			self.image = UIImage(data: thumbnail)
			self.layer.borderWidth = 0
		}else{
			if #available(iOS 13.0, *) {
				self.image =  UIImage(systemName: "waveform.path",withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))
			}
			//waveform image always has border
			self.layer.borderWidth = 1
			self.layer.borderColor = HILIGHT_CELL_COLOR.cgColor
		}
		

		
	}
   var imageScale: CGSize {
	   
	   if let image = self.image {
		   let sx = Double(self.frame.size.width / image.size.width)
		   let sy = Double(self.frame.size.height / image.size.height)
		   var s = 1.0
		   switch (self.contentMode) {
		   case .scaleAspectFit:
			   s = fmin(sx, sy)
			   return CGSize (width: s, height: s)
			   
		   case .scaleAspectFill:
			   s = fmax(sx, sy)
			   return CGSize(width:s, height:s)
			   
		   case .scaleToFill:
			   return CGSize(width:sx, height:sy)
			   
		   default:
			   return CGSize(width:s, height:s)
		   }
	   }
	   
	   return CGSize.zero
   }
}
