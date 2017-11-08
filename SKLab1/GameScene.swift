//
//  GameScene.swift
//  SKLab1
//
//  Created by Lisa Steele on 8/22/17.
//  Copyright © 2017 lisahsteele. All rights reserved.
//

import SpriteKit
import GameKit


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
    let scoreKey = "SKLab_Highscore"
    var highScore = 10
    var showingHighScore = false
    
    var levelTimerLabel = SKLabelNode(fontNamed: "AvenirNext-UltraLight")
    var count = 10
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
    var mustRunBonusSqMethodBoolean = true
    
    let startButtonTexture = SKTexture(imageNamed: "StartButton")
    var startButton : SKSpriteNode! = nil
 
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    
    override func sceneDidLoad() {
        backgroundColor = SKColor.white
        
        startButton = SKSpriteNode(texture: startButtonTexture)
        startButton.position = CGPoint(x: size.width/2, y: size.height/2 - startButton.size.height/2)
        addChild(startButton)
    }
    
    override func didMove(to view: SKView) {
        
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: scoreKey)
        
        lblScore = SKLabelNode(fontNamed: "AvenirNext-UltraLight")
        lblScore.fontSize = 20
        lblScore.fontColor = SKColor.darkGray
        lblScore.position = CGPoint(x: playableRect.maxX - 35, y: playableRect.maxY-60)
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        score = 0
        addChild(lblScore)
        
        //self.restartTimer()
        
        levelTimerLabel.fontSize = 20
        levelTimerLabel.fontColor = SKColor.darkGray
        levelTimerLabel.position = CGPoint(x: playableRect.minX + 35, y: playableRect.maxY-60)
        levelTimerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        addChild(levelTimerLabel)
        
        self.addPlayer()

        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
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
        
        let loseAction = SKAction.run() {
            
            /*if self.score > self.highScore {
                let defaults = UserDefaults.standard
                defaults.set(self.score, forKey: self.scoreKey)
            }
            */
            self.overrideHighestScore(highScore: self.score)
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        square.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
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
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if startButton.contains(location) {
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
                self.restartTimer()
                startButton.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if action(forKey: "countdown") != nil {removeAction(forKey: "countdown")}
    }
    
    func pointsForRegGamePlay(square: SKSpriteNode, player: SKSpriteNode) {
        score += 5
        square.removeFromParent()
        
        if (totalSeconds == 0) {
            if score > highScore {
                let defaults = UserDefaults.standard
                defaults.set(score, forKey: scoreKey)
            }
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    func pointsForMatchingColors(square: SKSpriteNode, player: SKSpriteNode) {
        score += 10
        square.removeFromParent()
        
        if (totalSeconds == 0) {
            if score > highScore {
                let defaults = UserDefaults.standard
                defaults.set(score, forKey: scoreKey)
            }
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
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
                    }
                }
                
                if bonusSquareMethodBool == false {
                    //I'm in a normal game state. all collected squares give points. 
                    self.pointsForRegGamePlay(square: square, player: player)
                } else {
                    //I'm in the bonusSq game state. colors have to match in order to be awarded points.
                    //if the colors don't match, then I need to return to the normal game state.
                    
                    if randomGeneratedSquareColor == fallingSquareColor {
                        self.pointsForMatchingColors(square: square, player: player)
                    } else {
                        //need to return to the normal game state.
                        self.pointsForRegGamePlay(square: square, player: player)
                    }
                }
                
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
   
    func randomBonusSquareColorChange() {
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
                randomGeneratedSquareColor = rBSName
            }
        }
        
        randomBonusSquare.run  (
            SKAction.sequence ([
                SKAction.run {
                    self.changeRanSqBooleanToTrue()
                    self.changeBonusSqShowingBooleanToTrue()
                },
                SKAction.wait(forDuration: 10, withRange: 1),
                SKAction.removeFromParent(),
                SKAction.run {
                    self.changeRanSqBooleanToFalse()
                    self.changeBonusSqShowingBooleanToFalse()
                },
                ])
        )
        
    }
    
    func overrideHighestScore(highScore: Int) {
        let lastHighScore = UserDefaults.standard.integer(forKey: scoreKey)
        
        if score > lastHighScore {
            UserDefaults.standard.set(score, forKey: scoreKey)
            UserDefaults.standard.synchronize()
            
            saveHighScore(score: score)
        }
    }
    
    func saveHighScore(score: Int) {
        print ("Player has been authenticated.")
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "com.leaderboard.sklab1")
            scoreReporter.value = Int64(score)
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: { (error) in
                if error != nil {
                    print ("An error has occured: \(error)")
                }
            })
        }
    }

    
    func changeRanSqBooleanToTrue() {
        randomSquareBool = true
        if randomSquareBool == true {
            if let action = levelTimerLabel.action(forKey: "timer") {
                action.speed = 0
            }
        }
    }
    
    func changeRanSqBooleanToFalse() {
        randomSquareBool = false
        if randomSquareBool == false {
            if let action = levelTimerLabel.action(forKey: "timer") {
                action.speed = 1
            }
        }
    }
   
    func changeBonusSqShowingBooleanToTrue() {
        bonusSquareMethodBool = true
    }
    
    func changeBonusSqShowingBooleanToFalse() {
        bonusSquareMethodBool = false
    }
 
}
