//
//  LoginVC.swift
//  PotiFy
//
//  Created by McKinney family  on 12/30/18.
//  Copyright © 2018 FasTek Technologies. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var authBtn: UIButton!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        passwordField.delegate = self
        
        //view.bindtoKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender: )))
        self.view.addGestureRecognizer(tap)
    }
    
    
        // Do any additional setup after loading the view.
    
    

    @IBAction func authBtnWasPressed(_ sender: Any){
        if emailField.text != nil && passwordField.text != nil {
            self.view.endEditing(true)
            
            if let email = emailField.text, let password = passwordField.text {
                Auth.auth().signIn(withEmail: email, password: password, completion: {(user, Error) in
                    if Error == nil {
                        if let user = user {
                            if self.segmentedControl.selectedSegmentIndex == 0 {
                                let userData = ["provider": user.providerID] as [String: Any]
                                DataService.instance.createDBUser(uid: user.uid, userData: userData, isDriver: false)
                                
                            } else {
                                let userData = ["provider": user.providerID, "userIsDriver": true, "isPickupModeEnabled": false, "driverOnTrip": false] as [String: Any]
                                DataService.instance.createDBUser(uid: user.uid, userData: userData, isDriver: true)
                            }
                        }
                        print("Email user is authenticated successfully with firebase")
                        self.dismiss(animated: true, completion: nil)
                        
                        
                        
                    } else {
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                                    switch errorCode {
                                    case.invalidEmail :
                                        print("that email exist")
                                    case.wrongPassword:
                                        print("whoops that was the wrong code")
                                    case.emailAlreadyInUse:
                                        print("email is in use by different user")
                                    default:
                                        print(" an unexpected error")
                                        
                                    }
                                }
                            } else {
                                if let user = user {
                                    if self.segmentedControl.selectedSegmentIndex == 0 {
                                        let userData = ["provider": user.providerID] as [String: Any]
                                        DataService.instance.createDBUser(uid: user.uid, userData: userData, isDriver: false)
                                    } else {
                                        let userData = ["provider": user.providerID, "userIsDriver": true, "isPickupModeEnabled": false, "driverIsOnTrip": false ] as [String: Any]
                                        DataService.instance.createDBUser(uid: user.uid, userData: userData, isDriver: true)
                                    }
                                }
                                print("Succes created a new user" )
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
    }
        
        
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }




}
