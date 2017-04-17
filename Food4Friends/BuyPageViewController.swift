//
//  BuyPageViewController.swift
//  Food4Friends
//
//  Created by Vaish Raman on 4/4/17.
//  Copyright © 2017 Vaish Raman. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

var servingsPurchased = -1
var images = [UIImage]()
var imageNames = [String]()
var prices = [Double]()
var names = [String]()
var servings: [Int] = []
var addresses: [Address] = []
var addressStrings: [String] = []
var times: [Double] = []
var userids: [String] = []

var selectedIndexPath = -1;

struct Address {
    var latitude: String
    var longitude: String
    init(input: String) {
        print(input)
        let array_input = input.characters.split(separator: ",")
        latitude = String(array_input[0]).trimmingCharacters(in: CharacterSet.whitespaces)
        longitude = String(array_input[1]).trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

class BuyPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
       
    @IBOutlet weak var noFoodLabel: UILabel!
    
    var downloaded = 0;
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, position: Int) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            let image = UIImage(data: data)
            images[position] = image!
            self.tableView.reloadData()

            // count to hide animation icon
            self.downloaded += 1;
            if (self.downloaded == imageNames.count) {
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true;
                })
            }
        }
    }
    
    func getData() {
        Alamofire.request(server + "/api/v1/buy/").responseJSON(completionHandler: { response in
            print(response.result)
            
            if let JSON = response.result.value as? NSDictionary {
                print("JSON: \(JSON)")
                
                // (1) populate arrays
                if let arrJSON = JSON["items"] as? NSArray {
                    
                    images = [UIImage]()
                    imageNames = [String]()
                    prices = [Double]()
                    names = [String]()
                    servings = [Int]()
                    addresses = [Address]()
                    addressStrings =  [String]()
                    times = [Double]()
                    userids = [String]()
                    
                    if(arrJSON.count != 0) {
                        for item in (arrJSON as? [[String:Any]])!{
                            prices.append(item["price"] as! Double)
                            names.append(item["description"] as! String)
                            imageNames.append(item["photo"] as! String)
                            servings.append(item["servings"] as! Int)
                            addressStrings.append(item["address"] as! String)
                            userids.append(item["userid"] as! String)

//                            let address = Address(input: item["address"] as! String)
//                            var addressString = ""
//                            addresses.append(address)

//                            let geoCoder = CLGeocoder()
//                            let location = CLLocation(latitude: Double(address.latitude)!, longitude: Double(address.longitude)!)
//                            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//                                // Place details
//                                var placeMark: CLPlacemark!
//                                placeMark = placemarks?[0]
//                                
//                                // Location name
//                                if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
//                                    addressString = addressString + (locationName as String) + ", "
//                                }
//                                // City
//                                if let city = placeMark.addressDictionary!["City"] as? NSString {
//                                    addressString = addressString + (city as String) + ", "
//                                }
//                                // State
//                                if let state = placeMark.addressDictionary!["State"] as? NSString {
//                                    addressString = addressString + (state as String) + " "
//                                }
//                                // Zip code
//                                if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
//                                    addressString = addressString + (zip as String)
//                                }
//                                //                cell?.address.text = addressString
//                                print(addressString)
//                                addressStrings.append(addressString)
//                            })
                            
                            let epochTime = item["end"] as! Double
                            times.append(epochTime)
                        }
                    }
                    else {
                        self.tableView.reloadData()
                        self.noFoodLabel.isHidden = false
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.isHidden = true
                    }
                }
                
                images = Array(repeating: UIImage(), count: imageNames.count)
            }
            
            self.refreshControl.endRefreshing()
            
            for (i, imageName) in imageNames.enumerated() {
                self.downloadImage(url: URL(string: server + "/" + imageName)!, position: i)
            }
        }
    )}
    
    @IBAction func switchViews(_ sender: Any) {
        let sellViewController = self.storyboard!.instantiateViewController(withIdentifier: "sellNav") as UIViewController
        sellViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present(sellViewController, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("table count", images.count)
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BuyPageCell
        
        cell?.photo.contentMode = UIViewContentMode.scaleAspectFill
        cell?.photo.clipsToBounds = true;
        cell?.photo.layer.cornerRadius = 10;
        
        cell?.photo.image = images[indexPath.row]
        cell?.name.text = names[indexPath.row]
        cell?.price.text = "$" + String(prices[indexPath.row])
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        
        let buyConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "buyConfirmationPage") as! BuyConfirmationViewController
        
        
        // Creates Popover View
        let nav = UINavigationController(rootViewController: buyConfirmVC)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        nav.navigationBar.isHidden = true
        let popover = nav.popoverPresentationController
        popover?.sourceView = self.view
        
        self.present(nav, animated: true, completion: nil)

    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.noFoodLabel.isHidden = true
        self.tableView.reloadData()
        
        downloaded = 0;
        getData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloaded = 0;
        noFoodLabel.isHidden = true
        loadingIndicator.startAnimating()
        getData()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Finding new foods")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}




    
