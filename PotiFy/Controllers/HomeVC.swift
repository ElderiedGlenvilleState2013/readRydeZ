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
    
    //functions
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            manager?.delegate = self
            
            
            
        } else {
            manager?.requestAlwaysAuthorization()
        }
    }
    
    //func to center location
    func centerMapOnUserLocation() {
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate
            , latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //loaddriver annotation function
    /*
    func loadDriverAnnotationsFromFB() {
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let driverSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for driver in driverSnapshot {
                    if driver.hasChild("userIsDriver") {
                        if driver.hasChild("coordinate") {
                            if driver.childSnapshot(forPath: "isPickupModeEnabled").value as? Bool == true {
                                if let driverDict = driver.value as? Dictionary<String, AnyObject> {
                                    let coordinateArray = driverDict["coordinate"] as! NSArray
                                    let driverCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
                                    
                                    let annotation = DriverAnnotation(coordinate: driverCoordinate, withKey: driver.key)
                                    
                                    var driverIsVisible: Bool {
                                        return self.loadView().annotations.contains(where: { (annotation) -> Bool in
                                            if let driverAnnotation = annotation as? DriverAnnotation {
                                                if driverAnnotation.key == driver.key {
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
     
                                } else {
                                    for annotation in self.mapView.annotations {
                                        if annotation.isKind(of: DriverAnnotation.self) {
                                            if DriverAnnotation.key == driver.key {
                                                self.mapView.removeAnnotation(annotation)
     
                        }
                    }
                }
                    }
                    
        }
                    }
                }
            }
        })
    }
 */
    
    
    
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
    
    //ViewDidload func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.startUpdatingLocation()
        manager?.delegate = self 
        
        
       /*
        DataService.instance.REF_DRIVERS.observe(.value) { (snapshot) in
            self.loadDriverAnnotationsFromFB()
        }
        
        loadDriverAnnotationsFromFB()
       */
        checkLocationAuthStatus()
        centerMapOnUserLocation()
        mapView.delegate = self
      //  checkLocationAuthStatus()
        
        // Do any additional setup after loading the view, typically from a nib.
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
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        centMapBtn.fadeTo(alphaValue: 1.0, withDuration: 0.2)
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