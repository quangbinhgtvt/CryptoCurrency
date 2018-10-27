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
import MBProgressHUD

class DetailCurrencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //outlets
    
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var priceTableView: UITableView!
    @IBOutlet weak var valueExchangeTextField: UITextField!
    @IBOutlet weak var finalValueExchangeTextField: UILabel!
    @IBOutlet weak var value2ExchangeTextField: UILabel!
    
    //variable
    var coinName: String = ""
    var coinPrices = [String : Double]()
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
        self.coinImage.sd_setImage(with: URL(string: coindetailImageURL), placeholderImage: nil, options: .refreshCached, completed: { [weak self] (image, error, cacheType, imageURL) in
            if error != nil {print(error!)}
        })
    }
    
    // get price
    func getPricesAPI(){
        
        let parameters: Parameters = [
            "fsym" : coinName,
            "tsyms": "EUR,USD"
        ]
        MBProgressHUD.showAdded(to: self.view, animated: true)
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
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        self.priceTableView.reloadData()
    }
    
    func handGetPriceFailure(error: Error)
    {
           MBProgressHUD.hide(for: self.view, animated: true)
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    //actions
    @IBAction func clickCoinButton(_ sender: Any) {
        
        if let numberofcoin = Double(valueExchangeTextField.text!){
            if let usd = coinPrices["USD"]{
                 finalValueExchangeTextField.text = "Your coin property is equal to: \(numberofcoin * usd) USD"
            }
            if let eur = coinPrices["EUR"]{
                value2ExchangeTextField.text = "Your coin property is equal to: \(numberofcoin * eur) USD"
            }
        }
        else
        {
            showAlert(tit: "Invalid coin number", msg: "Enter a valid number of coin")
        }
    }
    
    @IBAction func clickUSDButton(_ sender: Any) {
        if let numberofUSD = Double(valueExchangeTextField.text!){
            
            if let usd = coinPrices["USD"]{
                let value = String(format: "%.2f", numberofUSD / usd)
                finalValueExchangeTextField.text = "You can exchange to: \(value) coin"
                if let eur = coinPrices["EUR"]{
                    let eurvalue = String(format: "%.2f", numberofUSD / usd * eur)
                    value2ExchangeTextField.text = "You can exchange to: \(eurvalue) EUR"
                }
            }
        }
        else {
            showAlert(tit: "Invalid number USD", msg: "Enter a valid number of USD")
        }
    }
    
    @IBAction func clickEURButton(_ sender: Any) {
    }
    //alert action show
    
    func showAlert(tit:String, msg:String){
        let alert = UIAlertController(title: tit, message: msg, preferredStyle: UIAlertController.Style.alert)
        let actionOk = UIAlertAction(title: tit, style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) in print("ok")})
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
}
