//
//  GameOverScene.swift
//  SKLab1
//
//  Created by Lisa Steele on 9/25/17.
//  Copyright © 2017 lisahsteele. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let replayButtonTexture = SKTexture(imageNamed: "ReplayButton")
    var replayButton : SKSpriteNode! = nil
    let highScoreNode = SKLabelNode(fontNamed: "AvenirNext-UltraLight")
    let scoreKey = "SKLab_Highscore"
    
    override func sceneDidLoad() {
        backgroundColor = SKColor.white
        
        replayButton = SKSpriteNode(texture: replayButtonTexture)
        replayButton.position = CGPoint(x: size.width/2, y: size.height/2 - replayButton.size.height/2)
        addChild(replayButton)
        
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: scoreKey)
        print ("highScore\(highScore)")
        
        highScoreNode.text = "High Score: \(highScore)"
        highScoreNode.fontSize = 30
        highScoreNode.fontColor = SKColor.darkGray
        highScoreNode.verticalAlignmentMode = .top
        //highScoreNode.position = CGPoint(x: size.width/2, y: replayButton.position.y - replayButton.size.height/2 - 50)
        highScoreNode.position = CGPoint(x: size.width/2, y: size.height/2 + 50)
        highScoreNode.zPosition = 1
        
        addChild(highScoreNode)
    }
    
    init(size: CGSize, won: Bool) {
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        let message = won ? "You Won!" : "You Lost :("
        
        let label = SKLabelNode(fontNamed: "AvenirNext-UltraLight")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.darkGray
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        addChild(label)
        
        /*
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3),
            SKAction.run() {
                let reveal = SKTransition.flipHorizontal(withDuration: 1)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            }
        ]))
        */
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if replayButton.contains(location) {
                let reveal = SKTransition.flipHorizontal(withDuration: 1)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
