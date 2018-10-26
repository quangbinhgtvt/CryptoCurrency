//
//  Currency.swift
//  CryptoCurrency
//
//  Created by BinhPQ on 10/25/18.
//  Copyright © 2018 BinhPQ. All rights reserved.
//

import Foundation

struct Currency {
    var image: String?
    var name: String?
    var baseImageURL: String?
    var coinPrices = [String : String]()
    
    func getImageURL() -> String{
        return baseURL + image!
    }
}
