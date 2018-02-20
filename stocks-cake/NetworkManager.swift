//
//  NetworkManager.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 20/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class NetworkManager {
    
    func request(_ serverResponse: @escaping (Bool, [Any]?) -> ()) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 90
        let historicalUrl = URL(string: URLManager().base + URLManager().context + URLManager().historicalData)!
        
        let _ = manager.request(historicalUrl, method: .get, parameters: nil,
                                encoding: JSONEncoding.default, headers:nil).responseJSON { response in
                                    switch response.result {
                                    case .success(let response):
                                        if let json = response as? [Any] {
                                            print(json)
                                            return serverResponse(true, json)
                                        }
                                        
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                        return serverResponse(false,nil)
                                    }
        }
    }
}
