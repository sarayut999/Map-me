//
//  DetailVC.swift
//  Maps me
//
//  Created by XGus on 2/21/2560 BE.
//  Copyright © 2560 Wizardapp.me. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class DetailVC: UIViewController {
    
    @IBOutlet weak var mapsView: GMSMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var snippetTextView: UITextView!
    
    
    
    var currentTitle = ""
    var currentSnippet = ""
    var currentlat: CLLocationDegrees = 0.0
    var currentlong:CLLocationDegrees = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("result \(currentTitle) \(currentSnippet) \(currentlat) \(currentlong)")
        
        titleLabel.text = currentTitle
        snippetTextView.text = currentSnippet.components(separatedBy: ", ").joined(separator: "\n")
        
        initGoogleMaps()
    }
    
    func initGoogleMaps() {
        
        let camera = GMSCameraPosition.camera(withLatitude: currentlat, longitude: currentlong, zoom: 14.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.mapsView.camera = camera
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
