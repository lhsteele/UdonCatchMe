//
//  WelcomeScene.swift
//  SKLab1
//
//  Created by Lisa Steele on 11/8/17.
//  Copyright © 2017 lisahsteele. All rights reserved.
//

import SpriteKit

class WelcomeScene: SKScene {
    
    var welcomeLabel: SKLabelNode!
    let beginButtonTexture = SKTexture(imageNamed: "BeginButton")
    var beginButton: SKSpriteNode! = nil
    var background = SKSpriteNode(imageNamed: "WelcomeBackground")
    let gameInstructionsSpeechBubbleTexture = SKTexture(imageNamed: "GameInstructionsSpeechBubble")
    var speechBubble: SKSpriteNode! = nil
    
    override func didMove(to view: SKView) {
        beginButton = SKSpriteNode(texture: beginButtonTexture)
        beginButton.position = CGPoint(x: size.width/2, y: size.height/2 - beginButton.size.height/2)
        addChild(beginButton)
        
        speechBubble = SKSpriteNode(texture: gameInstructionsSpeechBubbleTexture)
        speechBubble.position = CGPoint(x: size.width/2, y: (size.height/2 + beginButton.size.height) - speechBubble.size.height/2)
        addChild(speechBubble)
        
    }
    
    override func sceneDidLoad() {
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        name = "WelcomeScene"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if beginButton.contains(location) {
                let scene = GameScene(size: size)
                self.view?.presentScene(scene)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
