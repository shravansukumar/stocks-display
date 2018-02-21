//
//  SocketManager.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 21/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation
import SocketIO

protocol LiveDataAvailable: class {
    func stock(data: String)
}

final class SocketIOManager {
    
    // shared instance
    static let shared = SocketIOManager()
    
    // MARK: - Variables
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    weak var delegate: LiveDataAvailable?
    
    // MARK: - Lifecycle
    private init() { }

    // MARK: - Public Methods
    func connect() {
        manager = SocketManager(socketURL: URL(string: URLManager().base)!, config: [.log(true), .compress])
        socket = manager.socket(forNamespace: "/watch")
        socket.connect()
        socket.onAny {print("Got event: \($0.event), with items: \(String(describing: $0.items))")}
        addCallbacks()
    }
    
    func disconnect() {
        self.socket.emit("unsub", ["state" : false])
        socket.disconnect()
    }
    
    // MARK: - Private Methods
    private func addCallbacks() {
        socket.on("data", callback: { (data, ack) in
            print(data)
            print(ack)
            
            if let firstData = data.first as? String {
                self.delegate?.stock(data: firstData)
            }
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0) {
                ack.with(1)
            }
        })
        
        socket.on("error", callback: { (data, ack) in
            print(data)
            print(ack)
            
        })
        
        socket.on("connect", callback: { (data, ack) in
            print(data)
            print(ack)
            
            self.socket.emit("sub", ["state" : true])
            
        })
    }
}
