//
//  RoundImageView.swift
//  PotiFy
//
//  Created by McKinney family  on 12/23/18.
//  Copyright © 2018 FasTek Technologies. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    
    override func awakeFromNib() {
        setupView()
    }

    func setupView() {
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }

}
