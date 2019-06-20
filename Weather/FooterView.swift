//
//  FooterView.swift
//  Weather
//
//  Created by Grigoriy Sapogov on 18.06.2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    class func instanceFromNib() -> UIView? {
        
        return UINib(nibName: "FooterView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
    }
}
