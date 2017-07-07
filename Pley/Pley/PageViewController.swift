//
//  PageViewController.swift
//  Pley
//
//  Created by Chenyang Zhang on 7/6/17.
//  Copyright © 2017 Chenyang Zhang. All rights reserved.
//

import Foundation
import UIKit
import YelpAPI
class PageViewController: UIViewController {
    
    var info: YLPBusiness?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let info = info else{
            print("error")
            return
        }
        nameLabel.text = info.name
        locationLabel.text = "Address: \(info.location.address.first!)"
        if info.phone != nil {
            phoneNumberLabel.text = "Contact Info: \(info.phone!)"
        } else {
            phoneNumberLabel.text = "No Contact Info"
        }
        reviewCountLabel.text = "Rating: \(String(info.rating))"
        let data = try! Data(contentsOf: info.imageURL!)
        let image = UIImage(data: data)
        imageView.image = image!

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

