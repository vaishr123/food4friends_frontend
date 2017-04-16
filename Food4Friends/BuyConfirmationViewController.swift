//
//  BuyConfirmationViewController.swift
//  Food4Friends
//
//  Created by Vaish Raman on 4/4/17.
//  Copyright © 2017 Vaish Raman. All rights reserved.
//

import UIKit
import MapKit

class BuyConfirmationViewController: UIViewController {

    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var servingStepperObj: UIStepper!
    @IBOutlet weak var maxServingsWarning: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
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
        
        //GET FROM API
        let maxServings = 13
        pricePerItem = 3
        
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
