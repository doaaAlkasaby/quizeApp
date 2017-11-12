//
//  LocationViewController.swift
//  Quize
//
//  Created by Doaa Alkasaby on 11/12/17.
//  Copyright © 2017 Elryad. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

    var lat : Double?
    var long : Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showMap()
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
