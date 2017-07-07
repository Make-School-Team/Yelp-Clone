//
//  BusinessViewController.swift
//  Pley
//
//  Created by Zhaoya Sun on 7/5/17.
//  Copyright © 2017 Chenyang Zhang. All rights reserved.
//

//
//  ViewController.swift
//  Pley
//  Created by Chenyang Zhang on 7/5/17.
//  Copyright © 2017 Chenyang Zhang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AFNetworking
import YelpAPI

class BusinessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let appId = "7pUDx3Dj4zW2w9LbcErk2w"
    let appSecret = "QSuOjLjha7ad4BafegjHJXuQQmISTNCmOmnBzt65ue1aRCBxuezdaICzjuRPPUdy"
    let query = YLPQuery(location: "San Francisco, CA")
    var businesses: [YLPBusiness] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        query.term = "dinner"
        query.limit = 25
        YLPClient.authorize(withAppId: appId, secret: appSecret) { (client, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                client?.search(with: self.query, completionHandler: { (search, error) in
                    if error != nil {
                        print(error.debugDescription)
                    } else {
                        let topBusiness = search?.businesses
                        for business in topBusiness! {
                            
                            self.businesses.append(business)
                            //print(business)
                            //print(self.businesses)
                        }
                        self.tableView.reloadData()
                        // print(self.businesses.count)
                        
                    }
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //  print(businesses.count)
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //   print(businesses.count)
        return businesses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        let businessInfo = businesses[indexPath.row]
        
        cell.nameLabel.text = businessInfo.name
        
        if businessInfo.isClosed == true {
            cell.priceLabel.text = "Open"
        } else {
            cell.priceLabel.text = "Closed"
        }
        //cell.priceLabel.text = String(businessInfo.isClosed)
        cell.ratingLabel.text = "Rating: \(businessInfo.rating)"
        cell.addressLabel.text = String(describing: businessInfo.location.address.first!)
        cell.typesLabel.text = String(describing: businessInfo.categories.first!.name)
        cell.distanceLabel.text = "Reviews: \(String(describing: businessInfo.reviewCount))"
        let data = try! Data(contentsOf: businessInfo.imageURL!)
        let image = UIImage(data: data)
        cell.businessView.image = image!
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! BusinessCell
        let vc = segue.destination as! PageViewController
        let indexPath = tableView.indexPath(for: cell)
        if let indexPath = indexPath {
            vc.info = businesses[indexPath.row]
        }
    }
}
