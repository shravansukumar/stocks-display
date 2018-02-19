//
//  ViewController.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 17/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {
    
    var manager: SocketManager!
    var socket: SocketIOClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSockets()
    }
    
    private func setupSockets() {
        manager = SocketManager(socketURL: URL(string: "http://kaboom.rksv.net/")!, config: [.log(true), .compress])
        
        socket = SocketIOClient(manager: manager, nsp: "/watch")//manager.defaultSocket
        
        socket.onAny {print("Got event: \($0.event), with items: \(String(describing: $0.items))")}
        
        socket.on("data", callback: { (data, ack) in
            print(data)


        })
        
        socket.on("error", callback: { (data, ack) in
            print(data)
            print(ack)
            
        })
        
        
        socket.on("connect", callback: { (data, ack) in
            print(data)
            print(ack)


            self.socket.emit("ping", [])

        })

        socket.connect()
    }
    
}

