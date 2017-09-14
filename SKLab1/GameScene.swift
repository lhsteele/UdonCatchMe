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
    var levelTimerLabel = SKLabelNode(fontNamed: "MalayalamSangamMN-Bold")
    
    var count = 60
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    let playableRect: CGRect
    var gameTimer = Timer()
    
    let sqOneColor = UIColor(red: 1.82, green: 1.39, blue: 0.27, alpha: 1)
    let sqTwoColor = UIColor(red: 1.82, green: 0.27, blue: 1.12, alpha: 1)
    let sqThreeColor = UIColor(red: 0.27, green: 1.82, blue: 1.64, alpha: 1)
    let sqFourColor = UIColor(red: 0.27, green: 0.45, blue: 1.82, alpha: 1)
   
    var totalSeconds: Int = 60
    var randomSquareBool = false
    var bonusSquareMethodBool = false
    
    var randomGeneratedSquareColor: String = ""
    var fallingSquareColor: String = ""
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
        
        lblScore = SKLabelNode(fontNamed: "MalayalamSangamMN-Bold")
        lblScore.fontSize = 20
        lblScore.fontColor = SKColor.darkGray
        lblScore.position = CGPoint(x: playableRect.maxX - 35, y: playableRect.maxY-60)
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        score = 0
        addChild(lblScore)
        
        self.restartTimer()
        
        //levelTimerLabel = SKLabelNode(fontNamed: "MalayalamSangamMN-Bold")
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
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: 10),
                SKAction.run(randomBonusSquareColorChange),
                SKAction.wait(forDuration: 10)
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
        
        sqOne.name = "mustard"
        sqTwo.name = "pink"
        sqThree.name = "turquoise"
        sqFour.name = "blue"
        
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
    
    func pointsForRegGamePlay(square: SKSpriteNode, player: SKSpriteNode) {
        score += 5
        square.removeFromParent()
    }
    
    func pointsForMatchingColors(square: SKSpriteNode, player: SKSpriteNode) {
        score += 10
        square.removeFromParent()
    }
    
    func pointsForRandomSquareGamePlay(square: SKSpriteNode, player: SKSpriteNode) {
        //if the random square generated matches the color of the square colling with player, then add points. 
        //if colors don't match, stop the randomBonusSquareColorChange method and restart clock.
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
            
                if let sq = square as SKSpriteNode! {
                    if let sqName = sq.name {
                        fallingSquareColor = sqName
                        //print (fallingSquareColor)
                    }
                }
                
                //here, need to add an IF
                //if the random square is not showing, then run pointsForRegGamePlay
                //if the random square is showing, then need to do another IF to see if the random square color
                //and collision square color match.
                //if they match, then need to call new method to calculate points.
                if bonusSquareMethodBool == false {
                    self.pointsForRegGamePlay(square: square, player: player)
                } else {
                    if randomGeneratedSquareColor == fallingSquareColor {
                        //print ("match")
                        self.pointsForMatchingColors(square: square, player: player)
                    } else {
                        print ("GAME OVER")
                    }
                }
                //When no random square is showing, points are added 10 at a time.
                //When random square is showing, wrong color adds 5, correct color adds 15.
                pointsForRegGamePlay(square: square, player: player)
            }
        }
    }
   
    func restartTimer() {
        let wait: SKAction = SKAction.wait(forDuration: 1)
        let finishTimer: SKAction = SKAction.run {
            self.updateTimer()
            self.restartTimer()
        }
        let seq:SKAction = SKAction.sequence([wait, finishTimer])
        levelTimerLabel.run(seq, withKey: "timer")
    }
    
    func updateTimer() {
        if (totalSeconds > 0) {
            totalSeconds -= 1
            let minutes = String(totalSeconds / 60)
            let seconds = String(totalSeconds % 60)
            levelTimerLabel.text = minutes + ":" + seconds
        }
    }
    
    func changeBooleanToTrue() {
        randomSquareBool = true
        if randomSquareBool == true {
            if let action = levelTimerLabel.action(forKey: "timer") {
                action.speed = 0
            }
        }
    }
    
    func changeBooleanToFalse() {
        randomSquareBool = false
        if randomSquareBool == false {
            if let action = levelTimerLabel.action(forKey: "timer") {
                action.speed = 1
            }
        }
    }
    
    func changeBonusSquareMethodBooleanToTrue() {
        bonusSquareMethodBool = true
    }
    
    func changeBonusSquareMethodBooleanToFalse() {
        bonusSquareMethodBool = false
    }
    
    func randomBonusSquareColorChange() {
        //bonusSquareMethodBool = true
        
        var bonusSquares = [SKSpriteNode]()
        let bonusSqOne = SKSpriteNode(imageNamed: "BigSqOne")
        let bonusSqTwo = SKSpriteNode(imageNamed: "BigSqTwo")
        let bonusSqThree = SKSpriteNode(imageNamed: "BigSqThree")
        let bonusSqFour = SKSpriteNode(imageNamed: "BigSqFour")
        
        bonusSqOne.name = "mustard"
        bonusSqTwo.name = "pink"
        bonusSqThree.name = "turquoise"
        bonusSqFour.name = "blue"
        
        bonusSquares.append(bonusSqOne)
        bonusSquares.append(bonusSqTwo)
        bonusSquares.append(bonusSqThree)
        bonusSquares.append(bonusSqFour)
        
        let randomBonusSquareGenerator = Int(arc4random_uniform(UInt32(bonusSquares.count)))
        let randomBonusSquare = bonusSquares[randomBonusSquareGenerator]
        
        
        randomBonusSquare.position = CGPoint(x: self.playableRect.maxX - 200, y: self.playableRect.maxY - 50)
        addChild(randomBonusSquare)
        
        if let rBS = randomBonusSquare as SKSpriteNode! {
            if let rBSName = rBS.name {
                //print (rBSName)
                randomGeneratedSquareColor = rBSName
            }
        }
        
        //print (randomGeneratedSquareColor)
        
        
        randomBonusSquare.run (
                SKAction.sequence ([
                    SKAction.run {
                        self.changeBooleanToTrue()
                        self.changeBonusSquareMethodBooleanToTrue()
                    },
                    
                    SKAction.wait(forDuration: 7, withRange: 3),
                    SKAction.removeFromParent(),
                    SKAction.run {
                        self.changeBooleanToFalse()
                        self.changeBonusSquareMethodBooleanToFalse()
                    },
                ])
        )
    }
    
}
