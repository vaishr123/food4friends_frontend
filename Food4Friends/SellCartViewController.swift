//
//  SellCartViewController.swift
//  Food4Friends
//
//  Created by Amy Chern on 4/16/17.
//  Copyright © 2017 Vaish Raman. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Foundation
import Alamofire

func minutesToHoursMinutesSeconds (minutes : Int) -> (Int, Int, Int) {
    return (minutes / 60, (minutes % 60), (minutes % 60) % 60)
}

var buyerids: [String] = []
var buyersServings: [Int] = []
var globalTimeRemaining: Int = 0
var globalServingsRemaining: Int = 0
var saleJustFinished: Bool = false

class SellCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var numServings: UILabel!
    @IBOutlet weak var itemSold: UILabel!
    
    var refreshControl: UIRefreshControl!
    
    func update() {
        globalTimeRemaining = globalTimeRemaining - 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemSold.text = "Selling: " + sellingItem
        self.numServings.text = numOfServingsSelling + " servings remaining"
        //let (h,m,s) = minutesToHoursMinutesSeconds(minutes: Int(timeRemainingPosted)!)
        //self.timeRemaining.text = "\(h):\(m) remaining"
        self.timeRemaining.text = "\(timeRemainingPosted)" + " minutes remaining"
        
        globalTimeRemaining = Int(timeRemainingPosted)!
        globalServingsRemaining = Int(numOfServingsSelling)!
        
        var timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Finding new buyers")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        Alamofire.request(server + "/api/v1/sell/complete/").responseJSON(completionHandler: {
            response in
            print(response.result)
            
            if let JSON = response.result.value as? NSDictionary {
                print("json:")
                print(JSON)
                
                if let arrJSON = JSON["transactions"] as? NSArray {
                    for transaction in (arrJSON as? [[String:Any]])!{
                        buyerids.append(transaction["buyerid"] as! String)
                        buyersServings.append(transaction["servings"] as! Int)
                    }
                }
            }
        })
    }
    
    func refresh(sender:AnyObject) {
        Alamofire.request(server + "/api/v1/sell/complete/").responseJSON(completionHandler: {
            response in
            print(response.result)
            
            if let JSON = response.result.value as? NSDictionary {
                print("json:")
                print(JSON)
                buyerids = []
                buyersServings = []
                
                if let arrJSON = JSON["transactions"] as? NSArray {
                    for transaction in (arrJSON as? [[String:Any]])!{
                        buyerids.append(transaction["buyerid"] as! String)
                        buyersServings.append(transaction["servings"] as! Int)
                    }
                }
            }
            self.timeRemaining.text = "\(String(globalTimeRemaining))" + " minutes remaining"
            self.numServings.text = "\(String(globalServingsRemaining))" + " servings remaining"
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "Complete") { action, index in
            print("Complete button tapped")
            let parameters: Parameters = [
                "userid": String(userid)!,
                "buyerid": String(10208834233036319)
            ]
            Alamofire.request(server + "/api/v1/sell/complete/", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseString(completionHandler: {response in
                print(response.result)
            })
            globalServingsRemaining = globalServingsRemaining - buyersServings[editActionsForRowAt.row]
            buyerids.remove(at: editActionsForRowAt.row)
            buyersServings.remove(at: editActionsForRowAt.row)

            if(globalServingsRemaining <= 0 || globalTimeRemaining <= 0) {
                saleJustFinished = true
                Singleton.sharedInstance.imageValue = UIImage()
                self.dismiss(animated: true, completion: nil)
            }
            self.refresh(sender: self)
            //self.tableView.reloadData()
            
        }
        more.backgroundColor = UIColor.lightGray
        
        return [more]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buyerids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SellCartTableViewCell
        
        let tokenVal = "EAAFhbcIKPLABANr1W5jOebrbZAm8BZAZC4E94OFbAPxulanTp5rZAGo0vUKQCO9K3pJ4Cd0rzsKZC0FBJkfZAN4eYngywdVNZAuN7HPChvtfeBrT2EQVeIbAURnHmvCUF6ymXQgwuM1D3kxhQi1fc97WQuzbbt2ENMkXDWb9KVZAk3e5ItC0iFJMrje33HRZBsmpmPxXApb8bhoF2XZCI3JF47Wh58hrh3CtEZD"
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name, picture.type(small)"], tokenString: tokenVal, version: nil , httpMethod: "GET");
        
        request?.start(completionHandler: { [weak self] connection, result, error in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            else{
                let fbResult = result as! Dictionary<String, AnyObject>
                print(fbResult)
                
                cell?.buyerName.text = fbResult["name"] as! String?
                let pic = fbResult["picture"]
                let data = pic?["data"] as! Dictionary<String, AnyObject>
                let url = URL(string: data["url"] as! String)
                
                self?.getDataFromUrl(url: url!) { (data, response, error)  in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url?.lastPathComponent ?? "no response")
                    cell?.buyerImage.contentMode = UIViewContentMode.scaleAspectFill
                    cell?.buyerImage.clipsToBounds = true;
                    cell?.buyerImage.layer.cornerRadius = 10;
                    cell?.buyerImage.image = UIImage(data: data)
                }
            }
            
        })
        cell?.buyerServings.text = String(buyersServings[indexPath.row])
        return cell!
    }
}
