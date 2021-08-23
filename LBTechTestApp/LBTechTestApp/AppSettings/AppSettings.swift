//
//  File.swift
//  memorize
//
//  Created by John goodstadt on 30/11/2019.
//  Copyright © 2019 John Goodstadt. All rights reserved.
//

import Foundation

struct JSONSettings : Decodable {
	var target : String
	var languageApp : Bool
	var stringsfile : String
	var audioapp : Bool
	var readsamplesfrombundleonload : Bool
	var sortbystrippingaccents : Bool
	

	
}

/**
 `AppSettings`allow reading of json settings from app bundle
 

*/

public struct AppSettings {
    
	//defaults
	
	var target = "lbtechtest"
	var languageApp = true
	var stringsfile = "lbtechtest"
	var audioapp = true
	var readsamplesfrombundleonload = true //change to false to use google db
	var sortbystrippingaccents = false //if non english accents e.g.löffel sort without diacritics
	
	
    init(){}
    
    init(_ json:String){
        
        
        do{
            let appSettings = try JSONDecoder().decode(JSONSettings.self, from: json.data(using: .utf8)!)
			
			self.target = appSettings.target
			self.languageApp = appSettings.languageApp
			self.stringsfile = appSettings.stringsfile
			self.audioapp = appSettings.audioapp
			self.readsamplesfrombundleonload = appSettings.readsamplesfrombundleonload
			self.sortbystrippingaccents = appSettings.sortbystrippingaccents
			
        }catch{

            print(error)
			print("============================================")
			print("====>ERROR FIX, ERROR FIX ERROR FIX <=======")
			print("============================================")
        }
        
    }
    
    

}
