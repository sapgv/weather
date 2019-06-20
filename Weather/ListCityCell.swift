//
//  ListCityCell.swift
//  Weather
//
//  Created by Sapgv on 03/06/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import UIKit

class ListCityCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var location: Location?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(location: Location) {
        self.titleLabel?.text = location.name
        self.detailLabel?.text = location.fullName
        let image = UIImage(data: location.imageData!)
        self.backgroundImageView?.image = image
    }

}
