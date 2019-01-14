//
//  PassengerAnnotation.swift
//  PotiFy
//
//  Created by McKinney family  on 1/13/19.
//  Copyright © 2019 FasTek Technologies. All rights reserved.
//

import Foundation
import MapKit


class PassengerAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, key: String) {
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
    
}
