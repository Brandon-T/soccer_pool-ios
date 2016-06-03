//
//  NetworkingServices.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-03.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import Alamofire

class ServiceLayer {
    
    
    static func loginUser(email: String, password: String, completion: (json: [String: AnyObject]?, error: NSError?) -> Void) -> Void {
        requestManager.request(Router.Login(email, password))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json", "text/html"])
            .responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    print("Error: \(response.result.error)")
                    completion(json: nil, error: response.result.error)
                    return
                }
                
                completion(json: response.result.value as? [String: AnyObject], error: nil)
        }
    }
    
    static func getPool(completion: (json: [String: AnyObject]?, error: NSError?) -> Void) -> Void {
        requestManager.request(Router.Pool)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json", "text/html"])
            .responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    print("Error: \(response.result.error)")
                    completion(json: nil, error: response.result.error)
                    return
                }
                
                completion(json: response.result.value as? [String: AnyObject], error: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    
    //Private:
    
    static let requestManager = {() -> Manager in
        struct Static {
            static var dispatchOnceToken: dispatch_once_t = 0
            static var instance: Manager!
        }
        
        dispatch_once(&Static.dispatchOnceToken) {
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            config.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
            config.requestCachePolicy = .UseProtocolCachePolicy
            Static.instance = Manager(configuration: config)
        }
        
        return Static.instance
    }()
    
    
    
    enum Router: URLRequestConvertible {

        case Base
        case Login(String, String)
        case Pool
        
        
        var route: (method: Alamofire.Method, path: String, parameters: [String : AnyObject]?) {
            switch self {
            case .Base:
                return (.GET, "/", nil)
                
            case .Login(let email, let password):
                return (.POST, "/sample/login", ["email":email, "password":password])
                
            case .Pool:
                return (.GET, "/sample/pool", nil)
                
            }
        }
        
        
        
        
        static let baseURL = NSURL(string: "*************IPAddress/BaseURLHere************")!
        
        var URL: NSURL { return Router.baseURL.URLByAppendingPathComponent(route.path) }
        
        var URLRequest: NSMutableURLRequest {
            let request = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = route.method.rawValue
            return ParameterEncoding.URL.encode(request, parameters: route.parameters).0
        }
    }
}