//
//  CakeLandingViewController.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 17/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit
import SocketIO
import Charts

class CakeLandingViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Constants and variables
    var stockItems = [StockItem]()
    var liveData: String?
    let networkManager = NetworkManager()
    var mappedItem : StockItem?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        SocketIOManager.shared.delegate = self
        fetchData()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.registerNib(viewClass: CakeLiveStocksTableViewCell.self)
        tableView.registerNib(viewClass: CakeHistoricalTableViewCell.self)
        tableView.registerNib(viewClass: CakeSelectTimelineTableViewCell.self)
        tableView.registerNib(viewClass: CakeStockDataTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    private func fetchData() {
        networkManager.request() {
            success, result in
            if success {
                self.map(result!)
            } else {
                debugPrint("Not able to fetch values")
            }
        }
    }
    
    private func map(_ data: [Any]) {
        for stockData in data {
            if let stockValues = (stockData as? String)?.components(separatedBy: ",") {
                let date = Date(timeIntervalSince1970: Double(stockValues[0])!)
                let item = StockItem(timeStamp: date, open: Double(stockValues[1]) ?? 0, high: Double(stockValues[2]) ?? 0, low: Double(stockValues[3]) ?? 0, close: Double(stockValues[4]) ?? 0, volume: Double(stockValues[5]) ?? 0)
                stockItems.append(item)
            } else {
                print("error in parsing data")
            }
        }
        stockItems.sort { $0.timeStamp < $1.timeStamp }
        mappedItem = getStockHighlights(data: stockItems)
        tableView.reloadData()
    }

    /*
     A method for creating an intermediate object, to map all the values
     open: Contains the opening price
     high: contains the maximum stock price
     low: minimum value
     close: closing value
     volume: total stock volume
     */
    private func getStockHighlights(data : [StockItem]) -> StockItem {
        return  data.reduce(data.first!) { (result, nextStockItem) -> StockItem in
            let minimum =  min(result.low, nextStockItem.low)
            let maximum = max(result.high, nextStockItem.high)
            let open = data.first!.open
            let close = data.last!.close
            let totalVolume = result.volume + nextStockItem.volume
            return StockItem(timeStamp: Date(), open: open!, high: maximum, low: minimum, close: close!, volume: totalVolume)
        }
    }
    
    private func parse(_ data: String) {
        let rows = data.components(separatedBy: ",")
        liveData = rows[2]
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        
    }
}

// MARK: - UITableViewDataSource
extension CakeLandingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let stocksCell = tableView.dequeueReusableCell(tableViewCellClass: CakeLiveStocksTableViewCell.self)
                if let data = liveData {
                    stocksCell.liveStocksLabel.text = "$ " + data
                }
                return stocksCell
                
                
            case 1:
                let graphCell = tableView.dequeueReusableCell(tableViewCellClass: CakeHistoricalTableViewCell.self)
                if stockItems.count > 0 {
                    graphCell.drawGraph(for: stockItems)
                }
                return graphCell
                
            default:
                let timeLineCell = tableView.dequeueReusableCell(tableViewCellClass: CakeSelectTimelineTableViewCell.self)
                timeLineCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, UIScreen.main.bounds.width)
                return timeLineCell
            }
        } else {
            let dataCell = tableView.dequeueReusableCell(tableViewCellClass: CakeStockDataTableViewCell.self)
            switch indexPath.row {
            case 0:
                dataCell.leftCommonView.typeLabel.text = "Day High"
                dataCell.leftCommonView.valueLabel.text = String(mappedItem?.high ?? 0)
                dataCell.rightCommonView.typeLabel.text = "Day Low"
                dataCell.rightCommonView.valueLabel.text = String(mappedItem?.low ?? 0)
                
            case 1:
                dataCell.leftCommonView.typeLabel.text = "Open value"
                dataCell.leftCommonView.valueLabel.text = String(mappedItem?.open ?? 0)
                dataCell.rightCommonView.typeLabel.text = "Close value"
                dataCell.rightCommonView.valueLabel.text = String(mappedItem?.close ?? 0)
                
            default:
                dataCell.leftCommonView.typeLabel.text = "Volume"
                dataCell.leftCommonView.valueLabel.text = String(mappedItem?.volume ?? 0)
                dataCell.rightCommonView.typeLabel.text = "Avg Volume"
                dataCell.rightCommonView.valueLabel.text = String((mappedItem?.volume) ?? 0 / Double(stockItems.count))
            }
            return dataCell
        }
    }
}

// MARK: - LiveDataAvailable
extension CakeLandingViewController: LiveDataAvailable {
    func stock(data: String) {
        parse(data)
    }
}

