//
//  VisitedTruck.swift
//  FoodTruckTracker
//
//  Created by Dylan Bruschi on 5/4/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import Foundation
import Firebase

class VisitedTruck: NSObject {
    var name:           String = ""
    var truckID:        String = ""
    var userID:         String = ""
    
    init(snapshot: FDataSnapshot) {
        name = snapshot.value.objectForKey("name") as! String
        truckID = snapshot.value.objectForKey("truckID") as! String
        userID = snapshot.value.objectForKey("userID") as! String
    }

}
