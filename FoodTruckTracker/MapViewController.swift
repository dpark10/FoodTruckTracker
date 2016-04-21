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



class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
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
        
   
//            let name = "thefatshallot"
        
//            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline/\(name).json"
        
        
//        let statusesShowEndpoint = "https://api.twitter.com/1.1/lists/statuses.json?slug=chicago-food-trucks&owner_screen_name=dbruschi54"
        
        let statusesShowEndpoint  = "https://api.twitter.com/1.1/search/tweets.json?q=list:chifoodtruckz/tracking&count:50"
        //can add hashtag to refine search
        
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
                    if let tweets = json["statuses"] as? [NSDictionary] {
                        var count = 0
                        for tweetsDict: NSDictionary! in tweets {
                            count += 1
                            let title = tweetsDict?["text"] as! NSString
                            print("text: \(title)")
                            let coordinates = tweetsDict?["coordinates"]!["coordinates"] as? [Double]
                            print("coordinates: \(coordinates)")
                            let user = tweetsDict?["user"]!["name"]
                            print("user: \(user)")
                            print("done\n")
                            
                            if coordinates != nil {
                            let annotation = MKPointAnnotation()
                            annotation.title = user! as? String
                            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates![0], longitude: coordinates![1])
                            self.mapView.addAnnotation(annotation)
                                print("Added annotation")
                            }
                            if count == tweets.count{
                                break
                            }
                        }
                    }
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
        }
        }
    
    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            let pin = MKPinAnnotationView()
            return pin
    }
    
        
   
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    


}

