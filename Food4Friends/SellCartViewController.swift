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

class SellCartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var numServings: UILabel!
    @IBOutlet weak var itemSold: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemSold.text = "Selling: " + sellingItem
        self.numServings.text = numOfServingsSelling + " servings"
        let (h,m,s) = minutesToHoursMinutesSeconds(minutes: Int(timeRemainingPosted)!)
        self.timeRemaining.text = "\(h):\(m):\(s) remaining"
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SellCartTableViewCell
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name, picture.type(large)"], tokenString: userToken, version: nil , httpMethod: "GET");
        
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
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let buyConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "buyConfirmationPage") as! BuyConfirmationViewController
        
        // Creates Popover View
        let nav = UINavigationController(rootViewController: buyConfirmVC)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        nav.navigationBar.isHidden = true
        let popover = nav.popoverPresentationController
        popover?.sourceView = self.view
        
        self.present(nav, animated: true, completion: nil)
        
    }
}
