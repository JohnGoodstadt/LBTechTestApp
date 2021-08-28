//
//  GlobalVariables.swift
//  memorize
//
//  Created by John goodstadt on 09/05/2019.
//  Copyright © 2019 John Goodstadt. All rights reserved.
//

import Foundation
import LBEntities

public class GlobalVariables {
    
	
	public var dataProvider: DataProvider = DataProviderFirebase()

    // all individual items
    public var busesNoOrderFromDB = [LBEntities.RecallItem]()
	//all groups of items
	public var groups = [LBEntities.RecallGroup]()
	

    public var appSettings = AppSettings()
	//public var userFirebase = UserFirebase() //will be filled on login


    public class var singleton: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
