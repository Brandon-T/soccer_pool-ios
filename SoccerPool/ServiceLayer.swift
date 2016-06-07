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
    
    static func testGames(completion: (json: [String: AnyObject]?, error: NSError?) -> Void) -> Void {
        ServiceLayer.request(.TestGames, completion: completion)
    }
    
    static func isLoggedIn() -> Bool {
        return Router.accessToken != nil ? !Router.accessToken!.isEmpty : false
    }
    
    static func loginUser(email: String, password: String, completion: (json: [String: AnyObject]?, error: NSError?) -> Void) -> Void {
        ServiceLayer.request(Router.Login(email, password), completion: { (json, error) in
            
            if error != nil {
                completion(json: json, error: error)
                return
            }
            
            Router.accessToken = json?["token"] as? String
            completion(json: json, error: error)
        })
    }
    
    static func registerUser(email: String, password: String, completion: (json: [String: AnyObject]?, error: NSError?) -> Void) -> Void {
        ServiceLayer.request(Router.Register(email, password), completion: { (json, error) in
            
            if error != nil {
            completion(json: json, error: error)
            return
            }
            
            Router.accessToken = json?["token"] as? String
            completion(json: json, error: error)
        })
    }
    
    static func getPool(completion: (json: [String: AnyObject]?, error: NSError?) -> Void) -> Void {
        ServiceLayer.request(Router.Pool, completion: completion)
    }
    
    static func getGames(completion: (json: [String: AnyObject]?, error: NSError?) -> Void) -> Void {
        ServiceLayer.request(Router.Games, completion: completion)
    }
    
    static func predictGame(gameID: UInt, awayGoals: UInt, homeGoals: UInt, completion: (json: [String: AnyObject]?, error: NSError?) -> Void) -> Void {
        ServiceLayer.request(Router.PredictGames(gameID, awayGoals, homeGoals), completion: completion);
    }
    
    
    
    static func request(router: Router, completion: (json: [String: AnyObject]?, error: NSError?) -> Void) -> Void {
        requestManager.request(router)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json", "text/html"])
            .responseJSON { (response) in
                
                func toError(json: [String: AnyObject]?) -> NSError? {
                    let success: Bool = json?["success"] as! Bool
                    let errorMessage: String = json?["errorMessage"] as! String
                    let errorCode: Int = json?["errorCode"] as! Int
                    
                    guard success else {
                        return NSError(domain: "com.soccer-pool.error", code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    }
                    return nil
                }
                
                guard response.result.isSuccess else {
                    print("Error: \(response.result.error)")
                    completion(json: nil, error: response.result.error ?? toError(response.result.value as? [String: AnyObject]))
                    return
                }
                
                completion(json: response.result.value as? [String: AnyObject], error: response.result.error ?? toError(response.result.value as? [String: AnyObject]))
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
        case Register(String, String)
        case Pool
        case Games
        case PredictGames(UInt, UInt, UInt)
        case TestGames
        
        
        var route: (method: Alamofire.Method, path: String, parameters: [String : AnyObject]?) {
            switch self {
            case .Base:
                return (.GET, "/", nil)
                
            case .Login(let email, let password):
                return (.POST, "/test/login", ["email": email, "password": password])
                
            case .Register(let email, let password):
                return (.POST, "test/login", ["email": email, "password": password, "signup": true])
                
            case .Pool:
                return (.GET, "/test/pool", nil)
                
            case .Games:
                return (.GET, "/test/games", nil)
                
            case .PredictGames(let gameID, let awayGoals, let homeGoals):
                return (.POST, "/test/predictgame", ["gameID": gameID, "awayGoals": awayGoals, "homeGoals": homeGoals])
            
            case .TestGames:
                return (.GET, "/test/setup", nil)
            }
        }
        
        
        
        
        static let baseURL = NSURL(string: "http://104.131.118.14")!

        static var token: String?
        static var accessToken: String? {
            set {
                token = newValue
                NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "accessToken")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            get {
                return token ?? NSUserDefaults.standardUserDefaults().stringForKey("accessToken")
            }
        }
        
        var URL: NSURL { return Router.baseURL.URLByAppendingPathComponent(route.path) }
        
        var URLRequest: NSMutableURLRequest {
            let request = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = route.method.rawValue
            request.setValue(Router.accessToken, forHTTPHeaderField: "HTTP_TOKEN")
            return ParameterEncoding.URL.encode(request, parameters: route.parameters).0
        }
    }
}