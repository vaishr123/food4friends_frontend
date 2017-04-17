//
//  SellViewController.swift
//  Food4Friends
//
//  Created by Vaish Raman on 4/16/17.
//  Copyright © 2017 Vaish Raman. All rights reserved.
//

import UIKit

class Singleton {
    static let sharedInstance = Singleton()
    var imageValue : UIImage?
}

class SellViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var foodImage: UIImageView! = nil
    
    @IBOutlet weak var noImageSelected: UILabel!
    @IBAction func switchModes(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func openCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true,
                     completion: nil)
        
    }
    
    @IBAction func openPhotoLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true,
                         completion: nil)
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        noImageSelected.isHidden = false
        foodImage.image = Singleton.sharedInstance.imageValue
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (saleJustFinished) {
            noImageSelected.isHidden = false
            foodImage.image = Singleton.sharedInstance.imageValue
            saleJustFinished = false
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        foodImage.image = image
        Singleton.sharedInstance.imageValue = image
        self.dismiss(animated: true, completion: nil)
        noImageSelected.isHidden = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        noImageSelected.isHidden = false
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
