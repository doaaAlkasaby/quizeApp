//
//  MapDirectionViewController.swift
//  MapsDemo2
//
//  Created by Doaa Alkasaby on 11/19/17.
//  Copyright © 2017 balitax. All rights reserved.
//

import UIKit
import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire
import MapKit

class MapDirectionViewController: UIViewController , GMSMapViewDelegate ,  CLLocationManagerDelegate{

    var locationManager = CLLocationManager()
    var userLatitude = CLLocationDegrees()
    var userLongitude = CLLocationDegrees()
    
    var destinationLatitude = CLLocationDegrees() //36.1252285
    var destinationLongitude = CLLocationDegrees() //-115.4551946
    
    var kilometers = 0
    var hours = 0
    var minutes = 0
    
    @IBOutlet weak var googleMaps: GMSMapView!
    
    func setDestinationDim(lat : Double , long : Double){
        destinationLatitude = lat
        destinationLongitude = long
        print("destination: \(destinationLatitude) , \(destinationLongitude)")
        destinationLatitude = 36.1252285
        destinationLongitude = -115.4551946
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        
        myCurrentLocation()
    }

    func myCurrentLocation(){
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startMonitoringSignificantLocationChanges()
            
            currentLocation = locationManager.location!
            userLatitude = currentLocation.coordinate.latitude
            userLongitude = currentLocation.coordinate.longitude
            print("Current lat: \(userLatitude)")
            print("Current long: \(userLongitude)")
            
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 5.0)
            
            self.googleMaps.camera = camera
            self.googleMaps.delegate = self
            self.googleMaps?.isMyLocationEnabled = true
            self.googleMaps.settings.myLocationButton = true
            self.googleMaps.settings.compassButton = true
            self.googleMaps.settings.zoomGestures = true
            
            //show source and destination marker
            createMarker(titleMarker: "Your Current location", iconMarker: UIImage(named: "user_location_icon")! , latitude: userLatitude, longitude: userLongitude)
            createMarker(titleMarker: "Destination location", iconMarker: UIImage(named: "destination_icon")!  , latitude: destinationLatitude, longitude: destinationLongitude)
            
            drawPath()
            calculateTimeDistance()
            
        }
    }
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = googleMaps
    }
    
    //MARK: - this is function for create direction path, from start location to desination location
    func drawPath(){
        
        let origin = "\(userLatitude),\(userLongitude)"
        let destination = "\(destinationLatitude),\(destinationLongitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            
            print("response.request: \(response.request as Any)")  // original URL request
            print("response.response : \(response.response as Any)") // HTTP URL response
            print("response.data: \(response.data as Any)")     // server data
            print("response.result: \(response.result as Any)")   // result of response serialization
            
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                // print route using Polyline
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.map = self.googleMaps
                }
            }catch{
                print("error in draw path")
            }
        }
    }

    
    func calculateTimeDistance(){
        // Get current position
        let sourceCoordinates = CLLocationCoordinate2DMake(userLatitude, userLongitude)
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        // Get destination position
        let destinationCoordinates = CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinates, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // Create request
        let request = MKDirectionsRequest()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = MKDirectionsTransportType.automobile
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                self.kilometers = Int(route.distance) / 1000 // distance in km
                let sec = route.expectedTravelTime // time in minute
                self.hours = Int(sec) / 3600
                self.minutes = (Int(sec) % 3600) / 60
                self.showAlert()
                
                print("Distance: \(route.distance), time in minutes: \(route.expectedTravelTime)")
            } else {
                print("Error!")
            }
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Location Details", message: "Distance: \(self.kilometers) km \n Time: \(self.hours) hour \(minutes) minute", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Finish", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func startShowDetails(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func handleBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        // Get current position
//        let sourcePlacemark = MKPlacemark(coordinate: locations.last!.coordinate, addressDictionary: nil)
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//
//        // Get destination position
//        let lat1: NSString = "57.619302"
//        let lng1: NSString = "11.954928"
//        let destinationCoordinates = CLLocationCoordinate2DMake(lat1.doubleValue, lng1.doubleValue)
//        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinates, addressDictionary: nil)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//
//        // Create request
//        let request = MKDirectionsRequest()
//        request.source = sourceMapItem
//        request.destination = destinationMapItem
//        request.transportType = MKDirectionsTransportType.automobile
//        request.requestsAlternateRoutes = false
//        let directions = MKDirections(request: request)
//        directions.calculate { response, error in
//            if let route = response?.routes.first {
//                print("Distance: \(route.distance), ETA: \(route.expectedTravelTime)")
//            } else {
//                print("Error!")
//            }
//        }
//    }
    

    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations[0])
//
//        //userLocation - there is no need for casting, because we are now using CLLocation object
//
//        let userLocation:CLLocation = locations[0]
//        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
//        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
//
//        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 5.0)
//
//        self.googleMaps.camera = camera
//        self.googleMaps.delegate = self
//        self.googleMaps?.isMyLocationEnabled = true
//        self.googleMaps.settings.myLocationButton = true
//        self.googleMaps.settings.compassButton = true
//        self.googleMaps.settings.zoomGestures = true
//
//    }

//    func calculateDistance(){
//        let coordinate₀ = CLLocation(latitude: userLatitude, longitude: userLongitude)
//        let coordinate₁ = CLLocation(latitude: destinationLatitude, longitude: destinationLongitude)
//
//        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
//        print("distance in meters : \(distanceInMeters)")
//
//        calculateTime()
//    }
    
   
}
