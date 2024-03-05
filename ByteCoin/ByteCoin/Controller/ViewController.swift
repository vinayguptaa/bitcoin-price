//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        
        currencyLabel.text = coinManager.currencyArray[0]
        coinManager.fetchData(for: coinManager.currencyArray[0])
    }
}

//MARK: - UIPickerViewDataSource

extension ViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        currencyLabel.text = selectedCurrency
        
        coinManager.fetchData(for: selectedCurrency)
    }
}

//MARK: - CoinManagerDelegate

extension ViewController : CoinManagerDelegate {
    func didStartFetching(_ coinManager: CoinManager) {
        valueLabel.textColor = UIColor.systemGray
        valueLabel.text = "Fetching..."
    }
    
    func didUpdateData(_ coinManager: CoinManager, coinData: CoinData) {
        DispatchQueue.main.async {
            self.valueLabel.textColor = UIColor.white
            self.valueLabel.text = String(format: "%.2f", coinData.rate)
        }
    }
    
    func didFailWithError(_ coinManager: CoinManager, error: Error) {
        DispatchQueue.main.async {
            self.valueLabel.text = "Failed"
        }
        print("ERROR 🤯 : ",error)
    }
}
