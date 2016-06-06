//
//  Game.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-05.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation

class Game : NSObject, Serializeable {
    var gameID: Int = 0
    var awayGoals: Int = 0
    var awayTeam: Team?
    var homeGoals: Int = 0
    var homeTeam: Team?
    var prediction: Prediction?
    var startTime: NSDate?
}