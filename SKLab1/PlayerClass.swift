//
//  PlayerClass.swift
//  SKLab1
//
//  Created by Lisa Steele on 12/13/17.
//  Copyright © 2017 lisahsteele. All rights reserved.
//

import UIKit

class PlayerClass: NSObject {
    
    var playerName: String
    var highScore: Int
    
    
    init(playerName: String, highScore: Int) {
        self.playerName = playerName
        self.highScore = highScore
        
        super.init()
    }
}
