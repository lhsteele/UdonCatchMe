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
    let gameRulesTexture = SKTexture(imageNamed: "GameRulesButton")
    var gameRulesButton: SKSpriteNode! = nil
    var background = SKSpriteNode(imageNamed: "WelcomeBackground")
    let gameInstructionsSpeechBubbleTexture = SKTexture(imageNamed: "GameInstructionsSpeechBubble")
    var speechBubble: SKSpriteNode! = nil
    
    var playableRect: CGRect
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    
    override func didMove(to view: SKView) {
        beginButton = SKSpriteNode(texture: beginButtonTexture)
        beginButton.position = CGPoint(x: size.width/2, y: size.height/2 - beginButton.size.height/2)
        addChild(beginButton)
        
        speechBubble = SKSpriteNode(texture: gameInstructionsSpeechBubbleTexture)
        speechBubble.position = CGPoint(x: size.width/2, y: (size.height/2 + beginButton.size.height) - speechBubble.size.height/2)
        addChild(speechBubble)
        
        gameRulesButton = SKSpriteNode(texture: gameRulesTexture)
        gameRulesButton.position = CGPoint(x: (size.width - size.width) + 75, y: (size.height - size.height) + 30)
        addChild(gameRulesButton)
        
    }
    
    override func sceneDidLoad() {
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
    }
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = deviceHeight / deviceWidth
        let playableWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - playableWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
        name = "WelcomeScene"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if beginButton.contains(location) {
                let scene = GameScene(size: size)
                self.view?.presentScene(scene)
            } else if gameRulesButton.contains(location) {
                let scene2 = GameRulesScene(size: size)
                self.view?.presentScene(scene2)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
