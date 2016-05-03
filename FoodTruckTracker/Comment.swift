//
//  Comment.swift
//  FoodTruckTracker
//
//  Created by Dylan Bruschi on 5/3/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import Foundation
import Firebase

class Comment: NSObject {
    var rating:         Double = 0
    var text:           String = ""
    var foodTruck:      String = ""
    
     init(snapshot: FDataSnapshot) {
        rating = snapshot.value.objectForKey("rating") as! Double
        text = snapshot.value.objectForKey("text") as! String
        foodTruck = snapshot.value.objectForKey("foodTruck") as! String
    }

}
