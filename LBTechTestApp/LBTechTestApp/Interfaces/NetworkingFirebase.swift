//
//  NetworkingFirebase.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 23/08/2021.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

import LBEntities

/**
 `NetworkingFirebase`concrete implementation to get data from Google's db
 
*/

public final class NetworkingFirebase {

	func isCurrentUserUnknown() -> Bool {
		
		guard let _ = Auth.auth().currentUser else {
			 return true
		}
	
		return false
	}
	func getCurrentUserid() -> String {
		
		guard let currentUser = Auth.auth().currentUser else {
			 return "unknown"
		}
	
		return currentUser.uid
	}
	func loginAsAnon(completion: @escaping (String,Bool) -> Void ){
		
		//only routine that onyl works if user is nil
		guard  Auth.auth().currentUser == nil else {
			return
		}
		
		Auth.auth().signInAnonymously { (authResult, err) in
			
			print("============================================")
			print("========> SIGNED IN AS ANONYMOUS <==========")
			print("============================================")
			
			if let err = err {
				print("Cannot login in anon - something bad happened (no internet?). do nothing")
				print(err)
				if  err.localizedDescription.contains("permissions") {
					print("permission error")
				}
				completion("",true)

			}else{
				
				if let user = authResult?.user {
					completion(user.uid,false) //only success exit
				}
				

			}
		}

	}
	
	func initialLoadFromFirebase(completion: @escaping ([LBEntities.RecallGroup],[ LBEntities.RecallItem], Bool) -> Void) {
	
		guard let _ = Auth.auth().currentUser else{
			completion([LBEntities.RecallGroup](),[ LBEntities.RecallItem](),true)
			return
		}
		
		self.readItemsAndGroups(){ groups, items, errorBool in
			print("group count \(groups.count)")
			print("item  count \(items.count)")
			
			if  errorBool {
				print("====================> initial Load From Google ERROR ====================>") //could be not logged in
				completion(groups,items,true) //error
				return
			}
			
			completion(groups,items,false) //no error
		}
	
	
	}
	func readAudio(UID:String, completion: @escaping ([AudioDocument],Bool) -> Void ){
		
		guard let _ = Auth.auth().currentUser else {return}
		
		let db = Firestore.firestore()
		
		var audioDocuments = [AudioDocument]()
		

		//let	docRef = db.collection(fb.global).document(fb.samples).collection(fb.appsamples).document(fb.defaultname).collection(fb.prompts).document(UID)
		
		let	docRef = db.collection(fb.global).document(fb.samples).collection(fb.appsamples).document(fb.defaultname).collection(fb.audio).document(UID)
		docRef.getDocument { (document, error) in
			if let document = document, document.exists {
		
				do{
//					if var docdata = document.data() {
//						NetworkingFirebase.fixupDate(&docdata,"uploaddate")
//
//						let promptImage = try FirestoreDecoder().decode(AudioDocument.self, from: docdata)
//
//						audioDocuments.append(promptImage)
//
//					}
					if let audioDocument = try document.data(as: AudioDocument.self) {
						audioDocuments.append(audioDocument)
					}
					
				}catch{
					print("Error reading prompt image from Firestore: \(error)")
					completion(audioDocuments,true)
				}
				
				completion(audioDocuments,false) //only good exit
			}else{
				if (error != nil) {
					print(error ?? "error in doesUserExist()")
				}
				print("Document does not exist")
				completion(audioDocuments,true)
			}
			
		}
//
//		docRef.getDocuments() { (querySnapshot, err) in
//			if let err = err {
//				print("Error getting audio documents: \(err)")
//				completion(audioDocuments,true)
//			} else {
//
//				do {
//
//					for document in querySnapshot!.documents {
//
//						var fbData = document.data()
//						fixupDate(&fbData,"uploaddate")
//
//						let audioDocument = try FirestoreDecoder().decode(AudioDocument.self, from: fbData)
//						audioDocuments.append(audioDocument)
//
//						break //only 1
//
//					}
//					completion(audioDocuments,false)
//
//				} catch let error {
//					print("Error reading sample audio from Firestore: \(error)")
//				}
//			}
//		}
	}
	fileprivate func readItemsAndGroups(fromSamples:Bool = false,sampleshidden:Bool = false,completion: @escaping ([LBEntities.RecallGroup],[ LBEntities.RecallItem], Bool) -> Void) {
		
		guard let _ = Auth.auth().currentUser else{
			print("===> user is Nil - so not logged in")
			completion([LBEntities.RecallGroup](),[ LBEntities.RecallItem](),true)
			return
		}
		
		self.readGroups(){ groups, errorBool in
			print("group count \(groups.count)")
			if errorBool {
				completion([LBEntities.RecallGroup](),[ LBEntities.RecallItem](),true)
			}
			
			self.readItems(){ items, errorBool in
				print("item count \(items.count)")
				if errorBool {
					completion([LBEntities.RecallGroup](),[ LBEntities.RecallItem](),true)
				}
				completion(groups,items,false)
			}
		}
		
	}

	fileprivate func readGroups(completion: @escaping ([LBEntities.RecallGroup], Bool) -> Void) {
		
		
		guard let _ = Auth.auth().currentUser else{
			print("===> user is Nil - so not logged in")
			return
		}
		
		
		let db = Firestore.firestore()
		var groups = [LBEntities.RecallGroup]()
		
		let docRef = db.collection(fb.global).document(fb.samples).collection(fb.appsamples).document(fb.defaultname).collection(fb.recallgroups) as Query
		
		docRef.getDocuments() { (querySnapshot, err) in
			if let err = err {
				print("Error getting documents: \(err)")
				if  err.localizedDescription.contains("permissions") {
					print("permission error")
				}
			
				completion(groups,true)
			} else {
				print("group count: \(querySnapshot!.documents.count)")
				
				do {
					for document in querySnapshot!.documents {
						if let rg = try document.data(as: LBEntities.RecallGroup.self) {
							groups.append(rg)
						}
					}
				} catch let error {
					print("Error decoding RecallGroup: \(error)")
					completion(groups,true)
				}

				completion(groups,false)
			}
		}
	
		
	}
	fileprivate func readItems(completion: @escaping ([ LBEntities.RecallItem], Bool) -> Void) {
		
		guard let _ = Auth.auth().currentUser else{
			print("===> user is Nil - so not logged in")
			return
		}

		var recallItems = [ LBEntities.RecallItem]()

		let	docRef = Firestore.firestore().collection(fb.global).document(fb.samples).collection(fb.appsamples).document(fb.defaultname).collection(fb.recallitems) as Query
		
		
		
		docRef.getDocuments() { (querySnapshot, err) in
			if let err = err {
				print("Error getting recallitems: \(err)")
				if  err.localizedDescription.contains("permissions") {
					print("permission error")
				}
				completion(recallItems,true)
			} else {
				
				do {
					for document in querySnapshot!.documents {

						if let ri = try document.data(as: RecallItem.self) {
							recallItems.append(ri)
						}
					}
				} catch let error {
					print("Error getting recallitems from Firestore: \(error)")
					completion(recallItems,true)
				}
				completion(recallItems,false)
			}
			
		}
	
		
	}
}
