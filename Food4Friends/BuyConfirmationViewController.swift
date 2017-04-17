//
//  BuyConfirmationViewController.swift
//  Food4Friends
//
//  Created by Vaish Raman on 4/4/17.
//  Copyright © 2017 Vaish Raman. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class BuyConfirmationViewController: UIViewController {
    
    

    @IBAction func purchaseItem(_ sender: Any) {
            let sellerid = userids[selectedIndexPath]
            let buyerid = userid
            let parameters: Parameters = [
                "sellerid": String(sellerid)!,
                "buyerid": String(buyerid)!,
                "servings": self.servingsLabel.text! as String,
            ]
        print(parameters)
        
        Alamofire.request(server + "/api/v1/buy/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type" : "application/json"]).responseString(completionHandler: {response in
            
            
            servingsPurchased = Int(self.servingsLabel.text!)!
            
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "buyCart") as UIViewController
            self.navigationController?.pushViewController(viewController, animated: true)
            
            debugPrint(response)
            
            // move to buy cart page
            
        })
        
        
    }
    
    @IBOutlet weak var timeLeftDisplay: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var servingStepperObj: UIStepper!
    @IBOutlet weak var maxServingsWarning: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var serveringsQuestion: UITextView!
    
    var pricePerItem: Double = 0.0
    
    @IBAction func servingStepper(_ sender: UIStepper) {
        totalPrice.text = "Price: $" + String(sender.value * pricePerItem)
        servingsLabel.text = String(Int(sender.value))
        
        if (sender.value == servingStepperObj.maximumValue)
        {
            maxServingsWarning.textColor = UIColor.gray
            maxServingsWarning.isHidden = false
        }
        else {
            maxServingsWarning.isHidden = true
        }
    }
    
    @IBAction func cancelItem(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func dismissPopup() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        address.text = addressStrings[selectedIndexPath]
        address.numberOfLines = 2
        
        let epochTime = times[selectedIndexPath]
        print("EPOACH TIME ", epochTime)
        let currentEpoch = NSDate().timeIntervalSince1970
        let diffEpoch = Double(epochTime) - Double(currentEpoch)
        let time = NSDate(timeIntervalSince1970: Double(diffEpoch))
        var timeLeft = String(describing: time)
        let timeArr = timeLeft.characters.split(separator: " ")
        let timeToDisplay = String(timeArr[1])
        timeLeftDisplay.text = timeToDisplay
    
        selectedImage.image = images[selectedIndexPath]
        
        serveringsQuestion.text = "How many servings of " + names[selectedIndexPath] + " would you like?"
        
        //GET FROM API
        let maxServings = servings[selectedIndexPath]
        pricePerItem = prices[selectedIndexPath]
        
        totalPrice.text = "Price: $" +  String(pricePerItem)
        
        // Max Stepper Value 
        servingStepperObj.maximumValue = Double(maxServings)
        servingStepperObj.minimumValue = 1

        maxServingsWarning.isHidden = true
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(BuyConfirmationViewController.dismissPopup))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)

        // Do any additional setup after loading the view.
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
