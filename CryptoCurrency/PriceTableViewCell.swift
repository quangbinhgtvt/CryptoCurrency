//
//  PriceTableViewCell.swift
//  CryptoCurrency
//
//  Created by BinhPQ on 10/26/18.
//  Copyright © 2018 BinhPQ. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

    @IBOutlet weak var coinNameLbl: UILabel!
    @IBOutlet weak var coinPriceUSDLbl: UILabel!    
    @IBOutlet weak var coinPriceEURLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
