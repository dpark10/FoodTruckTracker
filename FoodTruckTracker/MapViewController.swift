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
    var currentLocation = CLLocation()
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        self.zoomMap()
        
     
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
        
//        let statusesShowEndpoint  = "https://api.twitter.com/1.1/search/tweets.json?q=list:chifoodtruckz/tracking&count:50"
        
        let statusesShowEndpoint  = "https://api.twitter.com/1.1/search/tweets.json?q=%23chicago&count:50"
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

                            
                            if coordinates != nil {
                            let annotation = MKPointAnnotation()
                            annotation.title = user! as? String
                            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates![1], longitude: coordinates![0])
                            self.mapView.addAnnotation(annotation)
                                print("Added annotation\n")
                            } else {
                                print("No annotation\n")
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
        if annotation.isEqual(mapView.userLocation) {
            return nil
        }
        else {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.canShowCallout = true
            pin.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            return pin
        }
    }
    
        
   
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first!
//        if currentLocation.horizontalAccuracy < 1000 && currentLocation.verticalAccuracy < 1000 {
//         
//        }
    }
    
    func reverseGeocode(location: CLLocation){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: NSError?) in
            if error != nil {
                print(error?.localizedDescription)
            }
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func zoomMap() {
        
        //Eventually make center average or median coordinate of of locations array
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.89374, longitude: -87.637519), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
        
        self.mapView.setRegion(region, animated: true)
    }
    


}

