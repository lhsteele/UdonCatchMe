//
//  GameRulesScene.swift
//  SKLab1
//
//  Created by Lisa Steele on 12/20/17.
//  Copyright © 2017 lisahsteele. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameRulesScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "GameOverBackground")
    let gameRulesTexture = SKTexture(imageNamed: "GameRules")
    var gameRules: SKSpriteNode! = nil
    let smallBackToGameTexture = SKTexture(imageNamed: "BackButtonSm")
    var smallBackToGameButton: SKSpriteNode! = nil
    
    var playableRect: CGRect
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    
    override func sceneDidLoad() {
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        if UIScreen.main.sizeType == .iphone4 {
            gameRules = SKSpriteNode(imageNamed: "GameRules")
            gameRules.setScale(0.75)
        } else if UIScreen.main.sizeType == .iphone5 {
            gameRules = SKSpriteNode(imageNamed: "GameRules")
            gameRules.setScale(0.80)
        } else {
            gameRules = SKSpriteNode(imageNamed: "GameRules")
        } 
        
        
        gameRules.position = CGPoint(x: size.width/2 - 10, y: (size.height / 2) - 45)
        gameRules.zPosition = 0
        addChild(gameRules)
        
        smallBackToGameButton = SKSpriteNode(texture: smallBackToGameTexture)
        smallBackToGameButton.position = CGPoint(x: size.width/2, y: (gameRules.size.height - gameRules.size.height) + smallBackToGameButton.size.height * 2)
        smallBackToGameButton.zPosition = 1
        addChild(smallBackToGameButton)
    
    }
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = deviceHeight / deviceWidth
        let playableWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - playableWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if smallBackToGameButton.contains(location) {
                let scene = WelcomeScene(size: size)
                self.view?.presentScene(scene)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
