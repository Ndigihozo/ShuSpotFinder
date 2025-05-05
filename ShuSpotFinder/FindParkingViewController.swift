//
//  FindParkingViewController.swift
//  ShuSpotFinder
//
//  Created by d.igihozo on 5/4/25.
//
import UIKit
import MapKit
import CoreLocation

class FindParkingViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // Set initial region to university
        let campusLocation = CLLocationCoordinate2D(latitude: 40.309, longitude: -79.556)
        let region = MKCoordinateRegion(center: campusLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        //Zoom in and out
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true


        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
       

    }
}

extension FindParkingViewController: MKMapViewDelegate {
}
