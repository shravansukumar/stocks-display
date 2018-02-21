//
//  AppDelegate.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 17/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SocketIOManager.shared.connect()
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {
        SocketIOManager.shared.disconnect()
    }


}

