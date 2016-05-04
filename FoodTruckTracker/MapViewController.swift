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
import Firebase


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var foodTrucks = [FoodTruck]()
    var foodTruckOfAnnotation  = FoodTruck?()
    var geofences = [CLCircularRegion]()

    // MARK: - Properties
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - View Management
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()

        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        self.startMonitoringForRegions()
        mapView.delegate = self
        
        self.registerLocalNotifications()
//
//        let apiConsoleInfo = YelpAPIConsole()
//        
//        let client = YelpAPIClient()
//        
        
//        let yelpFoodTrucksURL = NSURL(string: "https://api.yelp.com/v2/search?category_filter=foodtrucks&location=Chicago&oauth_consumer_key=nF30f57Y37owF8lkT0yunw&oauth_token=euX1y5nJ1dugqyUfuWkXCdzZU9vjHVGf&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1461603623&oauth_nonce=3CFwlz&oauth_version=1.0&oauth_signature=RB0RYvOhlSgbeZocZmJnp/08nOE=")
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithURL(yelpFoodTrucksURL!) { (data, response, error) in
        
        let ref = DataService.dataService.REF_BASE.childByAppendingPath("foodTrucks")
        
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            print(snapshot.childrenCount)
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FDataSnapshot {
                let foodTruck = FoodTruck.init(snapshot: rest)
                foodTruck.distance = self.currentLocation.distanceFromLocation(CLLocation(latitude: foodTruck.lat , longitude: foodTruck.long)) * 0.000621371
                print(foodTruck)
                self.foodTrucks.append(foodTruck)
                self.foodTrucks.sortInPlace({ $0.distance < $1.distance})
                
                if foodTruck.lat != 0  && foodTruck.long != 0 {
                dispatch_async(dispatch_get_main_queue()) {
                    self.dropPinForFoodTruck(foodTruck)
                    print("Added annotation")
                }
                }

                let barViewControllers = self.tabBarController?.viewControllers
                let svc = barViewControllers![1] as! ListViewController
                svc.foodTrucks = self.foodTrucks
            }
            })
//
//        let parameters = ["category_filter": "foodtrucks", "location": "Chicago"]
//        
//        client.searchPlacesWithParameters(parameters, successSearch: { (data, response) -> Void in
//           
//            do {
//                let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
//                print("json: \(json)")
//                if let yelpBusinesses = json["businesses"] as? [NSDictionary] {
//                    var count = 0
//                    for yelpDict: NSDictionary! in yelpBusinesses {
//                        count += 1
//                        let name = yelpDict?["name"] as! NSString
//                        print("text: \(name)")
//                        let address = yelpDict?["location"]!["display_address"] as? [String]
//                        print("address: \(address)")
//                        let phone = yelpDict?["display_phone"] as? String
//                        print("display_phone: \(phone)")
//                        let coordinate = yelpDict?["location"]!["coordinate"] as? NSDictionary
//                        print("coordinate = \(coordinate)")
//                        let description = yelpDict?["snippet_text"]
//                        let reviewCount = yelpDict?["review_count"]
//                        let url = yelpDict?["url"]
//                        let ratingImage = yelpDict?["rating_img_url"]
//                        let logo = yelpDict?["image_url"]
//                        let categories = yelpDict?["categories"] as? [NSArray]
//                         print("categories = \(categories)\n")
//                        
//                        let business = FoodTruck.init()
//                        let fullAddress = address!.joinWithSeparator(", ")
//                        var categoryArray = [String]()
//                        for array in categories! {
//                            categoryArray.append(array[0] as! String)
//                        }
//                        let fullCategories = categoryArray.joinWithSeparator(", ")
//                        print(fullCategories)
//                        business.address = fullAddress
//                        business.category = fullCategories
//                        business.name = name as String
//                        business.phone = phone
//                        business.logo = logo as! String
//                        business.desc = description as! String
//                        business.ratingImage = ratingImage as! String
//                        business.url = url as! String
//                        business.yelpReviewCount = reviewCount as! Int
//                        
//                        if coordinate != nil {
//                            business.lat = coordinate!["latitude"] as! Double
//                            business.long = coordinate!["longitude"] as! Double
//                            business.distance = self.currentLocation.distanceFromLocation(CLLocation(latitude: coordinate!["latitude"] as! Double, longitude: coordinate!["longitude"] as! Double)) * 0.000621371
//                            print(business.distance)
//                            }
//                        else {
//                            //Placeholder address for nil cooridates = Mobile Makers office
//                            business.lat = 41.89374
//                            business.long = -87.637519
//                            business.distance = self.currentLocation.distanceFromLocation(CLLocation(latitude: 41.89374, longitude: -87.637519)) * 0.000621371
//                             print(business.distance)
//                        }
//                       
//                                dispatch_async(dispatch_get_main_queue()) {
//                            self.dropPinForFoodTruck(business)
//                            print("Added annotation")
//                        }
//                        self.foodTrucks.append(business)
//                        self.foodTrucks.sortInPlace({ $0.distance < $1.distance})
//                        let barViewControllers = self.tabBarController?.viewControllers
//                        let svc = barViewControllers![1] as! ListViewController
//                        svc.foodTrucks = self.foodTrucks
//
//                        
//                        
//                        if count == yelpBusinesses.count{
//                            self.locationManager.stopUpdatingLocation()
//                            break
//
//                        }
//                    }
//                }
//                
//                
//            } catch let jsonError as NSError {
//                print("json error: \(jsonError.localizedDescription)")
//            }
//
//
//    
//            }, failureSearch: { (error) -> Void in
//                print(error)
//    })
//    
//    
        

    }
    
    
    // MARK: - Notifications
    func registerLocalNotifications() {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
    
    func presentLocalNotifications(foodTruck: String) {
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        
        if settings.types == .None {
            let ac = UIAlertController(title: "Notification Error",
                                     message: "Either we don't have permission to schedule notifications or we haven't asked yet",
                              preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 10)
        notification.alertBody = "\(foodTruck) has a coupon available!"
        notification.alertAction = "claim"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": foodTruck]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    // MARK: - Methods
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
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("did start monitoring for region")
        self.locationManager.requestStateForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered region \(region.identifier)")
        let truckRef = DataService.dataService.REF_BASE.childByAppendingPath("foodTrucks").childByAppendingPath(region.identifier)
        truckRef.observeEventType(.Value, withBlock: { snapshot in
            let foodTruck = FoodTruck.init(snapshot: snapshot)
            let couponRef = DataService.dataService.REF_BASE.childByAppendingPath("coupons").childByAutoId()
            let couponDict = ["couponCode": "\(foodTruck.couponCode).\(NSUserDefaults.standardUserDefaults().valueForKey("uid")).\(couponRef.key)", "couponDesc": (foodTruck.couponDesc) as String, "couponDiscount": (foodTruck.couponDiscount) as String, "active?": true, "couponExp": (foodTruck.couponExp) as String, "foodTruck": (foodTruck.uid) as String, "userID": NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String]
            couponRef.setValue(couponDict)
                self.presentLocalNotifications(foodTruck.name)
        })

    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited region\(region.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        print("did determine state")
        let truckRef = DataService.dataService.REF_BASE.childByAppendingPath("foodTrucks").childByAppendingPath(region.identifier)
        truckRef.observeEventType(.Value, withBlock: { snapshot in
            let foodTruck = FoodTruck.init(snapshot: snapshot)
            let couponRef = DataService.dataService.REF_BASE.childByAppendingPath("coupons").childByAutoId()
            let couponDict = ["couponCode": "\(foodTruck.couponCode).\(NSUserDefaults.standardUserDefaults().valueForKey("uid")).\(couponRef.key)", "couponDesc": (foodTruck.couponDesc) as String, "couponDiscount": (foodTruck.couponDiscount) as String, "active?": true, "couponExp": (foodTruck.couponExp) as String, "foodTruck": (foodTruck.uid) as String, "userID": NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String]
            couponRef.setValue(couponDict)
            if state.rawValue.description == "1" {
                
                print("inside \(region.identifier) geofence")
                self.presentLocalNotifications(foodTruck.name)
            }
            })
  
    }
    
    // MARK: - MKMapViewDelegate Methods
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        self.zoomCenter()
        self.locationManager.stopUpdatingLocation()
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
            return pin
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("callout accessory tapped")
        let truckAnnotation = view.annotation as! FoodTruckAnnotation
        foodTruckOfAnnotation = truckAnnotation.foodTruck!
        self.performSegueWithIdentifier("MapToProfileSegue", sender: nil)
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = UIColor.purpleColor()
            circleRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
            return circleRenderer
        } else {
            return MKPolylineRenderer()
        }
    }
    
    // MARK: - prepareForSegue
    
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
        let radius = CLLocationDistance(200.0)
        annotation.coordinate = CLLocationCoordinate2D(latitude: foodTruck.lat, longitude: foodTruck.long)
        annotation.title = foodTruck.name
        annotation.foodTruck = foodTruck
        let geoRegion = CLCircularRegion(center: annotation.coordinate, radius: radius, identifier: foodTruck.uid)
        self.geofences.append(geoRegion)
        self.locationManager.startMonitoringForRegion(geoRegion)
        let overlay = MKCircle(centerCoordinate: annotation.coordinate, radius: radius)
        self.mapView.addOverlay(overlay)
        self.mapView.addAnnotation(annotation)
        
    }
    //        }
    //    }
    
    
    func startMonitoringForRegions() {
        for geofence in self.geofences {
            self.locationManager.startMonitoringForRegion(geofence)
        }
    }

}

