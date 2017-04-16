//
//  BuyPageCell.swift
//  Food4Friends
//
//  Created by Vaish Raman on 4/4/17.
//  Copyright © 2017 Vaish Raman. All rights reserved.
//

import UIKit

class BuyPageCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
