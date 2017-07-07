//
//  BusinessCell.swift
//  Pley
//
//  Created by Zhaoya Sun on 7/5/17.
//  Copyright © 2017 Chenyang Zhang. All rights reserved.
//

import Foundation
import UIKit

class BusinessCell: UITableViewCell {
    @IBOutlet weak var businessView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    
    var business: Business? = nil {
        didSet {
           nameLabel.text = business?.name
           priceLabel.text = business?.price
           ratingLabel.text = String(describing: business?.rating)
           addressLabel.text = business?.location
           typesLabel.text = business?.types
           distanceLabel.text = String(describing: business?.distance)
           let imageURL = URL(string: (business?.imageURL)!)
           businessView?.setImageWith(imageURL!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
