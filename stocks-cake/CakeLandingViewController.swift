//
//  CakeLandingViewController.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 17/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit
import SocketIO

class CakeLandingViewController: UIViewController {
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    var csvData = [[Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSockets()
    }
    
    private func parse(data: String) {
        var rowData = [Any]()
        
        
        
        
        
        let rows = data.components(separatedBy: ",")
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
            
            if let data = data as? [Any] {
                if let firstData = data.first as? String {
                    self.parse(data: firstData)
                }
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

