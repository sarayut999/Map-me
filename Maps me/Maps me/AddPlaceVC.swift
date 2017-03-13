//
//  AddPlaceViewController.swift
//  Maps me
//
//  Created by XGus on 2/21/2560 BE.
//  Copyright © 2560 Wizardapp.me. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Parse

class AddPlaceVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapsView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    var placesClient = GMSPlacesClient()
    
    let geocoder = GMSGeocoder()
    
    
    
    var currentTitle = ""
    var currentSnippet = ""
    var currentlat: CLLocationDegrees = 0.0
    var currentlong:CLLocationDegrees = 0.0

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //locationManager.startMonitoringSignificantLocationChanges()
        
        initGoogleMaps()
    }
    
    func initGoogleMaps() {
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    
                    let camera = GMSCameraPosition.camera(withLatitude:  place.coordinate.latitude, longitude:place.coordinate.longitude, zoom: 14.0)
                    let mapView = GMSMapView.map(withFrame: self.mapsView.bounds, camera: camera)
                    mapView.isMyLocationEnabled = true
                    self.mapsView.camera = camera
                    
                    self.mapsView.delegate = self
                    
                    self.mapsView.isMyLocationEnabled = true
                    self.mapsView.settings.myLocationButton = true

                }
            }
        })
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "ShowDetail" == segue.identifier {
            
            let vc = segue.destination as! DetailVC
            
            vc.currentTitle = currentTitle as String!
            vc.currentSnippet = currentSnippet as String!
            vc.currentlat = currentlat
            vc.currentlong = currentlong
            
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveData(name:String,address:String,lat:CLLocationDegrees,long:CLLocationDegrees) {
        
        let newlat = String(lat)
        let newlong = String(long)
        
        let request = PFObject(className: "Places")
        
        request["usersID"]    = PFUser.current()?.objectId
        request["names"]      = name
        request["address"]    = address
        request["latitude"]   = newlat
        request["longitude"]  = newlong
        
        request.saveInBackground { (success, error) in
            
            if error != nil {
                if let error = error {
                    print("error = \(error)")
                }
            }else{
                
                print("send request successfully.")
            }
            
            
        }
        
        request.remove(forKey: "")
        
    }
    

    
    // MARK: GMSMapview Delegate
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        print("Add")
        
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            guard error == nil else {
                return
            }
            
            if let result = response?.firstResult() {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                marker.title = result.lines?[0]
                marker.snippet = result.lines?[1]
                marker.map = self.mapsView
                
                
                
                let p = Place()
                p.placeName = (result.lines?[0])!
                p.placeAddress = (result.lines?[1])!
                p.latitude = coordinate.latitude
                p.longitude = coordinate.longitude
                
                //placeArr.append(p)
                
                self.saveData(name: p.placeName, address: p.placeAddress, lat: p.latitude, long: p.longitude)
                
            }
        }
        
        
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        self.mapsView.isMyLocationEnabled = true
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        self.mapsView.isMyLocationEnabled = true
        if (gesture) {
            mapView.selectedMarker = nil
        }
        
    }
    
    //select tab
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        
        currentTitle = marker.title!
        currentSnippet = marker.snippet!
        currentlat = marker.position.latitude
        currentlong = marker.position.longitude
        
        print("didTapInfoWindowOf \(marker.title) \(marker.snippet)")
        
       performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    

    
    
    //Search
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func searchAutocomplete(sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: false, completion: nil)
    }
    
    func updateData(name:String,address:String,lat:CLLocationDegrees,long:CLLocationDegrees) {
        
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.mapsView.camera = camera
        
        self.mapsView.delegate = self

    }

}



extension AddPlaceVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        updateData(name: place.name, address: (place.formattedAddress!), lat: place.coordinate.latitude, long: place.coordinate.longitude)
        
        
        dismiss(animated: false, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: false, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: false, completion: nil)
    }
}
