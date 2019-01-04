//
//  File.swift
//  PotiFy
//
//  Created by McKinney family  on 12/30/18.
//  Copyright © 2018 FasTek Technologies. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    func fadeTo(alphaValue: CGFloat, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = alphaValue
        }
    }
    
    /*
     @objc func keyboardWillChange(_ notification: NSNotification) {
     let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
     let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
     let curFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
     let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
     
     let deltaY = targetFrame.origin.y - curFrame.origin.y
     
     UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: curve), animations: {
     self.frame.origin.y += deltaY
     }, completion: nil)
     
     }
     
     func bindtoKeyboard() {
     NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIResponder.keyboardWillChangeFrame, object: nil)
     
     }
     
     */
   
    }

