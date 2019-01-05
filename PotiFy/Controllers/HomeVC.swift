//
//  ViewController.swift
//  PotiFy
//
//  Created by McKinney family  on 11/11/18.
//  Copyright © 2018 FasTek Technologies. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class HomeVC: UIViewController {

    @IBOutlet weak var centMapBtn: UIButton!
        
    var regionRadius: CLLocationDistance = 1000
    //regional radius
    
    var manager: CLLocationManager?
    //CLLocation manager
    
    var delegate: CenterVCDelegate?
    //centerDelegate var
    
    //ViewDidload func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadDriverAnnotationsFromFB()
        
        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.startUpdatingLocation()
        manager?.delegate = self
        
        /*
        DataService.instance.REF_DRIVERS.observe(.value) { (snapshot) in
            self.loadDriverAnnotationsFromFB()
        }
        */
        
        checkLocationAuthStatus()
        centerMapOnUserLocation()
        mapView.delegate = self
        checkLocationAuthStatus()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //loadDriverAnnotationsFromFB()
    }
    
    //functions
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            manager?.startUpdatingLocation()
            
            
            
        } else {
            manager?.requestAlwaysAuthorization()
        }
    }
    
    func loadDriverAnnotationsFromFB() {
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let driverSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for drivers in driverSnapshot {
                    if drivers.hasChild("userIsDriver") {
                        if drivers.hasChild("coordinate") {
                            if drivers.childSnapshot(forPath: "isPickupModeEnabled").value as? Bool == true {
                                if let driverDict = drivers.value as? Dictionary<String, AnyObject> {
                                    let coordinatArray = driverDict["coordinate"] as! NSArray
                                    let driverCoordinate = CLLocationCoordinate2D(latitude: coordinatArray[0] as! CLLocationDegrees, longitude: coordinatArray[1] as! CLLocationDegrees)
                                    
                                    let annotation = DriverAnnotation(coordinate: driverCoordinate, withKey: drivers.key)
                                    
                                    var driverIsVisible: Bool {
                                        return self.mapView.annotations.contains(where: { (annotation) -> Bool in
                                            if let driverAnnotation = annotation as? DriverAnnotation {
                                                if driverAnnotation.key == drivers.key {
                                                    driverAnnotation.update(annotationPosition: driverAnnotation, withCoordinate: driverCoordinate)
                                                    return true
                                                    
                                                }
                                                
                                                
                                                
                                            }
                                            return false
                                        })
                                        
                                    }
                                    if !driverIsVisible {
                                        self.mapView.addAnnotation(annotation)
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                    
                }
            }
        })
    }
    
    
    
    
    //func to center location
    func centerMapOnUserLocation() {
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate
            , latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //loaddriver annotation function
   
    
    
    
    //IBAction func
    @IBAction func menuBtnWasPressed(_ sender: Any) {
        delegate?.toggleLeftPanel()
    }
    
    //action button outlet
    @IBOutlet weak var actionBtn: RoundedShadowButton!
    
    //IBAction button pressed func
    @IBAction func actionButtonWasPressed(_ sender: Any){
        actionBtn.animateButton(shouldLoad: true, withMessage: "")
    }
    
    //mapView Outlet
    @IBOutlet weak var mapView: MKMapView!
    
    
    //centerBtn IB Function
    @IBAction func centerBtnWasPressed(_ sender: Any) {
        centerMapOnUserLocation()
        centMapBtn.fadeTo(alphaValue: 0.0, withDuration: 0.2)
    }
    
    


}

// extensions

extension HomeVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        UpdateService.instance.updateUserLocation(withCoordinate: userLocation.coordinate)
        UpdateService.instance.updateDriverLocation(withCoordinate: userLocation.coordinate)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let identifier = "driver"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "driverAnnotation")
            return view
            
        }
        
        return nil
        
    }
    
    
}

extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthStatus()
        if status == .authorizedAlways {
            
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}
