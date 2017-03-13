//
//  ListTableVC.swift
//  Maps me
//
//  Created by XGus on 2/22/2560 BE.
//  Copyright © 2560 Wizardapp.me. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import Parse

class ListTableVC: UIViewController,CLLocationManagerDelegate, UITableViewDataSource,UITableViewDelegate {
    
    var locationManager = CLLocationManager()
    
    var placeArr = [Place]()
    
    var userID:String = ""
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        profile()
        
        
    }
    
    func profile(){
        
        PFUser.current()?.fetchInBackground(block: { (ob, error) in
            if error != nil {
                print(error)
            }else{
                if let user = ob as? PFUser {
                    if let u = user.email?.components(separatedBy: "@") {
                        self.title = u[0]
                    }
                }
            }
        })
    }
    
    
    @IBAction func ReloadData() {
        loadData()
        print("array count \(placeArr.count)")
    }
    
    
    func loadData() {
        placeArr.removeAll()
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (ob, error) in
            
            if error != nil {
                print(error)
            }else if let ob = ob {
                
                for user in ob {
                    
                    if let user = user as? PFUser {
                        
                        if user.objectId == PFUser.current()?.objectId {
                            
                            self.userID = user.objectId!
                            
                            let place = PFQuery(className: "Places")
                            
                            place.whereKey("usersID", equalTo: user.objectId!)
                            
                            place.findObjectsInBackground(block: { (ob, error) in
                                
                                if let ob = ob {
                                    
                                    print(ob.count)
                                    if ob.count > 0 {
                                        
                                        
                                        
                                        place.findObjectsInBackground(block: { (ob, error) in
                                            if error != nil {
                                                print(error)
                                            }else{
                                                if let ob = ob {
                                                    
                                                    for data in ob {
                                                        
                                                        if let place = data as? PFObject{
                                                            
                                                            let p = Place()
                                                            p.placeName =  (place.object(forKey: "names") as? String)!
                                                            p.placeAddress =  (place.object(forKey: "address") as? String)!
                                                            
                                                            let lat = (place.object(forKey: "latitude") as? String)!
                                                            let long = (place.object(forKey: "longitude") as? String)!
                                                            
                                                            p.latitude =  CLLocationDegrees(Float(lat)!)
                                                            p.longitude = CLLocationDegrees(Float(long)!)
                                                            
                                                            self.placeArr.append(p)
                                                            print("name \(place.object(forKey: "names"))  userID \(place.object(forKey: "usersID"))")
                                                            
                                                        }
                                                    }
                                                }
                                                self.tableview.reloadData()
                                            }
                                        })
                                        
                                        
                                    }
                                }
                            })
                        }
                    }
                    
                }
            }
        })
        
        
    }
    
    
    @IBAction func logoutBtn() {
        PFUser.logOut()
        dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "showLogin", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("viewDidAppear")
        //profile()
        ReloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if placeArr.count > 0 {
            return placeArr.count
        }else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        let p = placeArr[indexPath.row]
        
        cell.nameLabel.text = "\(p.placeName)"
        cell.addressLabel.text = "\(p.placeAddress)"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.performSegue(withIdentifier: "ShowViewMaps", sender: self)
        
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            placeArr.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
    
    
    @IBAction func addPlaceMaps() {
        performSegue(withIdentifier: "ShowViewAddMaps", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "ShowViewMaps" == segue.identifier {
            
            let vc = segue.destination as! ShowPlaceVC
            let indexpath =  self.tableview.indexPathForSelectedRow
            
            let p = placeArr[(indexpath?.row)!]
            
            vc.currentTitle = p.placeName
            vc.currentSnippet = p.placeAddress
            vc.currentlat = p.latitude
            vc.currentlong = p.longitude
            
            
        }
    }
    
    
}
