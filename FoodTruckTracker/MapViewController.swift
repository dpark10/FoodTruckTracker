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
                        let phone = yelpDict?["display_phone"] as? String
                        print("display_phone: \(phone)")
                        let coordinate = yelpDict?["location"]!["coordinate"] as? NSDictionary
                        print("coordinate = \(coordinate)")
                        let description = yelpDict?["snippet_text"]
                        let reviewCount = yelpDict?["review_count"]
                        let url = yelpDict?["url"]
                        let ratingImage = yelpDict?["rating_img_url"]
                        let logo = yelpDict?["image_url"]
                        let categories = yelpDict?["categories"] as? [NSArray]
                         print("categories = \(categories)\n")
                        
                        let business = FoodTruck.init()
                        let fullAddress = address!.joinWithSeparator(", ")
                        var categoryArray = [String]()
                        for array in categories! {
                            categoryArray.append(array[0] as! String)
                        }
                        let fullCategories = categoryArray.joinWithSeparator(", ")
                        print(fullCategories)
                        business.address = fullAddress
                        business.category = fullCategories
                        business.name = name as String
                        business.phone = phone
                        business.logo = logo as! String
                        business.desc = description as! String
                        business.ratingImage = ratingImage as! String
                        business.url = url as! String
                        business.yelpReviewCount = reviewCount as! Int
                        
                        if coordinate != nil {
                            business.lat = coordinate!["latitude"] as! Double
                            business.long = coordinate!["longitude"] as! Double
                            business.distance = self.currentLocation.distanceFromLocation(CLLocation(latitude: coordinate!["latitude"] as! Double, longitude: coordinate!["longitude"] as! Double)) * 0.000621371
                            print(business.distance)
                            }
                        else {
                            //Placeholder address for nil cooridates = Mobile Makers office
                            business.lat = 41.89374
                            business.long = -87.637519
                            business.distance = self.currentLocation.distanceFromLocation(CLLocation(latitude: 41.89374, longitude: -87.637519)) * 0.000621371
                             print(business.distance)
                        }
                       
                                dispatch_async(dispatch_get_main_queue()) {
                            self.dropPinForFoodTruck(business)
                            print("Added annotation")
                        }
                        self.foodTrucks.append(business)
                        self.foodTrucks.sortInPlace({ $0.distance < $1.distance})
                        let barViewControllers = self.tabBarController?.viewControllers
                        let svc = barViewControllers![1] as! ListViewController
                        svc.foodTrucks = self.foodTrucks

                        
                        
                        if count == yelpBusinesses.count{
                            self.locationManager.stopUpdatingLocation()
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
        print(currentLocation)
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
            let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "foodTruckImage")
            pin.canShowCallout = true
            pin.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            print(pin.image?.description)
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
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(foodTruck.address) { (placemarks : [CLPlacemark]?, error : NSError?) in
//            for placemark in placemarks! {
                let annotation = FoodTruckAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: foodTruck.lat, longitude: foodTruck.long)
                annotation.title = foodTruck.name
                annotation.foodTruck = foodTruck
                self.mapView.addAnnotation(annotation)
                
            }
//        }
//    }
    

}

