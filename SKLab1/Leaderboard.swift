//
//  Leaderboard.swift
//  SKLab1
//
//  Created by Lisa Steele on 9/22/17.
//  Copyright © 2017 lisahsteele. All rights reserved.
//
/*
import Foundation
import GameKit

class Leaderboard: UIViewController, GKGameCenterControllerDelegate {
    
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    
    var score = 0
    
    let LEADERBOARD_ID = "com.score.sklab1"
    
    override func viewDidLoad() {
        authenticateLocalPlayer()
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(Leaderboard, error) -> Void in
            if((Leaderboard) != nil) {
                self.present(Leaderboard!, animated: true, completion: 	nil)
            } else if (localPlayer.isAuthenticated) {
                self.gcEnabled = true
                
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifier, error) in
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifier!}
                })
            } else {
                self.gcEnabled = false
                print ("Local player could not be authenticated!")
                print (error)
            }
        }
    }
        
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
 
}
*/
