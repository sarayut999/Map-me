//
//  MapsViewController.swift
//  Maps me
//
//  Created by XGus on 2/21/2560 BE.
//  Copyright © 2560 Wizardapp.me. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ShowPlaceVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapsView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    var currentTitle = ""
    var currentSnippet = ""
    var currentlat:CLLocationDegrees = 0.0
    var currentlong:CLLocationDegrees = 0.0
    
    let geocoder = GMSGeocoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        
        initGoogleMaps()
        
    }
    
    
    func initGoogleMaps() {
        
        let camera = GMSCameraPosition.camera(withLatitude: currentlat, longitude: currentlong, zoom: 14.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.mapsView.camera = camera
        
        self.mapsView.delegate = self
        //self.mapsView.isMyLocationEnabled = true
        //self.mapsView.settings.myLocationButton = true
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: currentlat, longitude: currentlong)
        marker.title = currentTitle
        marker.snippet = currentSnippet
        marker.map = mapsView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "ShowDetail" == segue.identifier {
            
            let vc = segue.destination as! DetailVC
            
            vc.currentTitle = currentTitle
            vc.currentSnippet = currentSnippet
            vc.currentlat = currentlat
            vc.currentlong = currentlong
            
        }
    }
    
    // MARK: GMSMapview Delegate
    //select tab
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        
        currentTitle = marker.title!
        currentSnippet = marker.snippet!
        currentlat = marker.position.latitude
        currentlong = marker.position.longitude
        
        print("didTapInfoWindowOf \(marker.title) \(marker.snippet)")
        
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
}
