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
    var manager: SocketManager!
    var socket: SocketIOClient!
    var stockItems = [StockItem]()
    var liveData: String?
    let networkManager = NetworkManager()

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
       tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
}

// MARK: - LiveDataAvailable
extension CakeLandingViewController: LiveDataAvailable {
    func stock(data: String) {
        parse(data)
    }
}

