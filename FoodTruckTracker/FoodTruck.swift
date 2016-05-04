//
//  FoodTruck.swift
//  FoodTruckTracker
//
//  Created by Dylan Bruschi on 4/21/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import Foundation
import Firebase

class FoodTruck: NSObject {
    var twitterHandle:      String = ""
    var yelpID:             String = ""
    var lat:                Double = 0
    var long:               Double = 0
    var name:               String = ""
    var desc:               String = ""
    var ratingImage:        String = ""
    var rating:             Double = 0
    var logo:               String = ""
    var yelpReviewCount:    Int = 0
    var url:                String = ""
    var phone:              String = ""
    var address:            String = ""
    var distance:           Double = 0
    var category:           String = ""
    var menu:               String = ""
    var uid:                String = ""
    var couponDesc:         String = ""
    var couponCode:         String = ""
    var couponDiscount:     String = ""
    var couponExp:          String = ""
    var departureTime:      String = ""
    
    init(snapshot: FDataSnapshot) {
        lat = snapshot.value.objectForKey("lat") as! Double
        long = snapshot.value.objectForKey("long") as! Double
        name = snapshot.value.objectForKey("name") as! String
        category = snapshot.value.objectForKey("category") as! String
        logo = snapshot.value.objectForKey("logo") as! String
        yelpReviewCount = snapshot.value.objectForKey("numberOfRatings") as! Int
        rating = snapshot.value.objectForKey("rating") as! Double
        phone = snapshot.value.objectForKey("phone") as! String
        uid = snapshot.value.objectForKey("userID") as! String
        menu = snapshot.value.objectForKey("menu") as! String
        couponDesc = snapshot.value.objectForKey("couponDesc") as! String
        couponCode = snapshot.value.objectForKey("couponCode") as! String
        couponDiscount = snapshot.value.objectForKey("couponDiscount") as! String
        couponExp = snapshot.value.objectForKey("couponExp") as! String
        departureTime = snapshot.value.objectForKey("departureTime") as! String
        
    }

}
