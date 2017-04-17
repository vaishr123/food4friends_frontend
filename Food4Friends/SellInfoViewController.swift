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
var sellingItem: String = ""

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
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize.init(width: CGFloat.init(size.width * heightRatio), height: CGFloat.init(size.height * heightRatio))
        } else {
            newSize = CGSize.init(width: CGFloat.init(size.width * widthRatio),  height: CGFloat.init(size.height * widthRatio))
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect.init(x: CGFloat.init(0), y: CGFloat.init(0),width: CGFloat.init(newSize.width), height: CGFloat.init(newSize.height))
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    @IBAction func sellFood(_ sender: Any) {
        let multipartformdata = MultipartFormData()
        
        var smallImage = resizeImage(image: Singleton.sharedInstance.imageValue!, targetSize: CGSize(width: 300, height: 450))
        if ((durationMin.text?.isEmpty)! && (address.text?.isEmpty)! && (price.text?.isEmpty)! && (servings.text?.isEmpty)! && (itemDescription.text?.isEmpty)!) {
            let alertController = UIAlertController(title: "Incomplete Form", message:
                "All fields are required", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        let postDict = ["userid": userid, "servings": servings.text!, "duration": durationMin.text!, "price": price.text!, "address": address.text!, "description": itemDescription.text!] as [String: String]
        do {
            let sell_url = try URLRequest(url: server + "/api/v1/sell/", method: .post, headers: ["Content-Type" : multipartformdata.contentType])
            
            let imageData = UIImagePNGRepresentation(smallImage)!
            let filename = String(NSDate().timeIntervalSince1970).trimmingCharacters(in: .punctuationCharacters)
            var splitFile = filename.substring(to: filename.range(of: ".")?.lowerBound ?? filename.endIndex)
            splitFile = splitFile + ".png"
            print("FILENAME: " + splitFile)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData, withName: "photo", fileName: splitFile, mimeType: "image/png")
                
                for (key, value) in postDict {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, with: sell_url) { response in
                debugPrint(response)
                switch response {
                case .success(let upload, _, _):
                    numOfServingsSelling = self.servings.text!
                    timeRemainingPosted = self.durationMin.text!
                    sellingItem = self.itemDescription.text!
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "sellCart") as UIViewController
                    self.present(viewController, animated: true, completion: nil)
                    
                    print(upload)
                case .failure( _):
                    print("no")
                    let alertController = UIAlertController(title: "Invalid input", message:
                        "Please make sure all input fields have valid formatting", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
                    self.present(alertController, animated: true, completion: nil)
                    
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
