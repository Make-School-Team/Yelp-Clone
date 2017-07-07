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
import YelpAPI
var alphaValue: [Int]? = nil
var selectedCellIndex = 0
class BusinessViewController: UIViewController {
    
    @IBOutlet weak var businessTableView: UITableView!
    let appId = "7pUDx3Dj4zW2w9LbcErk2w"
    let appSecret = "QSuOjLjha7ad4BafegjHJXuQQmISTNCmOmnBzt65ue1aRCBxuezdaICzjuRPPUdy"
    let query = YLPQuery(location: "Los Angeles, CA")
    var businesses: [YLPBusiness] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.businessTableView.reloadData()
    }
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
                            
                        }
                        self.businessTableView.reloadData()
                    }
                })
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayDetails"{
            let cell = sender as! BusinessCell
            let vc = segue.destination as! PageViewController
            let indexPath = businessTableView.indexPath(for: cell)
            if let indexPath = indexPath {
                vc.info = businesses[indexPath.row]
                vc.cell = cell
                selectedCellIndex = indexPath.row
            }
        }
    }
}
extension BusinessViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //   print(businesses.count)
        if businesses.count > 0 && alphaValue == nil  {
            alphaValue = [Int](repeating: 0, count: businesses.count)
        }
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        let businessInfo = businesses[indexPath.row]
        
        (cell as? BusinessCell)?.viewModel = BusinessCellViewModel(withBusiness: businessInfo)
        
        
        cell.likedLabel.alpha = CGFloat((alphaValue?[indexPath.row])!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        businessTableView.deselectRow(at: indexPath, animated: true)
    }
}
extension BusinessViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
