//
//  Game.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-05.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation

class Game : BaseModel {
    var gameID: UInt = 0
    var awayGoals: UInt = 0
    var awayTeam: Team?
    var homeGoals: UInt = 0
    var homeTeam: Team?
    var prediction: Prediction?
    var startTime: NSDate?
    var cutOffTime: NSDate?
    var hasBeenPredicted: Bool = false
}