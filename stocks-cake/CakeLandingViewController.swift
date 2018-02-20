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
    
    @IBOutlet var tableView: UITableView!
    
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    var stockItems = [StockItem]()
    var liveData: String?
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSockets()
        fetchData()
        setupTableView()
       // setDataCount()
    }
    
    
    
    private func setupTableView() {
        tableView.registerNib(viewClass: CakeLiveStocksTableViewCell.self)
        tableView.registerNib(viewClass: CakeHistoricalTableViewCell.self)
        tableView.tableFooterView = UIView()
        
    }
    

    
    private func fetchData() {
        networkManager.request() {
            success, result in
            if success {
           //     print(result)
                self.map(result!)
                
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

    
    
    private func setupSockets() {
        manager = SocketManager(socketURL: URL(string: "http://kaboom.rksv.net/")!, config: [.log(true), .compress])
        
        socket = manager.socket(forNamespace: "/watch")
        
        socket.onAny {print("Got event: \($0.event), with items: \(String(describing: $0.items))")}
        
        socket.on("data", callback: { (data, ack) in
            print(data)
            print(ack)
            
            if let firstData = data.first as? String {
                self.parse(firstData)
            }
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0) {
                ack.with(1)
            }
        })
        

        socket.on("error", callback: { (data, ack) in
            print(data)
            print(ack)
            
        })
        
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print(data)
            print(ack)
            
        }
        
        socket.on("connect", callback: { (data, ack) in
            print(data)
            print(ack)

            self.socket.emit("sub", ["state" : true])

        })
        socket.connect()
    }
}

extension CakeLandingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
        let stocksCell = tableView.dequeueReusableCell(tableViewCellClass: CakeLiveStocksTableViewCell.self)
        if let data = liveData {
            stocksCell.liveStocksLabel.text = data
        }
        return stocksCell
            
        default:
            let graphCell = tableView.dequeueReusableCell(tableViewCellClass: CakeHistoricalTableViewCell.self)
            if stockItems.count > 0 {
                graphCell.drawGraph(for: stockItems)
            }
            return graphCell
        }
    }
}

