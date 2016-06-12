//
//  FootBallAPI.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-11.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import Alamofire

class FootballPlayer : NSObject, Serializeable {
    var position: String?
    var birth_date: String?
    var image: String?
    var birth_place: String?
    var nationality: String?
    var name: String?
    var height: String?
    var nickname: String?
    var goals: Int?
    var full_name: String?
    var weight: String?
    var team: String?
    var TA: String?
    var TR: String?
    var jersey_number: String?
    
    
    @objc override internal func propertyForName(name: String) -> String {
        let dict = ["position": "demarcacion", "birth_date": "fecha_nacimiento", "image": "imagen", "birth_place": "lugar_nacimiento", "nationality": "nacionalidad", "name": "nombre", "height": "altura", "nickname": "apodo", "goals": "goles", "full_name": "nombre_completo", "weight": "peso", "team": "seleccion", "TA": "TA", "TR": "TR", "jersey_number": "dorsal"]
        return dict[name] ?? name
    }
}

class FootballAPI {
    static func getPlayers(teamName: String, completion: (players: [FootballPlayer]?, error: NSError?) -> Void) -> Void {
        FootballAPI.request(FootballRouter.Players(teamName)) { (json, error) in
            guard error == nil else {
                completion(players: nil, error: error)
                return
            }
            
            if let dict = json!["plantilla"] as? [[String: AnyObject]] {
                let players = FootballPlayer.fromJSONArray(dict) as? [FootballPlayer]
                completion(players: players, error: nil)
            }
        }
    }
    
    static func request(router: FootballRouter, completion: (json: [String: AnyObject]?, error: NSError?) -> Void) -> Void {
        requestManager.request(router)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json", "text/html"])
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    print("Error: \(response.result.error)")
                    completion(json: nil, error: response.result.error)
                    return
                }
                
                completion(json: response.result.value as? [String: AnyObject], error: response.result.error)
        }
    }
    
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
    
    enum FootballRouter: URLRequestConvertible {
        
        case Players(String)
        
        
        var route: (method: Alamofire.Method, path: String, parameters: [String : AnyObject]?) {
            switch self {
            case .Players(let teamName):
                let teams = ["Albania":1, "Austria":21, "Belgium":17, "Croatia":13, "Czech Republic":14, "England":5, "France":2, "Germany":9, "Hungary":22, "Iceland":23, "Republic of Ireland":19, "Italy":18, "Northern Ireland":10, "Poland":11, "Portugal":24, "Romania":3, "Russia":6, "Slovakia":7, "Spain":15, "Sweden":20, "Switzerland":4, "Turkey":16, "Ukraine":12, "Wales":8]
                
                return (.GET, "/jugadores_equipo_json_generator.php", ["equipo":teams[teamName]!, "lang":"en"])
            }
        }
        
        
        
        
        static let baseURL = NSURL(string: "http://europecup2016.com")!

        var URL: NSURL {
            return FootballRouter.baseURL.URLByAppendingPathComponent(route.path)
        }
        
        var URLRequest: NSMutableURLRequest {
            let request = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = route.method.rawValue
            request.addValue("Euro%202016/2.05 CFNetwork/758.4.3 Darwin/15.5.0", forHTTPHeaderField: "User-Agent")
            return ParameterEncoding.URL.encode(request, parameters: route.parameters).0
        }
    }
}