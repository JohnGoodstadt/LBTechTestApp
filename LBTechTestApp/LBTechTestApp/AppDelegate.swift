//
//  AppDelegate.swift
//  LBTechTestApp
//
//  Created by John goodstadt on 22/08/2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		GlobalVariables.singleton.appSettings = AppDelegate.readAppSettings()
		
		if !GlobalVariables.singleton.appSettings.readsamplesfrombundleonload {
			getAndSetFirebaseOptionsFile()
		}
		
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}


	private static func readAppSettings() -> AppSettings {
		
		var returnValue = AppSettings()
		
		do {
			
			let bundlename = "LBSettings"

			
			if let bundlePath = Bundle.main.path(forResource: bundlename, ofType: "bundle") {
				let settingsBundle = Bundle(path: bundlePath)!
				if let filepath = settingsBundle.path(forResource: "settings", ofType: "json") {
					let json = try String(contentsOfFile: filepath)
					print(json)
					returnValue = AppSettings(json)
				}
				
			}
			
		}catch{
			print(error)
		}
		
		return returnValue
	}
}
fileprivate func getAndSetFirebaseOptionsFile(){
	
	
	// choose which google file to use
	let resource = "GoogleService-InfoLanguage"
	//this can be a choice

	
	let filePath = Bundle.main.path(forResource: resource, ofType: "plist")
	
	guard filePath != nil, let fileopts = FirebaseOptions(contentsOfFile: filePath!) else {
		print("Couldn't load google config file \(resource)")
		return
	}
	
	FirebaseApp.configure(options: fileopts)

	
	
}

