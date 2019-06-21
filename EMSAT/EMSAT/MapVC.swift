//
//  MapVC.swift
//  EMSAT
//
//  Created by Avinay K on 20/06/19.
//  Copyright © 2019 avinay. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var arrAnnotation = [MKPointAnnotation]()
    var locationManager: CLLocationManager!
    
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAndPermission()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureReconizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        let location = CLLocationCoordinate2D(latitude: 23.0392467,
                                              longitude: 72.5123253)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Friends Avenue"
        annotation.subtitle = "Ahmedabad, India"
        mapView.addAnnotation(annotation)
    }
    
    fileprivate func configureAndPermission() {
        if (CLLocationManager.locationServicesEnabled()){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        let touchPoint: CGPoint = gestureReconizer.location(in: mapView)
        let newCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        addAnnotationOnLocation(pointedCoordinate: newCoordinate)
    }
    
    func addAnnotationOnLocation(pointedCoordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        self.removeAllAnnotationFromMapView()
        arrAnnotation.removeAll()
        annotation.coordinate = pointedCoordinate
        
        let lat = pointedCoordinate.latitude
        let lng = pointedCoordinate.longitude
        
        let location = CLLocation(latitude: lat, longitude: lng)
        
        // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                annotation.title = "No Matching Addresses Found...\(error.localizedDescription)"
                self.mapView.addAnnotation(annotation)
                self.arrAnnotation.append(annotation)
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    annotation.title = placemark.compactAddress
                    self.mapView.addAnnotation(annotation)
                    self.arrAnnotation.append(annotation)
                } else {
                    annotation.title = "No Matching Addresses Found..."
                    self.mapView.addAnnotation(annotation)
                    self.arrAnnotation.append(annotation)
                }
            }
        }
    }
    
    func removeAllAnnotationFromMapView(){
        arrAnnotation.forEach { (annotation) in
            mapView.removeAnnotation(annotation)
        }
    }
    
    func showCurrentLocationOnMapview(location:CLLocation!){
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        
        let location = CLLocation(latitude: lat, longitude: lng)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                annotation.title = "No Matching Addresses Found...\(error.localizedDescription)"
                self.mapView.addAnnotation(annotation)
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    annotation.title = placemark.compactAddress
                    self.mapView.addAnnotation(annotation)
                } else {
                    annotation.title = "No Matching Addresses Found..."
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            if let street = thoroughfare {
                result += ", \(street)"
            }
            if let city = locality {
                result += ", \(city)"
            }
            if let country = country {
                result += ", \(country)"
            }
            return result
        }
        return nil
    }
}

extension MapVC:CLLocationManagerDelegate{
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location  = locations.last{
            showCurrentLocationOnMapview(location: location)
            locationManager.stopUpdatingHeading()
        }
    }
}
