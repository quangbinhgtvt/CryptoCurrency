//
//  CurrencyTableViewCell.swift
//  CryptoCurrency
//
//  Created by BinhPQ on 10/25/18.
//  Copyright © 2018 BinhPQ. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageCurrency: UIImageView!    
    @IBOutlet weak var nameCurrency: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
