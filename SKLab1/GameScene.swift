//
//  GameScene.swift
//  SKLab1
//
//  Created by Lisa Steele on 8/22/17.
//  Copyright © 2017 lisahsteele. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Player : UInt32 = 0b1
    static let square : UInt32 = 0b10
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player = SKSpriteNode(imageNamed: "Player")
    var isFingerOnPlayer = false
    var touchedPlayerNode: SKNode!
    
    override func didMove(to view: SKView) {
    
        backgroundColor = SKColor(red: 1.89, green: 1.89, blue: 1.89, alpha: 1.0)
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        addChild(player)
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addSquare),
                SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    

    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addSquare() {
     
        var squares = [SKSpriteNode]()
        let sqOne = SKSpriteNode(imageNamed: "SquareOne")
        let sqTwo = SKSpriteNode(imageNamed: "SquareTwo")
        let sqThree = SKSpriteNode(imageNamed: "SquareThree")
        let sqFour = SKSpriteNode(imageNamed: "SquareFour")
        let sqFive = SKSpriteNode(imageNamed: "SquareFive")
        
        squares.append(sqOne)
        squares.append(sqTwo)
        squares.append(sqThree)
        squares.append(sqFour)
        squares.append(sqFive)
        
        let randomSquareGenerator = Int(arc4random_uniform(UInt32(squares.count)))
        let square = squares[randomSquareGenerator]
        
        var actualX = random(min: sqOne.size.height/2, max: size.height - sqOne.size.height/2)
        actualX = max(actualX, square.size.width/2)
        actualX = min(actualX, size.width - square.size.width/2)
        
        square.position = CGPoint(x: actualX, y: size.height + sqOne.size.height)
        
        addChild(square)
        
        let actualDuration = random(min: CGFloat(4.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -sqOne.size.width/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        square.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
   
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touch = touches.first
            let location = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            
            player.position.x = location.x
            player.position.y = size.height * 0.1
            
            var playerX = player.position.x + (location.x - previousLocation.x)
            
            playerX = max(playerX, player.size.width/2)
            playerX = min(playerX, size.width - player.size.width/2)
            
            player.position = CGPoint(x: playerX, y: player.position.y)
        }
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPlayer = false
    }
}
