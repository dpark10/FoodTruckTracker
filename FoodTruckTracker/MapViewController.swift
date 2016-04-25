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
import OAuthSwift


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var foodTrucks = [FoodTruck]()
    var foodTruckOfAnnotation  = FoodTruck()

    // MARK: - Properties
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - View Management
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        

        let apiConsoleInfo = YelpAPIConsole()
        
        let client = YelpAPIClient()
        
        
//        let yelpFoodTrucksURL = NSURL(string: "https://api.yelp.com/v2/search?category_filter=foodtrucks&location=Chicago&oauth_consumer_key=nF30f57Y37owF8lkT0yunw&oauth_token=euX1y5nJ1dugqyUfuWkXCdzZU9vjHVGf&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1461603623&oauth_nonce=3CFwlz&oauth_version=1.0&oauth_signature=RB0RYvOhlSgbeZocZmJnp/08nOE=")
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithURL(yelpFoodTrucksURL!) { (data, response, error) in
        
        let parameters = ["category_filter": "foodtrucks", "location": "Chicago"]
        
        client.searchPlacesWithParameters(parameters, successSearch: { (data, response) -> Void in
           
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                print("json: \(json)")
                if let yelpBusinesses = json["businesses"] as? [NSDictionary] {
                    var count = 0
                    for yelpDict: NSDictionary! in yelpBusinesses {
                        count += 1
                        let name = yelpDict?["name"] as! NSString
                        print("text: \(name)")
                        let address = yelpDict?["location"]!["display_address"] as? [String]
                        print("address: \(address)")
                        let phone = yelpDict?["phone"]
                        print("phone: \(phone)")
                        let coordinate = yelpDict?["location"]!["coordinates"]
                        print("coordinate = \(coordinate) \n")
                        let business = FoodTruck.init()
                        business.name = name as String
//                        business.phoneNumber = phone as! String
                        if address?.count == 3 {
                            business.address = address![0] + ", " + address![1] + ", " + address![2]
                            dispatch_async(dispatch_get_main_queue()) {
                                self.dropPinForFoodTruck(business)
                                print("Added annotation")
                            }
                        }
                        else if address!.count == 2 {
                            if address![0] != "Varies" {
                            business.address = address![0] + ", " + address![1]
                            } else {
                                 //Temporary Address Placeholder
                                business.address = "223 W Erie St #4nw, Chicago, IL 60654"
                            }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.dropPinForFoodTruck(business)
                            print("Added annotation")
                        }
                        }
                        else {
                              //Temporary Address Placeholder
                            business.address = "223 W Erie St #4nw, Chicago, IL 60654"
                            dispatch_async(dispatch_get_main_queue()) {
                                self.dropPinForFoodTruck(business)
                                print("Added annotation")
                        }
                        }
                        self.foodTrucks.append(business)
                        let barViewControllers = self.tabBarController?.viewControllers
                        let svc = barViewControllers![1] as! ListViewController
                        svc.foodTrucks = self.foodTrucks

                        
                        
                        if count == yelpBusinesses.count{
                            break
                        }
                    }
                }
                
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }


    
            }, failureSearch: { (error) -> Void in
                print(error)
    })
    
    
        

    }



    func zoomCenter() {
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 10000, 10000)
        mapView.setRegion(region, animated: true)
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
    
    
    // MARK: - CLLocationManagerDelegate Methods
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first!
    }
    
    // MARK: - MKMapViewDelegate Methods
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        self.zoomCenter()
    }
        
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
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("callout accessory tapped")
        let truckAnnotation = view.annotation as! FoodTruckAnnotation
        foodTruckOfAnnotation = truckAnnotation.foodTruck!
        self.performSegueWithIdentifier("MapToProfileSegue", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //TO DO - pass food truck to profile vc
        if (segue.identifier == "MapToProfileSegue") {
            let destVC = segue.destinationViewController as! FTProfileViewController
            destVC.foodTruck = foodTruckOfAnnotation
        }
        
    }
    
    // MARK: - IBActions
    @IBAction func onZoomButtonTapped(sender: UIButton) {
        self.zoomCenter()
    }

    
    func dropPinForFoodTruck(foodTruck: FoodTruck) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(foodTruck.address) { (placemarks : [CLPlacemark]?, error : NSError?) in
            for placemark in placemarks! {
                let annotation = FoodTruckAnnotation()
                annotation.coordinate = placemark.location!.coordinate
                annotation.title = foodTruck.name
                annotation.foodTruck = foodTruck
                self.mapView.addAnnotation(annotation)
                
            }
        }
    }
    

}

