//
//  Leaderboard.swift
//  SKLab1
//
//  Created by Lisa Steele on 12/13/17.
//  Copyright © 2017 lisahsteele. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import Firebase
import FirebaseDatabase

struct PlayerEntries {
    var playerName: String
    var score: Int
    
    init(playerName: String, score: Int) {
        self.playerName = playerName
        self.score = score
    }
}

class Leaderboard: SKScene, UITextFieldDelegate {
    
    //let background = SKSpriteNode(imageNamed: "LeaderboardBackground")
    var background: SKSpriteNode! = nil
    let usernameSceneImage = SKSpriteNode(imageNamed: "UsernameSceneImage")
    let backToGameButton = SKSpriteNode(imageNamed: "BackToGameButton")

    var label0: UILabel!
    var label0_1: UILabel!
    var label1: UILabel!
    var label1_1: UILabel!
    var label2: UILabel!
    var label2_1: UILabel!
    var label3: UILabel!
    var label3_1: UILabel!
    var label4: UILabel!
    var label4_1: UILabel!
    var label5: UILabel!
    var label5_1: UILabel!
    var label6: UILabel!
    var label6_1: UILabel!
    var label7: UILabel!
    var label7_1: UILabel!
    var label8: UILabel!
    var label8_1: UILabel!
    var label9: UILabel!
    var label9_1: UILabel!
    
    var playerLabel: UILabel!
    var scoreLabel: UILabel!
    var currentPlayerLabel: UILabel!
    var counterLabel = SKLabelNode()
    var totalLabel = SKLabelNode()
    
    var userName = String()
    var highScore = Int()
    var listOfEntries = [PlayerEntries]()
    var count = Int()
    var total = Int()
    
    var leaderboardPlayerEntry = String()
    var leaderboardScoreEntry = String()

    let scoreKey = "SKLab_Highscore"
    
    var playableRect: CGRect
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    
    
    override func sceneDidLoad() {
        if UIScreen.main.sizeType == .iphone4 {
            background = SKSpriteNode(imageNamed: "LeaderboardBackground4")
        } else if UIScreen.main.sizeType == .iphone5 {
            background = SKSpriteNode(imageNamed: "LeaderboardBackground5s")
        } else if UIScreen.main.sizeType == .iphone6 {
            background = SKSpriteNode(imageNamed: "LeaderboardBackground6")
        } else if UIScreen.main.sizeType == .iphonePlus {
            background = SKSpriteNode(imageNamed: "LeaderboardBackgroundPlus")
        }
        
        background.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        usernameSceneImage.position = CGPoint(x: size.width/2, y: (deviceHeight - deviceHeight) + usernameSceneImage.size.height / 1.5)
        addChild(usernameSceneImage)
        
        backToGameButton.position = CGPoint(x: (size.width - size.width) + 75, y: (size.height - size.height) + 30)
        addChild(backToGameButton)
    
        counterLabel.position = CGPoint(x: size.width - 50, y: (size.height - size.height) + 50)
        counterLabel.fontColor = SKColor.black
        counterLabel.fontSize = 15
        addChild(counterLabel)
        
        totalLabel.position = CGPoint(x: size.width - 50, y: (size.height - size.height) + 30)
        totalLabel.fontColor = SKColor.black
        totalLabel.fontSize = 15
        addChild(totalLabel)
        
        self.loadHighScores()
        
        
    }
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = deviceHeight / deviceWidth
        let playableWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - playableWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if backToGameButton.contains(location) {
                let scene = GameScene(size: size)
                self.view?.presentScene(scene)
                DispatchQueue.main.async(execute: {
                    self.label0.removeFromSuperview()
                    self.label0_1.removeFromSuperview()
                    self.label1.removeFromSuperview()
                    self.label1_1.removeFromSuperview()
                    self.label2.removeFromSuperview()
                    self.label2_1.removeFromSuperview()
                    self.label3.removeFromSuperview()
                    self.label3_1.removeFromSuperview()
                    self.label4.removeFromSuperview()
                    self.label4_1.removeFromSuperview()
                    self.label5.removeFromSuperview()
                    self.label5_1.removeFromSuperview()
                    self.label6.removeFromSuperview()
                    self.label6_1.removeFromSuperview()
                    self.label7.removeFromSuperview()
                    self.label7_1.removeFromSuperview()
                    self.label8.removeFromSuperview()
                    self.label8_1.removeFromSuperview()
                    self.label9.removeFromSuperview()
                    self.label9_1.removeFromSuperview()
                    //self.playerLabel.removeFromSuperview()
                    //self.scoreLabel.removeFromSuperview()
                    self.currentPlayerLabel.removeFromSuperview()
                    self.counterLabel.removeFromParent()
                })
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        guard let view = self.view else {return}
        let originX = (size.width / 2) / 5
        let originX2 = (size.width / 2)

        //playerLabel = UILabel(frame: CGRect.init(x: originX, y: size.height / 2 - 175, width: size.width / 2.5, height: 35))
        //scoreLabel = UILabel(frame: CGRect.init(x: originX2, y: size.height / 2 - 175, width: size.width / 2.5, height: 35))
        //currentPlayerLabel = UILabel(frame: CGRect.init(x: originX, y: size.height / 2 + 210, width: size.width / 1.25, height: 35))
        currentPlayerLabel = UILabel(frame: CGRect.init(x: originX, y: size.height / 2 - 175, width: size.width / 1.25, height: 35))
        label0 = UILabel(frame: CGRect.init(x: originX, y: size.height / 2 - 140, width: size.width / 2.5, height: 35))
        label0_1 = UILabel(frame: CGRect.init(x: originX2, y: size.height / 2 - 140, width: size.width / 2.5, height: 35))
        label1 = UILabel(frame: CGRect.init(x: originX, y: size.height / 2 - 105, width: size.width / 2.5, height: 35))
        label1_1 = UILabel(frame: CGRect.init(x: originX2, y: size.height / 2 - 105, width: size.width / 2.5, height: 35))
        label2 = UILabel(frame: CGRect.init(x: originX, y: size.height / 2 - 70, width: size.width / 2.5, height: 35))
        label2_1 = UILabel(frame: CGRect.init(x: originX2, y: size.height / 2 - 70, width: size.width / 2.5, height: 35))
        label3 = UILabel(frame: CGRect.init(x: originX, y: size.height / 2 - 35, width: size.width / 2.5, height: 35))
        label3_1 = UILabel(frame: CGRect.init(x: originX2, y: size.height / 2 - 35, width: size.width / 2.5, height: 35))
        label4 = UILabel(frame: CGRect.init(x: originX, y: size.height / 2, width: size.width / 2.5, height: 35))
        label4_1 = UILabel(frame: CGRect.init(x: originX2, y: size.height / 2, width: size.width / 2.5, height: 35))
        label5 = UILabel(frame: CGRect.init(x: originX, y: size.height / 2 + 35, width: size.width / 2.5, height: 35))
        label5_1 = UILabel(frame: CGRect.init(x: originX2, y: size.height / 2 + 35, width: size.width / 2.5, height: 35))
        label6 = UILabel(frame: CGRect.init(x: originX, y: size.height / 2 + 70, width: size.width / 2.5, height: 35))
        label6_1 = UILabel(frame: CGRect.init(x: originX2, y: size.height / 2 + 70, width: size.width / 2.5, height: 35))
        label7 = UILabel(frame: CGRect.init(x: originX, y: size.height / 2 + 105, width: size.width / 2.5, height: 35))
        label7_1 = UILabel(frame: CGRect.init(x: originX2, y: size.height / 2 + 105, width: size.width / 2.5, height: 35))
        label8 = UILabel(frame: CGRect.init(x: originX, y: size.height / 2 + 140, width: size.width / 2.5, height: 35))
        label8_1 = UILabel(frame: CGRect.init(x: originX2, y: size.height / 2 + 140, width: size.width / 2.5, height: 35))
        label9 = UILabel(frame: CGRect.init(x: originX, y: size.height / 2 + 175, width: size.width / 2.5, height: 35))
        label9_1 = UILabel(frame: CGRect.init(x: originX2, y: size.height / 2 + 175, width: size.width / 2.5, height: 35))

        //view.addSubview(playerLabel)
        //view.addSubview(scoreLabel)
        view.addSubview(currentPlayerLabel)
        view.addSubview(label0)
        view.addSubview(label0_1)
        view.addSubview(label1)
        view.addSubview(label1_1)
        view.addSubview(label2)
        view.addSubview(label2_1)
        view.addSubview(label3)
        view.addSubview(label3_1)
        view.addSubview(label4)
        view.addSubview(label4_1)
        view.addSubview(label5)
        view.addSubview(label5_1)
        view.addSubview(label6)
        view.addSubview(label6_1)
        view.addSubview(label7)
        view.addSubview(label7_1)
        view.addSubview(label8)
        view.addSubview(label8_1)
        view.addSubview(label9)
        view.addSubview(label9_1)
    }
    
    func customize(label: UILabel, labelText: String?) {
        label.text = labelText
        label.textColor = UIColor.darkGray
        if UIScreen.main.sizeType == .iphone4 {
            label.font = UIFont(name: "AvenirNext-Light", size: 10)
        } else {
            label.font = UIFont(name: "AvenirNext-Light", size: 20)
        }
    }
    
    func loadHighScores() {
        let ref: DatabaseReference!
        ref = Database.database().reference().child("Users")
        ref.observe(.value, with: { (snapshot) in
            let entries = snapshot.children
            for entry in entries {
                if let pair = entry as? DataSnapshot {
                    if let score = pair.value {
                        let name = pair.key
                        self.userName = name
                        self.highScore = score as! Int
                    }
                    let player = PlayerEntries(playerName: self.userName, score: self.highScore)
                    self.listOfEntries.append(player)
                }
            }
            self.populateLeaderboard()
        })
    }
    
    func populateLeaderboard() {
        let result = self.listOfEntries.sorted{ $0.score > $1.score }
        let topTen = result.prefix(10)
        count = topTen.count
        total = self.listOfEntries.count
        
        counterLabel.text = "\(count) out of"
        totalLabel.text = "\(total)"
        
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: scoreKey)

        var playerTextFieldArray = [label0, label1, label2, label3, label4, label5, label6, label7, label8, label9]
        var scoreTextFieldArray = [label0_1, label1_1, label2_1, label3_1, label4_1, label5_1, label6_1, label7_1, label8_1, label9_1]

        for (index, _) in topTen.enumerated() {
            leaderboardScoreEntry = "\(result[index].score)"
            leaderboardPlayerEntry = "\(result[index].playerName)"
            for _ in playerTextFieldArray {

                _ = self.customize(label: playerTextFieldArray[index]!, labelText: leaderboardPlayerEntry)
                _ = self.customize(label: scoreTextFieldArray[index]!, labelText: leaderboardScoreEntry)
            }
        }
        //customize(label: playerLabel, labelText: "Player")
        //customize(label: scoreLabel, labelText: "Score")
        customize(label: currentPlayerLabel, labelText: "Your high score is: \(highScore)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

