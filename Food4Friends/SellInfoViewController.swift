//
//  SellInfoViewController.swift
//  Food4Friends
//
//  Created by Amy Chern on 4/16/17.
//  Copyright © 2017 Vaish Raman. All rights reserved.
//

import UIKit
import Alamofire

var numOfServingsSelling: String = ""
var timeRemainingPosted: String = ""
class SellInfoViewController: UIViewController {

    @IBOutlet weak var durationMin: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var servings: UITextField!
    @IBOutlet weak var foodPic: UIImageView!
    @IBOutlet weak var itemDescription: UITextField!
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var frameRect = CGRect()
        frameRect = itemDescription.frame
        frameRect.size.height = 120 // <-- Specify the height you want here.
        itemDescription.frame = frameRect
        
        var frameRect2 = CGRect()
        frameRect2 = durationMin.frame
        frameRect2.size.height = 90
        durationMin.frame = frameRect2
        
        var frameRect3 = CGRect()
        frameRect3 = address.frame
        frameRect3.size.height = 90
        address.frame = frameRect3
        
        var frameRect4 = CGRect()
        frameRect4 = price.frame
        frameRect4.size.height = 90
        price.frame = frameRect4
        
        var frameRect5 = CGRect()
        frameRect5 = servings.frame
        frameRect5.size.height = 90
        servings.frame = frameRect5
        
        foodPic.image = Singleton.sharedInstance.imageValue
        foodPic.contentMode = UIViewContentMode.scaleAspectFill
        foodPic.clipsToBounds = true
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }

    @IBAction func sellFood(_ sender: Any) {
        let multipartformdata = MultipartFormData()
        
        
//        if ((durationMin.text?.isEmpty)! && (address.text?.isEmpty)! && (price.text?.isEmpty)! && (servings.text?.isEmpty)! && (itemDescription.text?.isEmpty)!) {
//            let alertController = UIAlertController(title: "Incomplete Form", message:
//                "All fields are required", preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
//            
//            self.present(alertController, animated: true, completion: nil)
//        }
//        
        
        
        let postDict = ["userid": userid, "servings": servings.text!, "duration": durationMin.text!, "price": price.text!, "address": address.text!, "description": itemDescription.text!] as [String: String]
        //numOfServingsSelling = servings.text!
        //timeRemainingPosted = durationMin.text!
        
        
        do {
            let sell_url = try URLRequest(url: server + "/api/v1/sell/", method: .post, headers: ["Content-Type" : multipartformdata.contentType])
            
            let imageData = UIImagePNGRepresentation(foodPic.image!)!
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData, withName: "photo", fileName: "file.png", mimeType: "image/png")
                
                for (key, value) in postDict {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, with: sell_url) { (result) in
                switch result {
                case .success(let upload, _, _):
                    var secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "sellCartView") as! UIViewController!
                    self.navigationController?.pushViewController(secondViewController!, animated: true)
                    print(upload)
                case .failure( _):
                    print("no")
                }
            }
            
            
        }
        catch {
            print("error occured")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
