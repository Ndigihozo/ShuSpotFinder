//
//  FindParkingViewController.swift
//  ShuSpotFinder
//
//  Created by d.igihozo on 5/4/25.
//  FindParkingViewController.swift
//  ShuSpotFinder
import UIKit
import MapKit
import CoreLocation
import CoreData

class FindParkingViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1: // Check-out
            checkOutUser()
                    
        case 0: // Check-in
            // Show the lot selection view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let lotSelectionVC = storyboard.instantiateViewController(withIdentifier: "LotSelectionViewController") as? LotSelectionViewController {
                self.navigationController?.pushViewController(lotSelectionVC, animated: true)
            }

        default:
            break
                }
            }
    
    let locationManager = CLLocationManager()
    
    struct ParkingLot {
            let name: String
            let coordinate: CLLocationCoordinate2D
        }
    let parkingLots = [
        ParkingLot(name: "Lot A", coordinate: CLLocationCoordinate2D(latitude: 40.3089, longitude: -79.5554)),
        ParkingLot(name: "Lot B", coordinate: CLLocationCoordinate2D(latitude: 40.310015, longitude: -79.557915)),
        ParkingLot(name: "Lot C", coordinate: CLLocationCoordinate2D(latitude: 40.309276, longitude: -79.558481)),
        ParkingLot(name: "Lot D", coordinate: CLLocationCoordinate2D(latitude: 40.310513, longitude: -79.560868)),
        ParkingLot(name: "Lot E", coordinate: CLLocationCoordinate2D(latitude:  40.309652, longitude: -79.554949))
        ]
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        searchBar.delegate = self
        mapView.delegate = self
        locationManager.delegate = self
        
        // Set up map
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        
        checkLocationAuthorizationStatus()


        let campusLocation = CLLocationCoordinate2D(latitude: 40.309, longitude: -79.556)
        let region = MKCoordinateRegion(center: campusLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)

      

        // Add annotations
        for lot in parkingLots {
            let annotation = MKPointAnnotation()
            annotation.title = lot.name
            annotation.coordinate = lot.coordinate
            mapView.addAnnotation(annotation)
        }
        
        
    }
    // Search logic
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       searchBar.resignFirstResponder() // Hide keyboard
       guard let searchText = searchBar.text?.lowercased() else { return }

       if let matchedLot = parkingLots.first(where: { $0.name.lowercased().contains(searchText) }) {
           let closeRegion = MKCoordinateRegion(center: matchedLot.coordinate, latitudinalMeters: 50, longitudinalMeters: 50) // VERY close zoom
           mapView.setRegion(closeRegion, animated: true)
       }
   }
    func checkLocationAuthorizationStatus() {
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // Handle denied or restricted access
            break
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
    }
    func checkOutUser() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()

        do {
            let users = try context.fetch(request)
            
            if let currentUser = users.first, let lot = currentUser.currentlot {
                // Fetch current trends (parking lot check-ins)
                var trends = currentUser.parkinglottrend ?? [:]

                // Debugging: Check current lot and trends
                print("Before checkout - current lot: \(lot)")
                print("Before checkout - trends: \(trends)")

                // Check if the lot exists and if the count is greater than 0
                if var count = trends[lot], count > 0 {
                    // Decrease trend count
                    count -= 1
                    trends[lot] = count // Save the new count back to the dictionary
                    print("Decreased count for \(lot), new count: \(count)")
                } else {
                    print("No check-ins to decrement for \(lot) or lot is not found in trends.")
                }

                // Update the user's parkinglottrend and clear the currentlot
                currentUser.parkinglottrend = trends
                currentUser.currentlot = nil // User has checked out

                // Save the changes
                try context.save()
                print("Checked out from \(lot) and saved the trend.")
                
                // Debugging: Check trends after saving
                print("After checkout - trends: \(currentUser.parkinglottrend ?? [:])")
            } else {
                print("No lot to check out from or user data not found.")
            }
        } catch {
            print("Error checking out: \(error.localizedDescription)")
        }
    }
    var lotTrends: [String: Int] = [:]
    
    // Function to get the trend for a specific lot
    func getTrendForLot(lot: String) -> Int {
        return lotTrends[lot] ?? 0 // Return the number of users or 0 if not found
    }

    // Function to save a specific lot trend
    func saveTrend(forLot lot: String, count: Int) {
        lotTrends[lot] = count
        UserDefaults.standard.set(lotTrends, forKey: "lotUsageTrend")
    }

    // Optional: Load trends from UserDefaults when the app starts
    func loadTrends() {
        if let savedTrends = UserDefaults.standard.dictionary(forKey: "lotUsageTrend") as? [String: Int] {
            lotTrends = savedTrends
        }
    }

    // Function to update trend, with decrement or increment
    func updateTrend(forLot lot: String, decrement: Bool) {
        var currentTrend = getTrendForLot(lot: lot) // Get the current count
        if decrement {
            currentTrend = max(0, currentTrend - 1) // Prevent negative numbers
        } else {
            currentTrend += 1
        }
        saveTrend(forLot: lot, count: currentTrend)
    }

    // Function to handle checkout
    func checkOutFromLot(lot: String) {
        updateTrend(forLot: lot, decrement: true)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentControl.selectedSegmentIndex = UISegmentedControl.noSegment
    }



}
