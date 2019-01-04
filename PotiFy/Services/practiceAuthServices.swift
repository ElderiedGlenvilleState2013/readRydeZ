//
//  practiceAuthServices.swift
//  PotiFy
//
//  Created by McKinney family  on 12/31/18.
//  Copyright © 2018 FasTek Technologies. All rights reserved.
//

import Foundation

/*
 AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!) { (success, loginError) in
 if success {
 self.dismiss(animated: true, completion: nil)
 
 } else {
 print(String(describing: loginError?.localizedDescription))
 }
 
 AuthService.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, registrationError) in
 if success {
 Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: {(user, Error) in
 if Error == nil {
 if let user = user {
 if self.segmentedControl.selectedSegmentIndex == 0 {
 let userData = ["provider": user.providerID] as [String: Any]
 DataService.instance.createDBUser(uid: user.uid, userData: userData, isDriver: false)
 
 } else {
 let userData = ["provider": user.providerID, "userIsDriver": true, "isPickupModeEnabled": false, "driverIsOnTrip": false] as [String: Any]
 DataService.instance.createDBUser(uid: user.uid, userData: userData, isDriver: true)
 }
 }
 }
 })
 AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
 self.dismiss(animated: true, completion: nil)
 print("sucessfully registered user")
 })
 
 } else {
 
 print(String(describing: registrationError?.localizedDescription))
 }
 
 
 })
 }
 }
 
 */

 
