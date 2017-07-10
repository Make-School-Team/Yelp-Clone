//
//  MapViewController.swift
//  Pley
//
//  Created by Chenyang Zhang on 7/7/17.
//  Copyright © 2017 Chenyang Zhang. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController{
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - CLGeocoder Helper Methods
    
    func displayLocation(coordinate: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(coordinate) { (placemarks, error) in
            // placemarks = Array of CLPPlacemarks
            if error != nil {
                print("error")
            } else {
                guard let currentLocation = placemarks?.first else {
                    return
                }
                var addressString = ""
                
                addressString += currentLocation.subThoroughfare!
                addressString += currentLocation.thoroughfare!
                addressString += currentLocation.subLocality!
                addressString += currentLocation.subAdministrativeArea!
                addressString += currentLocation.postalCode!
                addressString += currentLocation.country!
                print(addressString)
            }
        }
    }
    
    // MARK:- MapView Reigon & Annotations Helper Methods
    func setUpRepresentReigonOnMap(withLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, lattitudeDelta: CLLocationDegrees = 0.01, longitudeDelta: CLLocationDegrees = 0.01) {
        //        let latDelta: CLLocationDegrees = 0.01
        //        let longDelta: CLLocationDegrees = 0.01
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: lattitudeDelta, longitudeDelta: longitudeDelta)
        let reigon = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(reigon, animated: true)
        prepareForRepresentation(of: coordinate)
    }
    
    private func prepareForRepresentation (of coordinate: CLLocationCoordinate2D) {
        let annotation:MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Cross Campus LA"
        annotation.subtitle = "Home of Make School LA"
        addUserLocation(annotation: annotation)
    }
    
    private func addUserLocation(annotation: MKPointAnnotation) {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        mapView.addAnnotation(annotation)
    }
    
}
// MARK: - CLLocationManager Delegate Methods

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.first
        let lattitude = currentLocation!.coordinate.latitude
        let longitude = currentLocation!.coordinate.longitude
        self.setUpRepresentReigonOnMap(withLatitude: lattitude, longitude: longitude)
        print(lattitude, longitude)
        displayLocation(coordinate: currentLocation!)
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


extension MapViewController: MKMapViewDelegate {
    // MARK: - Annotation Customization methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pinView.pinColor = .green
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pinView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            // navigate to view of the right accessory view
            //            annotationToBeSet = view.annotation as! MKPointAnnotation
            self.performSegue(withIdentifier: "toAnnotationRightView", sender: self)
        }
    }
}
