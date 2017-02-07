//
//  FootballStanding.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-12.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation

class FootballStandingGroup: NSObject, Serializeable {
    var group: String!
    var rank: Int = -1
    var team: String!
    var image: String!
    var teamId: Int = 0
    var playedGames: Int = 0
    var points: Int = 0
    var goals: Int = 0
    var goalsAgainst: Int = 0
    var goalDifference: Int = 0

    @objc override class func fromJSON(json: [NSObject : AnyObject]!) -> FootballStandingGroup! {
        let instance = super.fromJSON(json) as! FootballStandingGroup
        instance.image = FootballAPI.getImageURL(instance.team)
        return instance
    }
}

class FootballStanding : NSObject, Serializeable {
    var groupA: [FootballStandingGroup]!
    var groupB: [FootballStandingGroup]!
    var groupC: [FootballStandingGroup]!
    var groupD: [FootballStandingGroup]!
    var groupE: [FootballStandingGroup]!
    var groupF: [FootballStandingGroup]!
    
    @objc override internal func classForProperty(property: String!) -> AnyClass! {
        return FootballStandingGroup.self
    }
    
    @objc override internal func propertyForName(name: String) -> String {
        let dict = ["groupA":"A", "groupB":"B", "groupC":"C", "groupD": "D", "groupE":"E", "groupF":"F"]
        return dict[name] ?? name
    }
}