//
//  DetailCurrencyViewController.swift
//  CryptoCurrency
//
//  Created by BinhPQ on 10/26/18.
//  Copyright © 2018 BinhPQ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import JGProgressHUD

class DetailCurrencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var priceTableView: UITableView!
    var coinName: String = ""
    var coinPrices = [String : Double]()
    @IBOutlet weak var coinImage: UIImageView!
    var coindetailImageURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizePriceView()
        getPricesAPI()
        print(coinName)
    }
    
    func customizePriceView(){
        self.priceTableView.delegate = self
        self.priceTableView.dataSource = self
        self.priceTableView.register(UINib(nibName: "PriceTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "priceCell")
        //show image of the coin
       
       
    }
    
    // get price
    func getPricesAPI(){
        
        let parameters: Parameters = [
            "fsym" : coinName,
            "tsyms": "EUR,USD"
        ]
        Alamofire.request(baseCoinPrice, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result{
            case .success(let value):
                self.handleGetPriceSuccess(value: value)
            case .failure(let error):
                self.handGetPriceFailure(error: error)
            }
         
        }
        
    }
    
    func handleGetPriceSuccess(value: Any){
        
        let json = JSON(value)
        if let priceUSD = json["USD"].double{
            coinPrices["USD"] = priceUSD
        }
        if let priceEUR = json["EUR"].double {
            coinPrices["EUR"] = priceEUR
        }
        print (json)
        self.priceTableView.reloadData()
    }
    
    func handGetPriceFailure(error: Error)
    {
            print(error)
    }
    
    //show loading animation
    func showLoadingStatus(){
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3.0)
    }
    
    // tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath) as! PriceTableViewCell
        cell.coinNameLbl.text = "Value for 1 \(coinName) is:"
        if let eur = coinPrices["EUR"]{
            cell.coinPriceEURLbl.text = "EUR: \(eur)"
        }
        else {
            cell.coinPriceEURLbl.text = " EUR: No Data"
        }
        
        if let usd = coinPrices["USD"]{
            cell.coinPriceUSDLbl.text = "USD: \(usd)"
        }
        else {
            cell.coinPriceUSDLbl.text = " USD: No Data"
        }
        
        DispatchQueue.main.async {
             self.showLoadingStatus()
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
