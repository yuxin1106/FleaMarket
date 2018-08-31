//
//  ItemTVC.swift
//  FleaMarket
//
//  Created by Xin Yu on 11/13/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//

import UIKit

class ItemTVC: UITableViewCell {
    
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
