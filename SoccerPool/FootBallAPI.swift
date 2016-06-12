//
//  FootBallAPI.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-11.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import Alamofire

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
    
    static func getStandingsInfo(completion: (standingsInfo: FootballStanding?, error: NSError?) -> Void) -> Void {
        FootballAPI.request(FootballRouter.League(424)) { (json, error) in
            guard error == nil else {
                completion(standingsInfo: nil, error: error)
                return
            }
            
            if let dict = json!["standings"] as? [String: AnyObject] {
                let standingInfo = FootballStanding.fromJSON(dict)
                completion(standingsInfo: standingInfo, error: nil)
            }
        }
    }
    
    static func getImageURL(teamName: String) -> String {
        return "http://104.131.118.14/images/\(teamName).png"
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
        case League(Int)
        
        
        var route: (method: Alamofire.Method, path: String, parameters: [String : AnyObject]?, headers: [String: AnyObject]?) {
            switch self {
            case .Players(let teamName):
                let teams = ["Albania":1, "Austria":21, "Belgium":17, "Croatia":13, "Czech Republic":14, "England":5, "France":2, "Germany":9, "Hungary":22, "Iceland":23, "Republic of Ireland":19, "Italy":18, "Northern Ireland":10, "Poland":11, "Portugal":24, "Romania":3, "Russia":6, "Slovakia":7, "Spain":15, "Sweden":20, "Switzerland":4, "Turkey":16, "Ukraine":12, "Wales":8]
                return (.GET, "/jugadores_equipo_json_generator.php", ["equipo":teams[teamName]!, "lang":"en"], ["User-Agent": "Euro%202016/2.05 CFNetwork/758.4.3 Darwin/15.5.0"])
                
            case .League(let leagueID):
                return (.GET, "/soccerseasons/\(leagueID)/leagueTable", nil, ["X-Auth-Token": "8e4fb54a4f0e4717ad1e45e2abc2d2f6"])
            }
        }
        
        
        var URL: NSURL {
            switch self {
            case .Players:
                return NSURL(string: "http://europecup2016.com")!.URLByAppendingPathComponent(route.path)
                
            case .League:
                return NSURL(string: "http://api.football-data.org/v1")!.URLByAppendingPathComponent(route.path)
            }
        }
        
        var URLRequest: NSMutableURLRequest {
            let request = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = route.method.rawValue
            return ParameterEncoding.URL.encode(request, parameters: route.parameters).0
        }
    }
}