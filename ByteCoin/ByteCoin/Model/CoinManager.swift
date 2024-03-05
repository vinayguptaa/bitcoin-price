//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateData(_ coinManager : CoinManager, coinData : CoinData)
    func didFailWithError(_ coinManager : CoinManager, error: Error)
    func didStartFetching(_ coinManager : CoinManager)
}

struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "AEF0498C-8880-419D-AE92-E50AEBE5374C"
    
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func fetchData(for currency : String) {
        let urlString = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
        
        delegate?.didStartFetching(self)
        performRequest(with : urlString)
    }
    
    func performRequest(with urlString : String) {
        //1) Create the URL
        if let url = URL(string: urlString) {
            
            //2) Create URL Session
            let session = URLSession(configuration: .default)
            
            //3) Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(self , error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coinData = self.parseJSON(safeData) {
                        delegate?.didUpdateData(self, coinData: coinData)
                    }
                }
            } // trailing closure
            
            //4) Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data : Data) -> CoinData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData
        } catch {
            delegate?.didFailWithError(self , error: error)
            return nil
        }
    }
}
