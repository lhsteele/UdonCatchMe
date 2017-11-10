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
    let beginButtonTexture = SKTexture(imageNamed: "BeginButton")
    var beginButton: SKSpriteNode! = nil
    
    override func didMove(to view: SKView) {
        welcomeLabel = SKLabelNode(fontNamed: "AvenirNext-UltraLight")
        welcomeLabel.text = "Welcome"
        welcomeLabel.fontSize = 50
        welcomeLabel.fontColor = SKColor.darkGray
        welcomeLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(welcomeLabel)
        
        beginButton = SKSpriteNode(texture: beginButtonTexture)
        beginButton.position = CGPoint(x: size.width/2, y: size.height/2 - beginButton.size.height/2)
        addChild(beginButton)
    }
    
    override func sceneDidLoad() {
        backgroundColor = SKColor.white
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        name = "WelcomeScene"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if beginButton.contains(location) {
                let reveal = SKTransition.doorway(withDuration: 1)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

}
