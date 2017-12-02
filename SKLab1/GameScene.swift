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
    static let Food : UInt32 = 0b1
    static let Player : UInt32 = 0b10
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player = SKSpriteNode(imageNamed: "UdonBowl")
    var topLayerBackground = SKSpriteNode(imageNamed: "Background")
    var isFingerOnPlayer = false
    var touchedPlayerNode: SKNode!
    
    var score : Int = 0 {
        didSet {
            lblScore.text = "\(score)"
        }
    }
    var scoreText: SKLabelNode!
    var lblScore: SKLabelNode!
    let scoreKey = "SKLab_Highscore"
    var highScore = 10
    var showingHighScore = false
    
    var levelTimerLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
    var count = 10
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    let playableRect: CGRect
    var gameTimer = Timer()
   
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
    
    var background = SKSpriteNode(imageNamed: "Background")
    
    static var currentScore = 0
    var highScoreNode = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
    
    static var gameWonBoolean = true
    static var itsADraw = false
    
    override func sceneDidLoad() {
        /*
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: scoreKey)
        defaults.removeObject(forKey: scoreKey)
        */
    }
    
    override func didMove(to view: SKView) {
        
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: scoreKey)
        
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        startButton = SKSpriteNode(texture: startButtonTexture)
        startButton.position = CGPoint(x: size.width/2, y: size.height/2 - startButton.size.height/2)
        startButton.zPosition = 1
        addChild(startButton)
        
        highScoreNode.text = "High Score: \(highScore)"
        highScoreNode.fontSize = 20
        highScoreNode.fontColor = SKColor.darkGray
        highScoreNode.position = CGPoint(x: size.width/2, y: size.height/2 + 25)
        highScoreNode.zPosition = 2
        addChild(highScoreNode)
        
        scoreText = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        scoreText.text = "Score:"
        scoreText.fontSize = 20
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: playableRect.maxX - 35, y: playableRect.maxY - 60)
        scoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        scoreText.zPosition = 3
        addChild(scoreText)
        
        lblScore = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        lblScore.fontSize = 20
        lblScore.fontColor = SKColor.white
        lblScore.position = CGPoint(x: scoreText.position.x, y: scoreText.position.y - 25)
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        score = 0
        lblScore.zPosition = 4
        addChild(lblScore)
        
        levelTimerLabel.fontSize = 20
        levelTimerLabel.fontColor = SKColor.white
        levelTimerLabel.position = CGPoint(x: playableRect.minX + 35, y: playableRect.maxY - 60)
        levelTimerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        levelTimerLabel.zPosition = 5
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
        addChild(topLayerBackground)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addSquare() {
        var foods = [SKSpriteNode]()
        let egg = SKSpriteNode(imageNamed: "Egg")
        let ebiTempura = SKSpriteNode(imageNamed: "EbiTempura")
        let enoki = SKSpriteNode(imageNamed: "Enoki")
        let kamaboko = SKSpriteNode(imageNamed: "Kamaboko")
        let bokChoi = SKSpriteNode(imageNamed: "BokChoi")
        
        egg.name = "egg"
        ebiTempura.name = "ebiTempura"
        enoki.name = "enoki"
        kamaboko.name = "kamaboko"
        bokChoi.name = "bokChoi"
        
        foods.append(egg)
        foods.append(ebiTempura)
        foods.append(enoki)
        foods.append(kamaboko)
        foods.append(bokChoi)
        
        let randomSquareGenerator = Int(arc4random_uniform(UInt32(foods.count)))
        let food = foods[randomSquareGenerator]
        
        var actualX = random(min: ebiTempura.size.height/2, max: size.height - ebiTempura.size.height/2)
        actualX = max(actualX, ebiTempura.size.width/2)
        actualX = min(actualX, size.width - ebiTempura.size.width/2)
 
        
        food.position = CGPoint(x: actualX, y: size.height + ebiTempura.size.height)
        
        addChild(food)
        
        food.physicsBody = SKPhysicsBody(rectangleOf: food.size)
        food.physicsBody?.isDynamic = true
        food.physicsBody?.categoryBitMask = PhysicsCategory.Food
        food.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        food.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let actualDuration = random(min: CGFloat(4.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -ebiTempura.size.width/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        let loseAction = SKAction.run() {
            
            self.overrideHighestScore(highScore: self.score)
            
        }
        food.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
        switch score {
        case 0...75:
            food.speed = 1
        case 76...150:
            food.speed = 1.1
        case 151...225:
            food.speed = 1.2
        case 226...300:
            food.speed = 1.3
        case 301...375:
            food.speed = 1.4
        default: speed = 1.5
        }
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
            player.physicsBody?.contactTestBitMask = PhysicsCategory.Food
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
                highScoreNode.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if action(forKey: "countdown") != nil {removeAction(forKey: "countdown")}
    }
    
    func pointsForRegGamePlay(food: SKSpriteNode, player: SKSpriteNode) {
        score += 5
        food.removeFromParent()
        
        if (totalSeconds == 0) {
            if score > highScore {
                let defaults = UserDefaults.standard
                defaults.set(score, forKey: scoreKey)
            }
        }
    }
    
    func pointsForMatchingColors(food: SKSpriteNode, player: SKSpriteNode) {
        score += 10
        food.removeFromParent()
        let centerPosition = CGPoint(x: (player.position.x + food.position.x)/2, y: (player.position.y + food.position.y)/2 - 8)
        
        let bonusScoreLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        bonusScoreLabel.fontSize = 40
        bonusScoreLabel.fontColor = SKColor.orange
        bonusScoreLabel.text = "+10!"
        bonusScoreLabel.position = centerPosition
        bonusScoreLabel.zPosition = 300
        addChild(bonusScoreLabel)
        
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy:3), duration: 0.7)
        moveAction.timingMode = .easeOut
        bonusScoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        
        if (totalSeconds == 0) {
            if score > highScore {
                let defaults = UserDefaults.standard
                defaults.set(score, forKey: scoreKey)
            }
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
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Food != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Player != 0)) {
            
            if let food = firstBody.node as? SKSpriteNode, let
                player = secondBody.node as? SKSpriteNode {
            
                if let sq = food as SKSpriteNode! {
                    if let sqName = sq.name {
                        fallingSquareColor = sqName
                    }
                }
                
                if bonusSquareMethodBool == false {
                    self.pointsForRegGamePlay(food: food, player: player)
                } else {
                    if randomGeneratedSquareColor == fallingSquareColor {
                        self.pointsForMatchingColors(food: food, player: player)
                    } else {
                        self.pointsForRegGamePlay(food: food, player: player)
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
        var bonusFoods = [SKSpriteNode]()
        let bonusEgg = SKSpriteNode(imageNamed: "BigEgg")
        let bonusEbiTempura = SKSpriteNode(imageNamed: "BigEbiTempura")
        let bonusEnoki = SKSpriteNode(imageNamed: "BigEnoki")
        let bonusKamaboko = SKSpriteNode(imageNamed: "BigKamaboko")
        let bonusBokChoi = SKSpriteNode(imageNamed: "BigBokChoi")
        
        bonusEgg.name = "egg"
        bonusEbiTempura.name = "ebiTempura"
        bonusEnoki.name = "enoki"
        bonusKamaboko.name = "kamaboko"
        bonusBokChoi.name = "bokChoi"
        
        bonusFoods.append(bonusEgg)
        bonusFoods.append(bonusEbiTempura)
        bonusFoods.append(bonusEnoki)
        bonusFoods.append(bonusKamaboko)
        bonusFoods.append(bonusBokChoi)
        
        let randomBonusFoodGenerator = Int(arc4random_uniform(UInt32(bonusFoods.count)))
        let randomBonusFood = bonusFoods[randomBonusFoodGenerator]
        
        
        randomBonusFood.position = CGPoint(x: self.playableRect.maxX - 200, y: self.playableRect.maxY - 50)
        addChild(randomBonusFood)
        
        if let rBF = randomBonusFood as SKSpriteNode! {
            if let rBFName = rBF.name {
                randomGeneratedSquareColor = rBFName
            }
        }
        
        randomBonusFood.run  (
            SKAction.sequence ([
                SKAction.run {
                    self.changeRanSqBooleanToTrue()
                    self.changeBonusSqShowingBooleanToTrue()
                },
                SKAction.wait(forDuration: 10, withRange: 5),
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
        print ("lastHighScore \(lastHighScore)")
        GameScene.currentScore = score
        
        if score > lastHighScore {
            UserDefaults.standard.set(score, forKey: scoreKey)
            UserDefaults.standard.synchronize()
            saveHighScore(score: score)
            GameScene.gameWonBoolean = true
            GameScene.itsADraw = false
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size)
            self.view?.presentScene(gameOverScene, transition: reveal)
        } else if score == lastHighScore {
            GameScene.itsADraw = true
            GameScene.gameWonBoolean = false
            print ("it's a draw")
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size)
            self.view?.presentScene(gameOverScene, transition: reveal)
        } else if score == 0 {
            GameScene.gameWonBoolean = false
            GameScene.itsADraw = false
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size)
            self.view?.presentScene(gameOverScene, transition: reveal)
        } else {
            GameScene.gameWonBoolean = false
            GameScene.itsADraw = false
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        /*
        if score == lastHighScore {
            GameScene.itsADraw = true
            GameScene.gameWonBoolean = false
            print ("it's a draw")
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size)
            self.view?.presentScene(gameOverScene, transition: reveal)
        } else if score > lastHighScore {
            UserDefaults.standard.set(score, forKey: scoreKey)
            UserDefaults.standard.synchronize()
            saveHighScore(score: score)
            GameScene.gameWonBoolean = true
            
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size)
            self.view?.presentScene(gameOverScene, transition: reveal)
        } else {
            GameScene.gameWonBoolean = false
            
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        */
    }
    
    func saveHighScore(score: Int) {
        print ("Player has been authenticated.")
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "com.leaderboard.sklab1")
            scoreReporter.value = Int64(score)
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: { (error) in
                if error != nil {
                    print ("An error has occured: \(String(describing: error))")
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
