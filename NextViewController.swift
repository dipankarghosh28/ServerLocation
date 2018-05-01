//
//  ViewController.swift
//  Location
//
//  Created by Dipankar Ghosh on 4/27/18.
//  Copyright © 2018 Dipankar Ghosh. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation
import FirebaseStorage
import FirebaseDatabase

class NextViewController: UIViewController, CLLocationManagerDelegate {
   var ref: DatabaseReference?
   var postData = [String]()
    
    struct globalvariable
    {
        static var myStruct = String()
    }
   
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var textview: UITextView!
    
    let manager = CLLocationManager()
    var lat  = ""
    var long = ""
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let geocoder = CLGeocoder()
        var lat : CLLocationDegrees = 0.0
        var long : CLLocationDegrees = 0.0
        print("currently here ->", globalvariable.myStruct)
        geocoder.geocodeAddressString(globalvariable.myStruct, completionHandler: {(placemarks, error) -> Void in
            
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                coordinates.latitude
                coordinates.longitude
                
                
                lat = coordinates.latitude
                long = coordinates.longitude
                print("lat \(lat)")
                print("long \(long)")
                let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
                let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
                let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
                self.map.setRegion(region, animated: true)
                self.map.showsUserLocation = true
           
            }
        })
    }
    
    
    @IBAction func addpost(_ sender: Any)
    {
        
        //post data to firebase
        print("This is the global varaible->",globalvariable.myStruct)
        ref?.child("address").childByAutoId().setValue(globalvariable.myStruct)
    }
     @IBAction func getpost(_ sender: Any)
    {
        var ref2: DatabaseReference?
        var databaseHandle: DatabaseHandle?
        var postData = [String]()
        NSLog("Entered here")
        ref2 = Database.database().reference()
        databaseHandle = ref2?.child("address").observe(.childAdded, with: {(snapshot) in
            
            let post = snapshot.value as? String
            if let actualPost = post{
                self.postData.append(actualPost)
                print(actualPost)
                self.textview.text = actualPost
                globalvariable.myStruct = actualPost
                print("Is this printing ?---->",globalvariable.myStruct)
                self.manager.delegate = self
                self.self.manager.desiredAccuracy = kCLLocationAccuracyBest
                self.manager.requestWhenInUseAuthorization()
                self.manager.startUpdatingLocation()
            }
            else{
                print("some error")
            }
        })
       
   
}
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    //next function here
   
}



