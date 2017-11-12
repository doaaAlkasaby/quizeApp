//
//  MapViewController.swift
//  Quize
//
//  Created by Doaa Alkasaby on 11/11/17.
//  Copyright © 2017 Elryad. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController , CLLocationManagerDelegate {

    var lat : Double?
    var long : Double?
    var locationManager: CLLocationManager!

    @IBOutlet weak var map: MKMapView!
    
    @IBAction func handleBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if (CLLocationManager.locationServicesEnabled())
//        {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//        }
        
        showMap()
        
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMap(){
        print("lat long: \(lat!),\(long!)")
        //Defining destination
        let latitude:CLLocationDegrees = lat!//30.0596185
        let longitude:CLLocationDegrees = long!//31.1884231
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "My Target"
        mapItem.openInMaps(launchOptions: options)
    }
    
}
