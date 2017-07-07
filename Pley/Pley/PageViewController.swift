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
    
    var cell: BusinessCell?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UIButton!
    @IBOutlet weak var reviewCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let info = info else{
            print("error")
            return
        }
        nameLabel.text = info.name
        if info.location.address.first != nil {
            locationLabel.text = String(info.location.address.first!)
        } else {
            locationLabel.text = "Address Not Provided"
        }
        if info.phone != nil {
            phoneNumberLabel.setTitle(String(info.phone!), for: .normal)
        } else {
            phoneNumberLabel.setTitle("Contact Info Not Provided", for: .normal)
        }
        reviewCountLabel.text = "Rating: \(String(info.rating))"
        let data = try! Data(contentsOf: info.imageURL!)
        let image = UIImage(data: data)
        imageView.image = image!
    }
    
    @IBAction func phoneNumberTapped(_ sender: UIButton) {
        guard let info = info else{
            print("error")
            return
        }
        
        if info.phone != nil{
            if let url = URL(string: "tel://\(info.phone!)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        if alphaValue?[selectedCellIndex] == 0 {
            alphaValue?[selectedCellIndex] = 1
        } else {
            alphaValue?[selectedCellIndex] = 0
        }
        self.navigationController?.popViewController(animated: true);

    }
}


