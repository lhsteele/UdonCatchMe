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
    static let Square : UInt32 = 0b1
    static let Player : UInt32 = 0b10
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player = SKSpriteNode(imageNamed: "Player")
    var isFingerOnPlayer = false
    var touchedPlayerNode: SKNode!
    var lblScore: SKLabelNode!
    var score : Int = 0 {
        didSet {
            lblScore.text = "Score: \(score)"
        }
    }
    //var lblCounter: SKLabelNode!
    let hudNode = SKNode()
    var levelTimerLabel = SKLabelNode(fontNamed: "HeitiSC-Bold")
    var levelTimerValue: Int = 500
       
    
    /*
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    */
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor(red: 1.89, green: 1.89, blue: 1.89, alpha: 1.0)
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        addChild(player)
        
        lblScore = SKLabelNode(fontNamed: "HeitiSC-Bold")
        lblScore.fontSize = 50
        lblScore.fontColor = SKColor.darkGray
        lblScore.position = CGPoint(x: self.size.width-40, y: self.size.height-60)
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        lblScore.text = "0"
        addChild(hudNode)
        hudNode.addChild(lblScore)
        
        levelTimerLabel.fontColor = SKColor.darkGray
        levelTimerLabel.fontSize = 50
        levelTimerLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 350)
        levelTimerLabel.text = "Time left: \(levelTimerValue)"
        addChild(levelTimerLabel)
        
        let wait = SKAction.wait(forDuration: 0.5)
        let block = SKAction.run({
            [unowned self] in
            if self.levelTimerValue > 0 {
                self.levelTimerLabel
            } else {
                self.removeAction(forKey: "countdown")
            }
        })
        let sequence = SKAction.sequence([wait, block])
        run(SKAction.repeatForever(sequence), withKey: "countdown")
        
        
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
        
        square.physicsBody = SKPhysicsBody(rectangleOf: square.size)
        square.physicsBody?.isDynamic = true
        square.physicsBody?.categoryBitMask = PhysicsCategory.Square
        square.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        square.physicsBody?.collisionBitMask = PhysicsCategory.None
        
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
            
            player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
            player.physicsBody?.isDynamic = true
            player.physicsBody?.categoryBitMask = PhysicsCategory.Player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.Square
            player.physicsBody?.collisionBitMask = PhysicsCategory.None
            player.physicsBody?.usesPreciseCollisionDetection = true
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPlayer = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if action(forKey: "countdown") != nil {removeAction(forKey: "countdown")}
    }
    
    func squareDidCollideWithPlayer(square: SKSpriteNode, player: SKSpriteNode) {
        print ("hit")
        let startingScore = 0
        startingScore + 10 == score
        print (score)
        square.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Square != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Player != 0)) {
            if let square = firstBody.node as? SKSpriteNode, let
                player = secondBody.node as? SKSpriteNode {
                squareDidCollideWithPlayer(square: square, player: player)
            }
        }
    }
    /*
    override init(size: CGSize) {
        super.init(size: size)
        
        lblScore = SKLabelNode(fontNamed: "HeitiSC-Bold")
        lblScore.fontSize = 30
        lblScore.fontColor = SKColor.darkGray
        lblScore.position = CGPoint(x: self.size.width-20, y: self.size.height-40)
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        lblScore.text = "0"
        hudNode.addChild(lblScore)
    }
    */
}
