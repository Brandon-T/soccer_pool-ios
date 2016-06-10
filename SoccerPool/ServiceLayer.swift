//
//  NetworkingServices.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-03.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class ServiceLayer {
    
    static func testGames(completion: (json: [String: AnyObject]?, error: NSError?) -> Void) -> Void {
        ServiceLayer.request(.TestGames, completion: completion)
    }
    
    static func getInfo(completion: (json: [String: AnyObject]?, error: NSError?) -> Void) -> Void {
        ServiceLayer.request(.Info, completion: completion)
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
    
    static func logoutUser() -> Void {
        NSUserDefaults.standardUserDefaults().removeObjectForKey ("accessToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    
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
    
    static func getImage(url: String, completion: (image: UIImage?, error: NSError?) -> Void) -> Void {
        imageDownloader.downloadImage(URLRequest: Router.Image(url)) { (response) in
            if let image = response.result.value {
                completion(image: image, error: nil)
            }
            else {
                completion(image: nil, error: response.result.error)
            }
        }
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
    
    static let environment: Environment = .Test
    
    
    
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
    
    static let imageDownloader = {() -> ImageDownloader in
        struct Static {
            static var dispatchOnceToken: dispatch_once_t = 0
            static var instance: ImageDownloader!
        }
        
        dispatch_once(&Static.dispatchOnceToken) {
            Static.instance = ImageDownloader()
        }
        
        return Static.instance
    }()
    
    
    enum Environment: String {
        case Sample
        case Test
        case Live
    }
    
    
    enum Router: URLRequestConvertible {

        case Base
        case Login(String, String)
        case Register(String, String)
        case Pool
        case Games
        case PredictGames(UInt, UInt, UInt)
        case Image(String)
        case Info
        case TestGames
        
        
        var route: (method: Alamofire.Method, path: String, parameters: [String : AnyObject]?) {
            
            func getEnvironment(environment: Environment) -> String {
                switch environment {
                case .Sample:
                    return "/sample"
                    
                case .Test:
                    return "/test"
                    
                case .Live:
                    return ""
                }
            }
            
            switch self {
            case .Base:
                return (.GET, "/", nil)
                
            case .Login(let email, let password):
                return (.POST, "\(getEnvironment(environment))/login", ["email": email, "password": password])
                
            case .Register(let email, let password):
                return (.POST, "\(getEnvironment(environment))/login", ["email": email, "password": password, "signup": true])
                
            case .Pool:
                return (.GET, "\(getEnvironment(environment))/pool", nil)
                
            case .Games:
                return (.GET, "\(getEnvironment(environment))/games", nil)
                
            case .PredictGames(let gameID, let awayGoals, let homeGoals):
                return (.POST, "\(getEnvironment(environment))/predictgame", ["gameID": gameID, "awayGoals": awayGoals, "homeGoals": homeGoals])
                
            case .Image(let url):
                return (.GET, url, nil)
                
            case .Info:
                return (.GET, "\(getEnvironment(environment))/info", nil)
            
            case .TestGames:
                return (.GET, "\(getEnvironment(environment))/setup", nil)
            }
        }
        
        
        
        
        static let baseURL = NSURL(string: "http://104.131.118.14")!
        static let informationURL = NSURL(string: "http://104.131.118.14/info")
        
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
        
        var URL: NSURL {
            switch self {
            case .Image:
                return NSURL(string: route.path)!
                
            default:
                break
            }
            return Router.baseURL.URLByAppendingPathComponent(route.path)
        }
        
        var URLRequest: NSMutableURLRequest {
            let request = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = route.method.rawValue
            request.setValue(Router.accessToken, forHTTPHeaderField: "token")
            return ParameterEncoding.URL.encode(request, parameters: route.parameters).0
        }
    }
}