//
//  ViewController.swift
//  CryptoCurrency
//
//  Created by BinhPQ on 10/25/18.
//  Copyright © 2018 BinhPQ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import JGProgressHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //outlets
    @IBOutlet weak var currencyTableView: UITableView!
    
    //var
    var coinList = [Currency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        customizeUI()
        getCoinListAPI()
    }

    
    func customizeUI()
    {
        self.currencyTableView.delegate = self
        self.currencyTableView.dataSource = self
        self.currencyTableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "currencyCell")
    }
    
    //get data
    func getCoinListAPI(){
        let URL = "api/data/coinlist"
        let coinslistURL = baseURL + URL
        Alamofire.request(coinslistURL, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON {
            (response) in
            
            switch response.result{
            case .success(let value):
                self.handleGetListCoinSuccess(value: value)
            case .failure(let error):
                self.handGetListCoinFailure(error: error)
            }
            self.currencyTableView.reloadData()
        }
    }
    
    func handleGetListCoinSuccess(value: Any){
        let json = JSON(value)
        if let dataDictionary = json["Data"].dictionary {
            for key in dataDictionary.keys
            {
                if let coinJson = dataDictionary[key]{
                    var coin = Currency()
                    coin.image = coinJson["ImageUrl"].string
                    coin.name = coinJson["Name"].string
                    self.coinList.append(coin)
                }
            }
            
        }
    }
    
    func handGetListCoinFailure(error: Error){
        
    }
    //animation loading
    func showLoadingStatus(){
        let hud = JGProgressHUD(style: .extraLight)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3.0)
    }
    //table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyTableViewCell
        //cell.imageCurrency.sd_setImage(with: URL(string: (coinList[indexPath.row].getImageURL())), completed: nil)
        cell.imageCurrency.sd_setImage(with: URL(string: coinList[indexPath.row].getImageURL()), placeholderImage: nil, options: .refreshCached, completed: { [weak self] (image, error, cacheType, imageURL) in
            if error != nil {print(error!)}
        })
        cell.nameCurrency.text = coinList[indexPath.row].name
        
        DispatchQueue.main.async {
            self.showLoadingStatus()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let priceView = sb.instantiateViewController(withIdentifier: "detailPrice") as! DetailCurrencyViewController
        priceView.coinName = coinList[indexPath.row].name!
        priceView.coindetailImageURL = coinList[indexPath.row].getImageURL()
        self.navigationController?.pushViewController(priceView, animated: true)
    }

}

