//
//  FootballPlayer.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-12.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation

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