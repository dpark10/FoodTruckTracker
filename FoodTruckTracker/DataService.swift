//
//  DataService.swift
//  FoodTruckTracker
//
//  Created by dp on 4/21/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let dataService = DataService()
    private var _REF_BASE = Firebase(url: "https://foodtrucktracker.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var CURRENT_USER: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(REF_BASE)").childByAppendingPath("users").childByAppendingPath(userID)
        return currentUser!
    }
}
