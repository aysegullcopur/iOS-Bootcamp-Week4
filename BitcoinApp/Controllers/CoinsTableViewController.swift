//
//  ViewController.swift
//  BitcoinApp
//
//  Created by Aysegul COPUR on 7.06.2022.
//

import UIKit
import Kingfisher

class CoinsTableViewController: UIViewController {
    
    @IBOutlet private weak var coinsTableView: CoinsTableView!
    private lazy var coinsTableModel = CoinTableModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinsTableView.tableView.dataSource = self
        coinsTableView.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coinsTableModel.fetchCurrencies(completion: { currencies, error in
            DispatchQueue.main.async {
                self.coinsTableView.tableView.reloadData()
            }
        })
    }

}

extension CoinsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinsTableModel.filteredCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as! CoinsTableViewCell
        let data = coinsTableModel.filteredCurrencies[indexPath.row]
        let priceText = String(format: "%.2f", data.price)
        let percentageText = String(format: "%.2f", data.priceChangePercentage)
        cell.coinImageView.kf.setImage(with: URL(string: data.imageUrlString))
        cell.coinIdLabel.text = data.id.uppercased()
        cell.coinNameLabel.text = data.name
        cell.priceLabel.text = "$\(priceText)"
        cell.pricePercentageLabel.text = "\(percentageText)%"
        cell.pricePercentageView.backgroundColor = data.priceChangePercentage < 0 ? .red : .green
        return cell
    }
    
}

extension CoinsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        coinsTableModel.updateSearchText(searchText)
        coinsTableView.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        coinsTableView.searchBar.endEditing(false)
    }
    
}


