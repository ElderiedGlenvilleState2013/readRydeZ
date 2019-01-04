//
//  LeftSidePanelVC.swift
//  PotiFy
//
//  Created by McKinney family  on 12/25/18.
//  Copyright © 2018 FasTek Technologies. All rights reserved.
//

import UIKit
import Firebase

class LeftSidePanelVC: UIViewController {

    
    
    let appDelegate = AppDelegate.getAppDelegate()
    let currentUserId = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var userEmailLbl: UILabel!
    
    @IBOutlet weak var userAccountTypeLbl: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var pickupModeLbl: UILabel!
    @IBOutlet weak var pickupModeSwitch: UISwitch!
    @IBOutlet weak var loginOutBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pickupModeSwitch.isHidden = true
        pickupModeSwitch.isOn = false
        pickupModeLbl.isHidden = true
        
        observePassengersAndDriver()
        
        if Auth.auth().currentUser == nil {
            userEmailLbl.text = " "
            userAccountTypeLbl.text = " "
            userImageView.isHidden = true
            loginOutBtn.setTitle("Sign UP / Login", for: .normal)
        
            
        } else {
            userEmailLbl.text = Auth.auth().currentUser?.email
            userAccountTypeLbl.text = ""
            userImageView.isHidden = false
            loginOutBtn.setTitle("logout", for: .normal)
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func switchWasToggled(_ sender: Any) {
        if pickupModeSwitch.isOn {
            pickupModeLbl.text = "PICKUP MODE ENABLED"
            appDelegate.MenuContainerVC.toggleLeftPanel()
        
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues(["isPickupModeEnabled": true])
            
        
        } else {
            
            pickupModeLbl.text = "PICKUP MODE DISABLED"
            appDelegate.MenuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues(["isPickupModeEnabled": false])
        }
        
        
        
    }
    
    func observePassengersAndDriver() {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountTypeLbl.text = "PASSENGER"
                    }
                }
                
            }
        }
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountTypeLbl.text = "DRIVER"
                        self.pickupModeSwitch.isHidden = false
                        
                        let switchStatus = snap.childSnapshot(forPath: "isPickupModeEnabled").value as! Bool
                        self.pickupModeSwitch.isOn = switchStatus
                        self.pickupModeLbl.isHidden = false
                    }
                }
            }
        }
    }

    @IBAction func signUpLoginBtnWasPressed(_ sender: Any) {
        
        if Auth.auth().currentUser == nil {
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            present(loginVC!, animated: true, completion: nil)
            
        } else {
            do {
                try Auth.auth().signOut()
                userEmailLbl.text = ""
                userAccountTypeLbl.text = ""
                userImageView.isHidden = true
                pickupModeLbl.text = ""
                pickupModeSwitch.isHidden = true
                loginOutBtn.setTitle("Sign Up / Login", for: .normal)
            } catch (let error) {
                print(error)
            }
        }
        
     
    }
    
    
    
}
