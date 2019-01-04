//
//  CenterVCDelegate.swift
//  PotiFy
//
//  Created by McKinney family  on 12/29/18.
//  Copyright © 2018 FasTek Technologies. All rights reserved.
//

import Foundation
import UIKit

protocol CenterVCDelegate {
    func toggleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool)
    
}
