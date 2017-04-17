//
//  SellCartTableViewCell.swift
//  Food4Friends
//
//  Created by Amy Chern on 4/16/17.
//  Copyright © 2017 Vaish Raman. All rights reserved.
//

import UIKit

class SellCartTableViewCell: UITableViewCell {

    @IBOutlet weak var buyerServings: UILabel!
    @IBOutlet weak var buyerName: UILabel!
    @IBOutlet weak var buyerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
