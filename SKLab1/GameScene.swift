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
    
    let sqOneColor = UIColor(red: 1.82, green: 1.39, blue: 0.27, alpha: 1)
    let sqTwoColor = UIColor(red: 1.82, green: 0.27, blue: 1.12, alpha: 1)
    let sqThreeColor = UIColor(red: 0.27, green: 1.82, blue: 1.64, alpha: 1)
    let sqFourColor = UIColor(red: 0.27, green: 0.45, blue: 1.82, alpha: 1)
    var randomBorderColor = UIColor()
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        //playableAreaBorder()
        randomBorderColorChange(fromColor: UIColor.white, toColor: randomBorderColor, duration: 0.1)
        
        lblScore = SKLabelNode(fontNamed: "MalayalamSangamMN-Bold")
        lblScore.fontSize = 20
        lblScore.fontColor = SKColor.darkGray
        lblScore.position = CGPoint(x: playableRect.maxX - 35, y: playableRect.maxY-60)
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        score = 0
        addChild(lblScore)
        
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        
        levelTimerLabel = SKLabelNode(fontNamed: "MalayalamSangamMN-Bold")
        levelTimerLabel.fontSize = 20
        levelTimerLabel.fontColor = SKColor.darkGray
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
        
        squares.append(sqOne)
        squares.append(sqTwo)
        squares.append(sqThree)
        squares.append(sqFour)
        
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
    func playableAreaBorder() {
        let area = SKShapeNode(rect: playableRect)
        area.lineWidth = 10
        area.strokeColor = SKColor.red
        addChild(area)
    }
    */
    func randomBorderColorChange(fromColor: UIColor, toColor: UIColor, duration: Double = 0.1) -> SKAction {
        var availableColors = [UIColor]()
        availableColors.append(sqOneColor)
        availableColors.append(sqTwoColor)
        availableColors.append(sqThreeColor)
        availableColors.append(sqFourColor)
        
        let cycle = SKAction.wait(forDuration: 0.2, withRange: 0.1)
    
        let customAction = SKAction.run({
            
            let randomColorGenerator = Int(arc4random_uniform(UInt32(availableColors.count)))
            self.randomBorderColor = availableColors[randomColorGenerator]
            
            let border = SKShapeNode(rect: self.playableRect)
            border.lineWidth = 10
            border.strokeColor = self.randomBorderColor
            self.addChild(border)
        })
        return SKAction.sequence([cycle, customAction])
    }
}
