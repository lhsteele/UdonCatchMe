//
//  GameState.swift
//  SKLab1
//
//  Created by Lisa Steele on 8/26/17.
//  Copyright © 2017 lisahsteele. All rights reserved.
//
/*
import Foundation

class GameState {
    var score: Int
    var highScore: Int
    //var countdown: Int?
    
    class var sharedInstance: GameState {
        struct Singleton {
            static let instance = GameState()
        }
        return Singleton.instance
    }
    
    init() {
        score = 0
        highScore = 0
        //countdown = 0
        
        let defaults = UserDefaults.standard
        
        highScore = defaults.integer(forKey: "highScore")
    }
    
    func saveState() {
        highScore = max(score, highScore)
        
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highScore")
        UserDefaults.standard.synchronize()
    }
}

*/


