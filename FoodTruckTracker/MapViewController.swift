//
//  MapViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 4/19/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Twitter
import TwitterKit
import TwitterCore



class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        // Swift
        // Get the current userID. This value should be managed by the developer but can be retrieved from the TWTRSessionStore.
//        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
//            let client = TWTRAPIClient(userID: userID)
        
     
            let client = TWTRAPIClient()
            client.loadTweetWithID("20") { (tweet, error) -> Void in
                    if error != nil {
                        print("Error: \(error)")
                    } else {
                      print(tweet)
                }
                
        }
        
   
            let name = "ashalot"
        
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline/\(name).json"
//            let params = ["id": "20"]
            var clientError : NSError?
            
            let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: nil, error: &clientError)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    print("json: \(json)")
//                    print(json.objectForKey("geo"))
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
        }
        }
    
        
   
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }

}

