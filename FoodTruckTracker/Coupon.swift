//
//  Coupon.swift
//  FoodTruckTracker
//
//  Created by Dylan Bruschi on 5/4/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import Foundation
import Firebase

class Coupon: NSObject {
    var couponCode:         String = ""
    var couponDesc:         String = ""
    var couponDiscount:     String = ""
    var active:             Bool?
    var couponExp:          String = ""
    var foodTruck:          String = ""
    var userID:             String = ""
    
    init(snapshot: FDataSnapshot) {
        couponCode = snapshot.value.objectForKey("couponCode") as! String
        couponDesc = snapshot.value.objectForKey("couponDesc") as! String
        couponDiscount = snapshot.value.objectForKey("couponDiscount") as! String
        couponExp = snapshot.value.objectForKey("couponExp") as! String
        foodTruck = snapshot.value.objectForKey("foodTruck") as! String
        userID = snapshot.value.objectForKey("userID") as! String
        
    }

    
}
