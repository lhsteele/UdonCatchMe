//
//  WelcomeScene.swift
//  SKLab1
//
//  Created by Lisa Steele on 11/8/17.
//  Copyright © 2017 lisahsteele. All rights reserved.
//

import SpriteKit
import GameKit

class WelcomeScene: SKScene, GKGameCenterControllerDelegate {
    
    var welcomeLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        welcomeLabel = SKLabelNode(fontNamed: "AvenirNext-UltraLight")
        welcomeLabel.text = "Welcome"
        welcomeLabel.fontSize = 50
        welcomeLabel.fontColor = SKColor.darkGray
        welcomeLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(welcomeLabel)
    }
    
    override func sceneDidLoad() {
        backgroundColor = SKColor.white
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        name = "WelcomeScene"
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

}
