//
//  BuyPageViewController.swift
//  Food4Friends
//
//  Created by Vaish Raman on 4/4/17.
//  Copyright © 2017 Vaish Raman. All rights reserved.
//

import UIKit

var images = [#imageLiteral(resourceName: "pizza"), #imageLiteral(resourceName: "enchilada"), #imageLiteral(resourceName: "salad")]
var prices = [4, 8, 5]
var names = ["Truffle Pizza", "Beef Enchilada", "Vegetarian Salad"]

class BuyPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBAction func switchViews(_ sender: Any) {
        let sellViewController = self.storyboard!.instantiateViewController(withIdentifier: "sellNav") as UIViewController
        sellViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present(sellViewController, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BuyPageCell
        
        cell?.photo.image = images[indexPath.row]
        cell?.name.text = names[indexPath.row]
        cell?.price.text = "$" + String(prices[indexPath.row])
        
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        let likeAction = UIPreviewAction(title: "Like", style: .default) { (action, viewController) -> Void in
            print("You liked the photo")
        }

        let deleteAction = UIPreviewAction(title: "Delete", style: .destructive) { (action, viewController) -> Void in
            print("You deleted the photo")
        }
        
        return [likeAction, deleteAction]
    }
    
}




    
