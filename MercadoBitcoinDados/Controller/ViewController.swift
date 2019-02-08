//
//  ViewController.swift
//  MercadoBitcoinDados
//
//  Created by Jefferson Martins  on 04/02/19.
//  Copyright © 2019 Jefferson Martins. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var labelLast: UILabel!
    @IBOutlet weak var labelLow: UILabel!
    @IBOutlet weak var labelHigh: UILabel!
    @IBOutlet weak var pickerViewCoin: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let defaults = UserDefaults.standard
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareRefreshControl()
        
        preparePickerView()
    }
    
    func preparePickerView() {
        pickerViewCoin.delegate = self
        pickerViewCoin.dataSource = self
        
        if let coin = defaults.string(forKey: "coinSelected") {
            loadBitcoinTicker(coin: coin)
            pickerViewCoin.selectRow(Bitcoin.coins.firstIndex(of: coin)!, inComponent: 0, animated: true)
        } else {
            loadBitcoinTicker(coin: "BTC")
        }
    }
    
    func prepareRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Puxe para atualizar")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        self.scrollView.refreshControl = refreshControl
    }
    
    @objc func refresh(sender:AnyObject) {
        self.loadBitcoinTicker(coin: Bitcoin.coins[pickerViewCoin.selectedRow(inComponent: 0)])
        self.refreshControl.endRefreshing()
    }

    
    //
    //
    //    //MARK: - Load bitcoin data
    //    /***************************************************************/
    //
    public func loadBitcoinTicker(coin: String) {
        let url = Bitcoin.URL_API_MERCADO_BITCOIN + coin + "/ticker"
        
        defaults.setValue(coin, forKey: "coinSelected")
        
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let bitcoin : JSON = JSON(response.result.value!)
                
                if let ticker = bitcoin.dictionaryValue["ticker"] {
                    self.updateBitcoinTicker(json: ticker)
                }
                
                
            } else {
                print("erro")
            }
        }
    }
    
    func updateBitcoinTicker(json: JSON) {
        
        if let last = json.dictionaryValue["last"]?.doubleValue {
            _ = TickerAnimateLabel.init(withLabel: self.labelLast, andValueTicker: last)
            
        }
        
        if let low = json.dictionaryValue["low"]?.doubleValue {
            _ = TickerAnimateLabel.init(withLabel: self.labelLow, andValueTicker: low)
        }
        
        if let high = json.dictionaryValue["high"]?.doubleValue {
            _ = TickerAnimateLabel.init(withLabel: self.labelHigh, andValueTicker: high)
        }

    }

}

//
//
//    //MARK: - Extension UIViewController
//    /***************************************************************/
//
extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Bitcoin.coins.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Bitcoin.coins[row] + " - " + Bitcoin.coinsNames[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.loadBitcoinTicker(coin: Bitcoin.coins[row])
    }
    
}

