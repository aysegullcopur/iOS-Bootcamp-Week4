//
//  CoinTableModel.swift
//  BitcoinApp
//
//  Created by Aysegul COPUR on 13.06.2022.
//

import Foundation

class CoinTableModel {
    
    private let urlSession = URLSession(configuration: .default)
    private let fecthCurrenciesURL = URL(
        string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc"
    )!
    
    lazy var currencies: [CryptoCurrencyInfo] = []
    lazy var filteredCurrencies: [CryptoCurrencyInfo] = []
    private lazy var searchText = ""
    
    func fetchCurrencies(completion: @escaping ([CryptoCurrencyInfo]?, Error?) -> Void) {
        //Give the session a task.
        let task = urlSession.dataTask(
            with: fecthCurrenciesURL,
            completionHandler: { data, response, error in
                guard let data = data else {
                    completion(nil, error ?? NSError())
                    return
                }
           
                let currencies = (try? JSONDecoder().decode([CryptoCurrencyInfo].self, from: data)) ?? []
                self.currencies = currencies
                self.updateSearchText(self.searchText)
                completion(currencies, nil)
            }
        )
        //Start the task.
        task.resume()
    }
    
    func updateSearchText(_ searchText: String) {
        self.searchText = searchText
        if searchText.isEmpty {
            filteredCurrencies = currencies
        }
        else {
            filteredCurrencies =  currencies.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        }
    }
    
}

struct CryptoCurrencyInfo: Decodable {
    let imageUrlString: String
    let id: String
    let name: String
    let price: Double
    let priceChangePercentage: Double
    
    enum CodingKeys: String, CodingKey {
        case imageUrlString = "image"
        case id = "symbol"
        case name = "name"
        case price = "current_price"
        case priceChangePercentage = "price_change_percentage_24h"
    }
}
