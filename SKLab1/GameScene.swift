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
    
    //var player = SKSpriteNode(imageNamed: "Bowl")
    var player = SKSpriteNode(imageNamed: "UdonBowl")
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
   /*
    let sqOneColor = UIColor(red: 1.82, green: 1.39, blue: 0.27, alpha: 1)
    let sqTwoColor = UIColor(red: 1.82, green: 0.27, blue: 1.12, alpha: 1)
    let sqThreeColor = UIColor(red: 0.27, green: 1.82, blue: 1.64, alpha: 1)
    let sqFourColor = UIColor(red: 0.27, green: 0.45, blue: 1.82, alpha: 1)
   */
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
        var foods = [SKSpriteNode]()
        
        let apple = SKSpriteNode(imageNamed: "Apple")
        let bread = SKSpriteNode(imageNamed: "Bread")
        let broccoli = SKSpriteNode(imageNamed: "Broccoli")
        let coconut = SKSpriteNode(imageNamed: "Coconut")
        let flower = SKSpriteNode(imageNamed: "Flower")
        let milk = SKSpriteNode(imageNamed: "Milk")
        let orange = SKSpriteNode(imageNamed: "Orange")
        
        apple.name = "apple"
        bread.name = "bread"
        broccoli.name = "broccoli"
        coconut.name = "coconut"
        flower.name = "flower"
        milk.name = "milk"
        orange.name = "orange"
        
        foods.append(apple)
        foods.append(bread)
        foods.append(broccoli)
        foods.append(coconut)
        foods.append(flower)
        foods.append(milk)
        foods.append(orange)
        
        let randomSquareGenerator = Int(arc4random_uniform(UInt32(foods.count)))
        let food = foods[randomSquareGenerator]
        
        var actualX = random(min: apple.size.height/2, max: size.height - apple.size.height/2)
        actualX = max(actualX, apple.size.width/2)
        actualX = min(actualX, size.width - apple.size.width/2)
 
        
        food.position = CGPoint(x: actualX, y: size.height + apple.size.height)
        
        addChild(food)
        
        food.physicsBody = SKPhysicsBody(rectangleOf: food.size)
        food.physicsBody?.isDynamic = true
        food.physicsBody?.categoryBitMask = PhysicsCategory.Food
        food.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        food.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let actualDuration = random(min: CGFloat(4.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -apple.size.width/2), duration: TimeInterval(actualDuration))
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
        food.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
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
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    func pointsForMatchingColors(food: SKSpriteNode, player: SKSpriteNode) {
        score += 10
        food.removeFromParent()
        
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
                    //I'm in a normal game state. all collected squares give points. 
                    self.pointsForRegGamePlay(food: food, player: player)
                } else {
                    //I'm in the bonusSq game state. colors have to match in order to be awarded points.
                    //if the colors don't match, then I need to return to the normal game state.
                    
                    if randomGeneratedSquareColor == fallingSquareColor {
                        self.pointsForMatchingColors(food: food, player: player)
                    } else {
                        //need to return to the normal game state.
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
        
        let bonusApple = SKSpriteNode(imageNamed: "BigApple")
        let bonusBread = SKSpriteNode(imageNamed: "BigBread")
        let bonusBroccoli = SKSpriteNode(imageNamed: "BigBroccoli")
        let bonusCoconut = SKSpriteNode(imageNamed: "BigCoconut")
        let bonusFlower = SKSpriteNode(imageNamed: "BigFlower")
        let bonusMilk = SKSpriteNode(imageNamed: "BigMilk")
        let bonusOrange = SKSpriteNode(imageNamed: "BigOrange")
        
        bonusApple.name = "apple"
        bonusBread.name = "bread"
        bonusBroccoli.name = "broccoli"
        bonusCoconut.name = "coconut"
        bonusFlower.name = "flower"
        bonusMilk.name = "milk"
        bonusOrange.name = "orange"
        
        bonusFoods.append(bonusApple)
        bonusFoods.append(bonusBread)
        bonusFoods.append(bonusBroccoli)
        bonusFoods.append(bonusCoconut)
        bonusFoods.append(bonusFlower)
        bonusFoods.append(bonusMilk)
        bonusFoods.append(bonusOrange)
        
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
