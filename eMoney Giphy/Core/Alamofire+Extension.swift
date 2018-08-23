//
//  Alamofire+Extension.swift
//  eMoney Giphy
//
//  Created by Nikoloz Tatunashvili on 23.08.18.
//  Copyright © 2018 Nikoloz Tatunashvili. All rights reserved.
//

import Foundation
import Alamofire

let AppSessionManager: SessionManager = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    configuration.urlCache = nil
    return SessionManager(configuration: configuration)
}()
