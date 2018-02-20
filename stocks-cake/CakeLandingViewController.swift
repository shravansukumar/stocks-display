//
//  CakeLandingViewController.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 17/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit
import SocketIO

extension UIView{
    func blink() {
        self.alpha = 0.2
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
}

class CakeLandingViewController: UIViewController {
    
    @IBOutlet var testLabel: UILabel!
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    var csvData = [[Any]]()
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // setupSockets()
        fetchData()
    }
    
    
    private func fetchData() {
        networkManager.request() {
            success, result in
            if success {
                print(result)
            }
        }
    }
    
    private func parse(_ data: String) {
        let rows = data.components(separatedBy: ",")
        testLabel.text = ""
        
        testLabel.blink()
        testLabel.text = rows[3]
        
        csvData.append(rows)
        print(csvData)
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
            
            
            ack.with(1)
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


         //   self.socket.emit("ping", [])
            self.socket.emit("sub", ["state" : true])

        })
        socket.connect()
        
    }
    
}

