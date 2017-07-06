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

class BusinessViewController: UITableViewController {
    var access_token: String? = nil // The access token which you'll use to access Yelp Fusion API endpoints. this device has permission to api
    let baseURL = "https://api.yelp.com/oauth2/token" // URL for getting access
    let grant_type = "client_credentials" // A paramter that tells the server we want access for "client"
    let client_id = "7pUDx3Dj4zW2w9LbcErk2w" //specific info so server will know who requests and for what 
    let client_secret = "QSuOjLjha7ad4BafegjHJXuQQmISTNCmOmnBzt65ue1aRCBxuezdaICzjuRPPUdy" // put your secret here
    
    let searchURL = "https://api.yelp.com/v3/businesses/search" // url for searching things
    
    let location = "Los Angeles, CA" //location
    
    var businesses: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getToken()
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //the fourth is encoding which is the format in which we are sending the information, and then headers are nil because we don't have any
    func getToken() {
        Alamofire.request(baseURL, method: .post, parameters: ["grant_type" : grant_type, "client_secret": client_secret], encoding: URLEncoding.default, headers: nil).validate().responseJSON {
            response in
            
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    let info = JSON(value)
                    
                    self.access_token = info["access_token"].stringValue //Store it into the token variable so we can use it later on to tell the server we already have access to it
                    
                }
            case false:
                print(response.result.error?.localizedDescription ?? "error")
            }
        }
    }
    
    func loadBusiness() {
        guard let access_token = access_token else {
            getToken()
            return
        }
        Alamofire.request(searchURL, method: .get, parameters: ["location": location], encoding: URLEncoding.default, headers: ["Authorization": "Bearer \(access_token)"]).validate().responseJSON {
            response in
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    let info = JSON(value)
                    
                    let businesses = info["businesses"].arrayValue //store the businesses info
                    for business in businesses {
                        self.businesses.append(Business(json:business))
                    }
                    
                    self.tableView.reloadData()
                    
                }
            case false:
                print(response.result.error?.localizedDescription ?? "error")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        return cell
    }

    
    
    
}
