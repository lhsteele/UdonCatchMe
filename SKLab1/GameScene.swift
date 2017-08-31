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
    var topLayerBackground = SKSpriteNode()
    var isFingerOnPlayer = false
    var touchedPlayerNode: SKNode!
    
    var score : Int = 0 {
        didSet {
            lblScore.text = "Score: \(score)"
        }
    }
    var lblScore: SKLabelNode!
    var levelTimerLabel: SKLabelNode!
    var count = 60
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    let playableRect: CGRect
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        //debugDrawPlayableArea()
        playableAreaBorder()
        
        
        lblScore = SKLabelNode(fontNamed: "MalayalamSangamMN-Bold")
        lblScore.fontSize = 20
        lblScore.fontColor = SKColor.darkGray
        //lblScore.position = CGPoint(x: self.size.width-40, y: self.size.height-60)
        lblScore.position = CGPoint(x: playableRect.maxX - 35, y: playableRect.maxY-60)
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        score = 0
        addChild(lblScore)
        
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        
        levelTimerLabel = SKLabelNode(fontNamed: "MalayalamSangamMN-Bold")
        levelTimerLabel.fontSize = 20
        levelTimerLabel.fontColor = SKColor.darkGray
        //levelTimerLabel.position = CGPoint(x: self.size.width-350, y: self.size.height-60)
        levelTimerLabel.position = CGPoint(x: playableRect.minX + 35, y: playableRect.maxY-60)
        levelTimerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        addChild(levelTimerLabel)
        
        self.addPlayer()

        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addSquare),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
    }
    /*
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
            let playableHeight = size.width / maxAspectRatio
            let playableWidth = size.height / maxAspectRatio
            //let playableMargin = (size.height - playableHeight) / 2.0
            let playableMargin = (size.width - playableWidth) / 2.0
        //playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    */
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = deviceHeight / deviceWidth
        let playableWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - playableWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPlayer() {
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        addChild(player)
    }
    
    func addTopBackgroundLayer() {
        topLayerBackground.size.height = self.size.height
        topLayerBackground.size.width = self.size.width
        topLayerBackground.color = SKColor.white
        addChild(topLayerBackground)
    }
 
    func updateTimer() {
        if (count > 0) {
            count -= 1
            let minutes = String(count / 60)
            let seconds = String(count % 60)
            levelTimerLabel.text = minutes + ":" + seconds
        }
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
        //let sqFive = SKSpriteNode(imageNamed: "SquareFive")
        
        squares.append(sqOne)
        squares.append(sqTwo)
        squares.append(sqThree)
        squares.append(sqFour)
        //squares.append(sqFive)
        
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
        
        for _ in touches {
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
        score += 5
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
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 10.0
        addChild(shape)
    }
    */
    
    func playableAreaBorder() {
        let area = SKShapeNode(rect: playableRect)
        area.lineWidth = 10
        area.strokeColor = SKColor.red
        addChild(area)
    }
}
