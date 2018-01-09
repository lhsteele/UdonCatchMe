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
    
    let background = SKSpriteNode(imageNamed: "LeaderboardBackground")
    let usernameSceneImage = SKSpriteNode(imageNamed: "UsernameSceneImage")
    let backToGameButton = SKSpriteNode(imageNamed: "BackToGameButton")

    var textField0: UITextField!
    var textField0_1: UITextField!
    var textField1: UITextField!
    var textField1_1: UITextField!
    var textField2: UITextField!
    var textField2_1: UITextField!
    var textField3: UITextField!
    var textField3_1: UITextField!
    var textField4: UITextField!
    var textField4_1: UITextField!
    var textField5: UITextField!
    var textField5_1: UITextField!
    var textField6: UITextField!
    var textField6_1: UITextField!
    var textField7: UITextField!
    var textField7_1: UITextField!
    var textField8: UITextField!
    var textField8_1: UITextField!
    var textField9: UITextField!
    var textField9_1: UITextField!
    var playerLabel: UITextField!
    var scoreLabel: UITextField!
    var counterLabel = SKLabelNode()
    var totalLabel = SKLabelNode()
    
    //var username = String()
    
    var userName = String()
    var highScore = Int()
    var listOfEntries = [PlayerEntries]()
    var count = Int()
    var total = Int()
    
    var leaderboardPlayerEntry = String()
    var leaderboardScoreEntry = String()
    var firstPlace = String()
    var secondPlace = String()
    var thirdPlace = String()
    var fourthPlace = String()
    var fifthPlace = String()
    var sixthPlace = String()
    var seventhPlace = String()
    var eigthPlace = String()
    var ninthPlace = String()
    var tenthPlace = String()
    
    
    var playableRect: CGRect
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    
    
    override func sceneDidLoad() {
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
                    self.textField0.removeFromSuperview()
                    self.textField0_1.removeFromSuperview()
                    self.textField1.removeFromSuperview()
                    self.textField1_1.removeFromSuperview()
                    self.textField2.removeFromSuperview()
                    self.textField2_1.removeFromSuperview()
                    self.textField3.removeFromSuperview()
                    self.textField3_1.removeFromSuperview()
                    self.textField4.removeFromSuperview()
                    self.textField4_1.removeFromSuperview()
                    self.textField5.removeFromSuperview()
                    self.textField5_1.removeFromSuperview()
                    self.textField6.removeFromSuperview()
                    self.textField6_1.removeFromSuperview()
                    self.textField7.removeFromSuperview()
                    self.textField7_1.removeFromSuperview()
                    self.textField8.removeFromSuperview()
                    self.textField8_1.removeFromSuperview()
                    self.textField9.removeFromSuperview()
                    self.textField9_1.removeFromSuperview()
                    self.playerLabel.removeFromSuperview()
                    self.scoreLabel.removeFromSuperview()
                    self.counterLabel.removeFromParent()
                })
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        guard let view = self.view else {return}
        let originX = (size.width / 2) / 5
        let originX2 = (size.width / 2)
        playerLabel = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 175, width: size.width / 2.5, height: 35))
        scoreLabel = UITextField(frame: CGRect.init(x: originX2, y: size.height / 2 - 175, width: size.width / 2.5, height: 35))
        
        
        textField0 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 140, width: size.width / 2.5, height: 35))
        textField0_1 = UITextField(frame: CGRect.init(x: originX2, y: size.height / 2 - 140, width: size.width / 2.5, height: 35))
        textField1 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 105, width: size.width / 2.5, height: 35))
        textField1_1 = UITextField(frame: CGRect.init(x: originX2, y: size.height / 2 - 105, width: size.width / 2.5, height: 35))
        textField2 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 70, width: size.width / 2.5, height: 35))
        textField2_1 = UITextField(frame: CGRect.init(x: originX2, y: size.height / 2 - 70, width: size.width / 2.5, height: 35))
        textField3 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 35, width: size.width / 2.5, height: 35))
        textField3_1 = UITextField(frame: CGRect.init(x: originX2, y: size.height / 2 - 35, width: size.width / 2.5, height: 35))
        textField4 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2, width: size.width / 2.5, height: 35))
        textField4_1 = UITextField(frame: CGRect.init(x: originX2, y: size.height / 2, width: size.width / 2.5, height: 35))
        textField5 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 35, width: size.width / 2.5, height: 35))
        textField5_1 = UITextField(frame: CGRect.init(x: originX2, y: size.height / 2 + 35, width: size.width / 2.5, height: 35))
        textField6 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 70, width: size.width / 2.5, height: 35))
        textField6_1 = UITextField(frame: CGRect.init(x: originX2, y: size.height / 2 + 70, width: size.width / 2.5, height: 35))
        textField7 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 105, width: size.width / 2.5, height: 35))
        textField7_1 = UITextField(frame: CGRect.init(x: originX2, y: size.height / 2 + 105, width: size.width / 2.5, height: 35))
        textField8 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 140, width: size.width / 2.5, height: 35))
        textField8_1 = UITextField(frame: CGRect.init(x: originX2, y: size.height / 2 + 140, width: size.width / 2.5, height: 35))
        textField9 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 175, width: size.width / 2.5, height: 35))
        textField9_1 = UITextField(frame: CGRect.init(x: originX2, y: size.height / 2 + 175, width: size.width / 2.5, height: 35))
        view.addSubview(playerLabel)
        view.addSubview(scoreLabel)
        view.addSubview(textField0)
        view.addSubview(textField0_1)
        view.addSubview(textField1)
        view.addSubview(textField1_1)
        view.addSubview(textField2)
        view.addSubview(textField2_1)
        view.addSubview(textField3)
        view.addSubview(textField3_1)
        view.addSubview(textField4)
        view.addSubview(textField4_1)
        view.addSubview(textField5)
        view.addSubview(textField5_1)
        view.addSubview(textField6)
        view.addSubview(textField6_1)
        view.addSubview(textField7)
        view.addSubview(textField7_1)
        view.addSubview(textField8)
        view.addSubview(textField8_1)
        view.addSubview(textField9)
        view.addSubview(textField9_1)
    }
    
    func customize(textField: UITextField, placeholder: String, textFieldText: String?) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftView = paddingView
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName : UIColor.gray])
        textField.text = textFieldText
        
        //textField.layer.borderColor = UIColor.black.cgColor
        //textField.layer.borderWidth = 0.5
        //textField.layer.cornerRadius = 4.0
    }
    
    
    /*
    func textFieldDidChange(textField: UITextField) {
        if textField == self.textField0 {
            self.firstPlace = textField.text!
        }
    }
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        print (topTen)
        count = topTen.count
        total = self.listOfEntries.count
        
        counterLabel.text = "\(count) out of"
        totalLabel.text = "\(total)"
        
        /*
        if total < 10 {
            counterLabel.text = "\(count) out of"
            totalLabel.text = "\(total)"
        } else {
            counterLabel.text = "10 out of"
            totalLabel.text = "\(total)"
        }
        */
    
        var playerTextFieldArray = [textField0, textField1, textField2, textField3, textField4, textField5, textField6, textField7, textField8, textField9]
        var scoreTextFieldArray = [textField0_1, textField1_1, textField2_1, textField3_1, textField4_1, textField5_1, textField6_1, textField7_1, textField8_1, textField9_1]

        for (index, _) in topTen.enumerated() {
            leaderboardScoreEntry = "\(result[index].score)"
            leaderboardPlayerEntry = "\(result[index].playerName)"
            for _ in playerTextFieldArray {
                _ = self.customize(textField: playerTextFieldArray[index]!, placeholder: "Player", textFieldText: leaderboardPlayerEntry)
                _ = self.customize(textField: scoreTextFieldArray[index]!, placeholder: "Score", textFieldText: leaderboardScoreEntry)
            }
        }
        customize(textField: playerLabel, placeholder: "", textFieldText: "Player")
        customize(textField: scoreLabel, placeholder: "", textFieldText: "Score")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

